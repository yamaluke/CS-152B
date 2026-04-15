`timescale 1ns / 1ps

module tx_tb();

reg clk;
reg rst;
reg start;
reg [7:0] data;
wire tx_line;

reg correct;
integer testNum;

// Instantiate TX
tx my_tx(
    .clk_100mhz(clk),
    .rst(rst),
    .start(start),
    .data(data),
    .tx_line(tx_line)
);

// Clock generation
// countMax = 2 for testing, so period is 4 cycles
always begin
    #0.5 clk = ~clk; 
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tx_tb);
    clk = 0;
    rst = 0;
    start = 0;
    data = 8'b10101010;
    correct = 1;

    // reset check
    testNum = 1;
    start = 1;
    #1.5;
    start = 0;
    #3;
    rst = 1;
    #3;
    rst = 0;

    if (tx_line != 1) correct = 0;

    // regular transmission check 1
    correct = 1;
    testNum = 2;
    #3;
    start = 1;
    #6.01;
    start = 0;
    if(tx_line != 0) correct = 0;
    #2;
    correct = 1;
    if(tx_line != data[0]) correct = 0;
    testNum = 3;
    #3;
    correct = 1;
    if(tx_line != data[1]) correct = 0;
    testNum = 4;
    #3;
    correct = 1;
    if(tx_line != data[2]) correct = 0;
    testNum = 5;
    #3;
    correct = 1;
    if(tx_line != data[3]) correct = 0;
    testNum = 6;
    #3;
    correct = 1;
    if(tx_line != data[4]) correct = 0;
    testNum = 7;
    #3;
    correct = 1;
    if(tx_line != data[5]) correct = 0;
    testNum = 8;
    #3;
    correct = 1;
    if(tx_line != data[6]) correct = 0;
    testNum = 9;
    #3;
    correct = 1;
    if(tx_line != data[7]) correct = 0;
    testNum = 10;
    #3;
    correct = 1;
    if(tx_line != 1) correct = 0;
    testNum = 11;

    // change in data between transmission should not affect current transmission
    #3;
    testNum = 12;
    rst = 1;
    #1;
    rst = 0;
    #3;
    correct = 1;
    if (tx_line != 1) correct = 0;
    #3;
    start = 1;
    #6;
    start = 0;
    correct = 1;
    if(tx_line != 0) correct = 0;
    #3;
    correct = 1;
    if(tx_line != data[0]) correct = 0;
    testNum = 13;
    #3;
    correct = 1;
    if(tx_line != data[1]) correct = 0;
    testNum = 14;
    #3;
    correct = 1;
    if(tx_line != data[2]) correct = 0;
    testNum = 15;
    data = ~data; // change data to make sure it is latched in at the beginning of transmission, not updated in the middle
    #3;
    correct = 1;
    if(tx_line != ~data[3]) correct = 0;
    testNum = 16;
    #3;
    correct = 1;
    if(tx_line != ~data[4]) correct = 0;
    testNum = 17;
    #3;
    correct = 1;
    if(tx_line != ~data[5]) correct = 0;
    testNum = 18;
    #3;
    correct = 1;
    if(tx_line != ~data[6]) correct = 0;
    testNum = 19;
    #3;
    correct = 1;
    if(tx_line != ~data[7]) correct = 0;
    testNum = 20;
    #3;
    correct = 1;
    if(tx_line != 1) correct = 0;
    testNum = 21;

    // check another regular transmission 
    data = 8'b01010101;
    testNum = 22;
    correct = 1;
    if (tx_line != 1) correct = 0;
    #3;
    start = 1;
    #6;
    start = 0;
    correct = 1;
    if(tx_line != 0) correct = 0;
    #3;
    correct = 1;
    if(tx_line != data[0]) correct = 0;
    testNum = 23;
    #3;
    correct = 1;
    if(tx_line != data[1]) correct = 0;
    testNum = 24;
    #3;
    correct = 1;
    if(tx_line != data[2]) correct = 0;
    testNum = 25;
    data = data; 
    #3;
    correct = 1;
    if(tx_line != data[3]) correct = 0;
    testNum = 26;
    #3;
    correct = 1;
    if(tx_line != data[4]) correct = 0;
    testNum = 27;
    #3;
    correct = 1;
    if(tx_line != data[5]) correct = 0;
    testNum = 28;
    #3;
    correct = 1;
    if(tx_line != data[6]) correct = 0;
    testNum = 29;
    #3;
    correct = 1;
    if(tx_line != data[7]) correct = 0;
    testNum = 30;
    #3;
    correct = 1;
    if(tx_line != 1) correct = 0;
    testNum = 31;

    // check reset between transmission
    data = 8'b00100101;
    testNum = 32;
    correct = 1;
    if (tx_line != 1) correct = 0;
    #3;
    start = 1;
    #6;
    start = 0;
    correct = 1;
    if(tx_line != 0) correct = 0;
    #3;
    correct = 1;
    if(tx_line != data[0]) correct = 0;
    testNum = 33;
    #3;
    correct = 1;
    if(tx_line != data[1]) correct = 0;
    testNum = 34;
    #3;
    correct = 1;
    if(tx_line != data[2]) correct = 0;
    testNum = 35;
    data = data; 
    #3;
    correct = 1;
    if(tx_line != data[3]) correct = 0;
    testNum = 36;
    rst = 1;
    #3;
    rst = 0;
    correct = 1;
    if(tx_line != 1'b1) correct = 0;
    testNum = 37;
    #3;
    correct = 1;
    if(tx_line != 1'b1) correct = 0;
    testNum = 38;
    #3;
    correct = 1;
    if(tx_line != 1'b1) correct = 0;
    testNum = 39;
    #3;
    correct = 1;
    if(tx_line != 1'b1) correct = 0;
    testNum = 40;
    #3;
    correct = 1;
    if(tx_line != 1'b1) correct = 0;
    testNum = 41;


    // Finish
    #5;
    $finish;
    $stop;
end

endmodule