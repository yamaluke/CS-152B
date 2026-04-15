`timescale 1ns / 1ps

module rx_tb();

reg clk;
reg rst;
reg rx_line;
wire [7:0] data;

reg correct;
integer testNum;

reg [7:0] d;
reg [9:0] d_10; // for testing 10 bit frame
integer i;

// Instantiate RX
rx my_rx (
    .clk_100mhz(clk),
    .rst(rst),
    .rx_line(rx_line),
    .data(data)
);

// Clock
always begin
    #0.5 clk = ~clk;
end

initial begin
    $dumpfile("rx_wave.vcd");
    $dumpvars(0, rx_tb);
    clk = 0;
    rst = 0;
    rx_line = 1; 
    correct = 1;

    //= reset check =//
    testNum = 1;
    #3;
    rst = 1;
    #3;
    rst = 0;

    if (data != 8'b00000000) correct = 0;

    //= receive byte =//
    testNum = 2;
    d = 8'b11001100;
    #3;
    // Start bit
    rx_line = 0;
    #3;
    // Data bits
    for (i = 0; i < 8; i = i + 1) begin
        rx_line = d[i];
        #3;
    end
    // Stop bit
    rx_line = 1;
    #3;

    if (data != d) correct = 0;
    #3;
    correct = 1;

    //== 2nd recieve, to make sure that data will overwrite ==//
    testNum = 3;
    d = 8'b01010101;
    #3;
    // Start bit
    rx_line = 0;
    #3;
    // Data bits
    for (i = 0; i < 8; i = i + 1) begin
        rx_line = d[i];
        #3;
    end
    // Stop bit
    rx_line = 1;
    #3;

    if (data != d) correct = 0;
    #3;
    correct = 1;
    

    //= receive 10 bit frame, make sure only the first =//
    testNum = 4;
    d = 8'b10111010;
    d_10 = {2'b11,d}; // add 2 more bits at the end, should be ignored
    #3;
    // Start bit
    rx_line = 0;
    #3;
    // Data bits
    for (i = 0; i < 10; i = i + 1) begin
        rx_line = d_10[i];
        #3;
    end
    // Stop bit
    rx_line = 1;
    #3;

    if (data != d) correct = 0;
    #3;
    correct = 1;

    //= reset mid receiving =//
    testNum = 5;
    d = 8'b11111111;
    #3;
    // Start bit
    rx_line = 0;
    #3;
    // Data bits
    for (i = 0; i < 3; i = i + 1) begin
        rx_line = d[i];
        #3;
    end
    rst = 1; // reset in the middle of transmission, should reset everything
    for (i = 3; i < 8; i = i + 1) begin
        rx_line = d[i];
        #3;
        rst = 0;
    end
    // Stop bit
    rx_line = 1;
    #3;

    if (data != 8'b00000000) correct = 0;
    #3;
    correct = 1;


    //== no stop bit ==//
    testNum = 6;
    d = 8'b01010101;
    #3;
    // Start bit
    rx_line = 0;
    #3;
    // Data bits
    for (i = 0; i < 8; i = i + 1) begin
        rx_line = d[i];
        #3;
    end
    // Stop bit
    // rx_line = 1;
    #3;

    if (data != 8'b00000000) correct = 0;
    #3;
    correct = 1;

    // Finish
    #5;
    $finish;
    $stop;
end

endmodule