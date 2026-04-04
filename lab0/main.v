`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 11:07:04 AM
// Design Name: 
// Module Name: main
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


module main(
    input wire clk,
    input wire rst,
    output wire [3:0] led
    );
    
    wire clk_1hz;
    wire [3:0] count;
    
    clock_div my_clock_div(
        .clk_in(clk),
        .clk_out(clk_1hz)
    );
    
    counter_4bit my_counter_4bit(
        .clk(clk_1hz),
        .rst(rst),
        .count(count)
    );
    
    assign led[3:0] = count[3:0];
    
endmodule
