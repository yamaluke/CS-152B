`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2026 01:30:52 PM
// Design Name: 
// Module Name: Full_Adder
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


module FA_1b(
    input wire A,
    input wire B,
    input wire Cin,
    output wire Sum,
    output wire Cout
    );
    
    wire a_xor_b, cin_and_axb, a_and_b;
    
    xor(a_xor_b, A, B);
    xor(Sum, Cin, a_xor_b);
    
    and(cin_and_axb, Cin, a_xor_b);
    and(a_and_b, A, B);
    or(Cout, cin_and_axb, a_and_b);
endmodule
