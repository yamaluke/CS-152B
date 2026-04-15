`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2026 12:42:59 PM
// Design Name: 
// Module Name: ALU
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

module ALU(
    input signed [15:0] A,
    input [15:0] B,
    input [3:0] ALUCtrl,

    output reg Overflow,
    output reg Zero,
    output reg [15:0] S
    );
    
    reg [15:0] adderInputA;
    reg [15:0] adderInputB;
    reg adderCin;
    wire [15:0] adderOutput;
    wire adderCarry;
    
    localparam INT_MIN = 16'b1000_0000_0000_0000;
    
    FA_16b my_adder(
        .A(adderInputA),
        .B(adderInputB),
        .Cin(adderCin),
        .Sum(adderOutput),
        .Cout(adderCarry)
    );
    
    

    always @(*) begin
        case(ALUCtrl)
            4'b0000 : begin
                // subtraction
                adderInputA = A;
                adderInputB = ~B;
                adderCin = 1;
                S = adderOutput;
                Overflow = (A[15:15] != B[15:15]) & (A[15:15] != S[15:15]);
            end
            4'b0001 : begin
                // addition
                adderInputA = A;
                adderInputB = B;
                adderCin = 0;
                S = adderOutput;
                Overflow = (A[15:15] == B[15:15]) & (A[15:15] != S[15:15]);
            end
            4'b0010 : begin
                // bitwise OR
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                Overflow = 0;
                adderCin = 0;
                
                S = A | B;
            end
            4'b0011 : begin
                // bitwise AND 
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                Overflow = 0;
                adderCin = 0;
                
                S = A & B;
            end
            4'b0100 : begin
                // decrement
                adderInputA = A;
                adderInputB = 16'b1111_1111_1111_1111;
                adderCin = 0;
                S = adderOutput;
                Overflow = (A[15:15] != B[15:15]) & (A[15:15] != S[15:15]);
            end
            4'b0101 : begin
                //increment
                adderInputA = A;
                adderInputB = 16'b0000_0000_0000_0001;
                adderCin = 0;
                S = adderOutput;
                Overflow = (A[15:15] == B[15:15]) & (A[15:15] != S[15:15]);
            end
            4'b0110 : begin
                // invert 
                adderInputA = ~A;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 1;
                
                Overflow = (A == INT_MIN);
                S = adderOutput;
            end
            4'b1100 : begin
                // arithmetic shift left
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 0;
                S = A <<< B;
                case(B)
                    0: Overflow = 0;
                    1: Overflow = A[15] != A[14];
                    2: Overflow = A[15] != A[13];
                    3: Overflow = A[15] != A[12];
                    4: Overflow = A[15] != A[11];
                    5: Overflow = A[15] != A[10];
                    6: Overflow = A[15] != A[9];
                    7: Overflow = A[15] != A[8];
                    8: Overflow = A[15] != A[7];
                    9: Overflow = A[15] != A[6];
                    10: Overflow = A[15] != A[5];
                    11: Overflow = A[15] != A[4];
                    12: Overflow = A[15] != A[3];
                    13: Overflow = A[15] != A[2];
                    14: Overflow = A[15] != A[1];
                    15: Overflow = A[15] != A[0];
                    default: Overflow = 1;
                 endcase
                
//                S = {A[14:0], 1'b0}; 
            end
            4'b1110 : begin
                // arthmetic shift right 
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 0;
                
                S = A >>> B;
                Overflow = 0;
//                S = {A[15:15], A[15:1]};
            end
            4'b1000 : begin
                // logical shift left
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 0;
                
                Overflow = 0;
//                S = {A[14:0], 1'b0};
                S = A << B;
            end
            4'b1010 : begin
                // logical shift right
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 0;
                
                Overflow = 0;
//                S = {1'b0, A[15:1]};
                S = A >> B;
            end
            4'b1001 : begin
                // set less than or equal

                adderInputA = A;
                adderInputB = ~B;
                adderCin = 1;
                Overflow = (A[15:15] != B[15:15]) & (A[15:15] != adderOutput[15:15]);
                S = {15'd0, (adderOutput[15] ^ Overflow || A == B)};
            end
            default : begin
                // ALUCtrl not configured properly
                adderInputA = 16'b0000_0000_0000_0000;
                adderInputB = 16'b0000_0000_0000_0000;
                adderCin = 0;
                
                Overflow = 0;
                S = 0;
            end
        endcase
    end
    
    always @(*)begin
        if(S == 0)begin
            Zero = 1;
        end else begin
            Zero = 0;
        end
    end

endmodule
