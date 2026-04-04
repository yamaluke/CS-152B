`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:39:42 AM
// Design Name: 
// Module Name: counter_4bit
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


module counter_4bit(
    input wire clk,
    input wire rst,
    output wire [3:0] count
);

    reg [3:0] count_int = 0;


    always @(posedge clk or posedge rst) begin
        if (count_int >= 15 || rst) begin
            count_int = 0;
        end else begin
            count_int <= count_int + 1;
        end 
    end
    
    assign count = count_int;
endmodule
