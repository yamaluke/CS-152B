`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2026 11:38:52 AM
// Design Name: 
// Module Name: clock_div
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


module clock_div(
    input wire clk_in,
    output wire clk_out
    );
    reg clk_out_reg = 0;
    reg [25:0] counter = 0;
    localparam DIV = 50000000;
    
    always @(posedge clk_in) begin
        if (counter > DIV) begin
            clk_out_reg <= ~clk_out_reg;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
    
    assign clk_out = clk_out_reg;
endmodule
