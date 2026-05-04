`timescale 1ns / 1ps

module rx_decode_tb();

reg clk;
reg rst;
reg rx_line;

wire [7:0] cmd;
wire [15:0] addr;
wire [15:0] len;
wire [7:0] payload;
wire payload_valid;
wire packet_done;
wire crc_error;

integer i;
integer testNum;
reg correct;

// test packet bytes
reg [7:0] packet [0:15];
reg [7:0] crc;

//====================================================
// DUT
//====================================================

rx_decode dut (
    .clk(clk),
    .rst(rst),
    .rx_line(rx_line),

    .cmd(cmd),
    .addr(addr),
    .len(len),
    .payload(payload),
    .payload_valid(payload_valid),
    .packet_done(packet_done),
    .crc_error(crc_error)
);

//====================================================
// Clock
//====================================================

always begin
    #0.5 clk = ~clk;
end

//====================================================
// Task: Send one UART byte
//
// Format:
// start(0) + 8 data bits LSB first + stop(1)
//
// Using #3 like your rx_tb because your rx.v
// test mode uses short timing
//====================================================

task send_uart_byte;
    input [7:0] byte_in;
    integer j;
    begin
        // idle
        rx_line = 1;
        #3;

        // start bit
        rx_line = 0;
        #3;

        // data bits (LSB first)
        for (j = 0; j < 8; j = j + 1) begin
            rx_line = byte_in[j];
            #3;
        end

        // stop bit
        rx_line = 1;
        #3;
    end
endtask

//====================================================
// Task: Build CRC
//
// CRC = XOR of CMD through PAYLOAD
//====================================================

task calc_crc;
    input integer total_bytes;
    integer k;
    begin
        crc = 8'h00;

        // skip SOF (packet[0])
        for (k = 1; k < total_bytes; k = k + 1)
            crc = crc ^ packet[k];
    end
endtask

//====================================================
// Initial
//====================================================

initial begin
    $dumpfile("rx_decode_wave.vcd");
    $dumpvars(0, rx_decode_tb);

    clk = 0;
    rst = 0;
    rx_line = 1;
    correct = 1;

    //------------------------------------------------
    // TEST 1 : Reset check
    //------------------------------------------------

    testNum = 1;
    #3;
    rst = 1;
    #3;
    rst = 0;
    #5;

    if (packet_done != 0) correct = 0;
    if (crc_error != 0) correct = 0;

    //------------------------------------------------
    // TEST 2 : Valid packet
    //
    // [AA]
    // [01]
    // [00 10]
    // [00 04]
    // [11 22 33 44]
    // [CRC]
    //------------------------------------------------

    correct = 1;
    testNum = 2;

    packet[0] = 8'hAA; // SOF
    packet[1] = 8'h01; // CMD
    packet[2] = 8'h00; // ADDR HI
    packet[3] = 8'h10; // ADDR LO
    packet[4] = 8'h00; // LEN HI
    packet[5] = 8'h04; // LEN LO
    packet[6] = 8'h11;
    packet[7] = 8'h22;
    packet[8] = 8'h33;
    packet[9] = 8'h44;

    calc_crc(10);
    packet[10] = crc;

    for (i = 0; i <= 10; i = i + 1)
        send_uart_byte(packet[i]);

    #20;

    if (cmd != 8'h01) correct = 0;
    if (addr != 16'h0010) correct = 0;
    if (len != 16'h0004) correct = 0;
    if (packet_done != 1'b1) correct = 0;
    if (crc_error != 1'b0) correct = 0;

    //------------------------------------------------
    // TEST 3 : Bad CRC
    //------------------------------------------------

    correct = 1;
    testNum = 3;

    packet[0] = 8'hAA;
    packet[1] = 8'h02;
    packet[2] = 8'h00;
    packet[3] = 8'h20;
    packet[4] = 8'h00;
    packet[5] = 8'h02;
    packet[6] = 8'h55;
    packet[7] = 8'hAA;
    packet[8] = 8'hFF; // intentionally wrong CRC

    for (i = 0; i <= 8; i = i + 1)
        send_uart_byte(packet[i]);

    #20;

    if (crc_error != 1'b1) correct = 0;
    if (packet_done != 1'b0) correct = 0;

    //------------------------------------------------
    // TEST 4 : Zero-length payload
    //------------------------------------------------

    correct = 1;
    testNum = 4;

    packet[0] = 8'hAA;
    packet[1] = 8'h03;
    packet[2] = 8'h12;
    packet[3] = 8'h34;
    packet[4] = 8'h00;
    packet[5] = 8'h00;

    calc_crc(6);
    packet[6] = crc;

    for (i = 0; i <= 6; i = i + 1)
        send_uart_byte(packet[i]);

    #20;

    if (cmd != 8'h03) correct = 0;
    if (addr != 16'h1234) correct = 0;
    if (len != 16'h0000) correct = 0;
    if (packet_done != 1'b1) correct = 0;
    if (crc_error != 1'b0) correct = 0;

    //------------------------------------------------
    // TEST 5 : Wrong SOF
    //------------------------------------------------

    correct = 1;
    testNum = 5;

    send_uart_byte(8'h55); // wrong SOF
    send_uart_byte(8'h01);
    send_uart_byte(8'h02);

    #20;

    // should stay idle
    if (packet_done != 1'b0) correct = 0;

    //------------------------------------------------
    // Finish
    //------------------------------------------------

    #20;
    $finish;
    $stop;
end

endmodule