`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 11:40:50 AM
// Design Name: 
// Module Name: ALU_tb
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

module ALU_tb(
);
reg [3:0] ALUCtrl;
reg [15:0]A;
reg [15:0]B;
wire [15:0]S;
wire Overflow;
wire Zero;
reg [5:0] TestNum;

ALU my_alu(
    .A(A),
    .B(B),
    .ALUCtrl(ALUCtrl),
    .S(S),
    .Zero(Zero),
    .Overflow(Overflow)
);

initial begin
A = 0;
B = 0;

// Subtraction Cases
ALUCtrl=4'b0000;

// POS - POS no overflow
A = 16'h0028;
B = 16'h0020;
TestNum = 0;
// POS - INT_MIN overflow
#0.01;
A = 16'h0000;
B = 16'h8000;
TestNum = 1;
// NEG - NEG zero
#0.01;
A = 16'hFFFF;
B = 16'hFFFF;
TestNum = 2;
#0.01;
// Addition Cases
ALUCtrl=4'b0001;
// POS + POS no overflow
A = 16'h0028;
B = 16'h0020;
TestNum = 3;
// POS + POS Overflow
#0.01;
A = 16'h7FFF;
B = 16'h0001;
TestNum = 4;
// POS + NEG Zero
#0.01;
A = 16'h0001;
B = 16'hFFFF;
TestNum = 5;
#0.01;
// OR Cases
ALUCtrl=4'b0010;
A = 16'b1010101010101010;
B = 16'b0101010101010101;
TestNum = 6;
#0.01;
// AND Cases
ALUCtrl=4'b0011;
A = 16'hFFFF;
B = 16'h00FF;
TestNum = 7;
#0.01;
// Decrement Cases
ALUCtrl=4'b0100;
// POS Decrement No Overflow Zero
A = 16'd1;
B = 16'd0;
TestNum = 8;
// NEG Decrement No Overflow
#0.01;
A = 16'hFFFF;
B = 16'd0;
TestNum = 9;
// NEG Decrement Overflow
#0.01;
A = 16'h8000;
B = 16'd0;
TestNum = 10;
#0.01;
// Increment Cases
ALUCtrl=4'b0101;
// NEG Increment No Overflow Zero
A = 16'hFFFF;
B = 16'd0;
TestNum = 11;
// POS Increment No Overflow
#0.01;
A = 16'h0001;
B = 16'd0;
TestNum = 12;
// POS Increment Overflow
#0.01;
A = 16'h7FFF;
B = 16'd0;
TestNum = 13;
#0.01;
// Invert Cases
ALUCtrl=4'b0110;
// Invert No Overflow
A = 16'h0008;
B = 16'h0000;
TestNum = 14;
// Invert Overflow
#0.01;
A = 16'h8000;
B = 16'h0000;
TestNum = 15;
#0.01;
// ASL Cases
// POS Shifted No Overflow
ALUCtrl=4'b1100;
A = 16'h0008;
B = 16'h0003;
TestNum = 16;
// NEG Shifted Overflow Zero
#0.01;
A = 16'h8000;
B = 16'h0010;
TestNum = 17;
#0.01;
 // ASR Cases
 ALUCtrl=4'b1110;
//Neg ASR Sign Preserved
A = 16'h8000;
B = 16'h0002;
TestNum = 18;
// POS ASR Zero Sign Preserved
#0.01;
A = 16'h0002;
B = 16'h0002;
TestNum = 19;
#0.01;
 // LSL Cases
ALUCtrl=4'b1000;
A = 16'h0001;
B = 16'h0008;
TestNum = 20;
#0.01; 
//LSR Cases
// Neg to Pos
ALUCtrl=4'b1010;
A = 16'h8000;
B = 16'h0006;
TestNum = 21; 
#0.01;
//LE Cases
// NEG A > NEG B
ALUCtrl=4'b1001;
A = 16'h9000;
B = 16'h8000;
TestNum = 22;
#0.01;

// NEG A < POS B
A = 16'h8000; 
B = 16'h0020;
TestNum = 23;
#0.01;

// Pos A < POS B
A = 16'h000F; 
B = 16'h0020;
TestNum = 24;
#0.01;

// A == B
A = 16'h0FB2;
B = 16'h0FB2;
TestNum = 25;


end
endmodule
