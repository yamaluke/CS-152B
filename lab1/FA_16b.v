`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2026 10:31:20 AM
// Design Name: 
// Module Name: FA_16b
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


module FA_16b(
    input [15:0]A,
    input [15:0]B,
    input wire Cin,
    output [15:0]Sum,
    output Cout
    );
    
wire [15:1] c;

FA_1b fa0 (A[0], B[0], Cin, Sum[0], c[1]);
FA_1b fa1 (A[1], B[1], c[1], Sum[1], c[2]);
FA_1b fa2 (A[2], B[2], c[2], Sum[2], c[3]);
FA_1b fa3 (A[3], B[3], c[3], Sum[3], c[4]);
FA_1b fa4 (A[4], B[4], c[4], Sum[4], c[5]);
FA_1b fa5 (A[5], B[5], c[5], Sum[5], c[6]);
FA_1b fa6 (A[6], B[6], c[6], Sum[6], c[7]);
FA_1b fa7 (A[7], B[7], c[7], Sum[7], c[8]);
FA_1b fa8 (A[8], B[8], c[8], Sum[8], c[9]);
FA_1b fa9 (A[9], B[9], c[9], Sum[9], c[10]);
FA_1b fa10 (A[10], B[10], c[10], Sum[10], c[11]);
FA_1b fa11 (A[11], B[11], c[11], Sum[11], c[12]);
FA_1b fa12 (A[12], B[12], c[12], Sum[12], c[13]);
FA_1b fa13 (A[13], B[13], c[13], Sum[13], c[14]);
FA_1b fa14 (A[14], B[14], c[14], Sum[14], c[15]);
FA_1b fa15 (A[15], B[15], c[15], Sum[15], Cout);

endmodule
