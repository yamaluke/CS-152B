module tx(
    input wire clk_100mhz,
    input wire rst,
    input wire start,
    input wire [7:0] data,

    output reg tx_line
    );

    localparam  countMax = 100000000/9600; // 100MHz / 9600 baudrate
    // localparam countMax = 2; // for testing 
    reg [25:0] count = 0;
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9;
    reg [3:0] currentState;
    reg [3:0] nextState;
    reg[7:0] data_reg;
    reg start_reg;

    //= state transistion =//
    always @(*)begin
        case(currentState)
            S0: begin
                if(start_reg)
                    nextState = S1;
                else
                    nextState = S0;
            end
            S1: begin
                nextState = S2;
            end
            S2: begin
                nextState = S3;
            end
            S3: begin
                nextState = S4;
            end
            S4: begin
                nextState = S5;
            end
            S5: begin
                nextState = S6;
            end
            S6: begin
                nextState = S7;
            end
            S7: begin             
                nextState = S8;
            end
            S8: begin
                nextState = S9;
            end
            S9: begin
                nextState = S0;
            end
            default: nextState = S0;
        endcase
    end

    //= output update =//
    always @(posedge clk_100mhz or posedge rst)begin
        if(rst) begin
            currentState <= S0;
            tx_line <= 1'b1;
            count <= 0;
            start_reg <= 1'b0;
        end else if (count < countMax) begin
            count <= count + 1;

            if(start && currentState == S0 && !start_reg)
                start_reg <= 1'b1;
        end
        else begin
            count <= 0;
            currentState <= nextState;
            case(currentState)
                S0: begin
                    tx_line <= 1'b1;
                    start_reg <= 1'b0;
                end
                S1: begin
                    tx_line <= 1'b0;
                    data_reg <= data;
                end
                S2: tx_line <= data_reg[0];
                S3: tx_line <= data_reg[1];
                S4: tx_line <= data_reg[2];
                S5: tx_line <= data_reg[3];
                S6: tx_line <= data_reg[4];
                S7: tx_line <= data_reg[5];
                S8: tx_line <= data_reg[6];
                S9: tx_line <= data_reg[7];
                default: tx_line <= 1'b1;
            endcase
        end
    end
endmodule
