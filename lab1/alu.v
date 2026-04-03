

module ALU(
    input [15:0] A,
    input [15:0] B,
    input [3:0] ALUCtrl,
    input clk,

    output Overflow,
    output Zero,
    output [15:0] S
    );

    localparam INT_MIN = 16'b1111_1111_1111_1111;
    local overFlowCheck;

    always @(posedge clk) begin
        case(ALUCtrl)
            4'b0000 : begin
                // subtraction
                Overflow <= 0;
                S <= 0;
            end
            4'b0001 : begin
                // addition
                Overflow <= 0;
                S <= 0;
            end
            4'b0010 : begin
                // bitwise OR
                Overflow <= 0;
                S <= A | B;
            end
            4'b0011 : begin
                // bitwise AND 
                Overflow <= 0;
                S <= A & B;
            end
            4'b0100 : begin
                // decrement
                Overflow <= 0;
                S <= 0;
            end
            4'b0101 : begin
                //increment
                Overflow <= 0;
                S <= 0;
            end
            4'b0110 : begin
                // invert 
                Overflow <= 0;
                S <= 0;
            end
            4'b1100 : begin
                // arithmetic shift left
                Overflow <= 0;
                S <= 0;
            end
            4'b1110 : begin
                // arthmetic shift right 
                Overflow <= 0;
                S <= 0;
            end
            4'b1000 : begin
                // logical shift left
                Overflow <= 0;
                S <= 0;
            end
            4'b1010 : begin
                // logical shift right 
                Overflow <= 0;
                S <= 0;
            end
            4'b1001 : begin
                // set less than or equal
                Overflow <= 0;
                S <= 0;
            end
            default : begin
                // ALUCtrl not configured properly
                Overflow <= 0;
                S <= 0;
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

