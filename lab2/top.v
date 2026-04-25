`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 12:46:46 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] sw,
//    input wire [1:0] JA, // 0=rx, 1=tx
    input wire rx_line,
    output wire tx_line,
    // next time: check to see if JA[1] needs to be output 
    
    output wire [7:0] led
    
    );
    
    tx my_tx(
        .clk_100mhz(clk),
        .rst(rst),
        .start(start),
        .data(sw),
//        .tx_line(JA[1])
        .tx_line(tx_line)
    );
    
    rx my_rx(
        .clk_100mhz(clk),
        .rst(rst),
//        .rx_line(JA[0]),
        .rx_line(rx_line),
        .data(led[7:0])
    );
    
//    assign led[14:8] = sw[7:0]; // for debugging 
endmodule
