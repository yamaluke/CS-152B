module uart_rx(
    input wire clk_100mhz,
    input wire rst,
    input wire rx_line,

    output reg [7:0] data,
    output reg data_valid
    );

    localparam baudRate = 115200; // 115200 baudrate
    localparam  countMax = 100000000/baudRate; // 100MHz / baudrate
    // localparam countMax = 2; // for testing 

    reg [25:0] count = 0;
    parameter S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9, S10 = 4'd10;
    reg [3:0] currentState;
    reg [3:0] nextState;
    reg sync1, sync2;
    reg [7:0] data_reg;

    //= state transistion =//
    always @(*)begin
        case(currentState)
            S0: begin
                if(sync2)
                    nextState = S1;
                else
                    nextState = S0;
            end
            S1: begin
                if(sync2)
                    nextState = S1;
                else
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
                nextState = S10;
            end
            S10: begin
                if(sync2)
                    nextState = S1;
                else
                    nextState = S0;
            end
            default: nextState = S0;
        endcase
    end

    //= output update =//
    always @(posedge clk_100mhz or posedge rst)begin
        sync1 <= rx_line;
        sync2 <= sync1;
        if(rst) begin
            currentState <= S0;
            data <= 8'b0000_0000;
        end else if (count < countMax) begin
            // if(currentState == S1 && count == countMax/2) begin
            //     count <= 0;
            //     currentState <= nextState;
            // end else
                count <= count + 1;
        end else begin
            count <= 0;
            currentState <= nextState;
            case(currentState)
                S0: data_reg <= 8'b0000_0000;
                S1: data_reg <= 8'b0000_0000;
                S2: begin
                    data_reg[0] <= sync2;
                    data_valid <= 1'b0;
                end
                S3: data_reg[1] <= sync2;
                S4: data_reg[2] <= sync2;
                S5: data_reg[3] <= sync2;
                S6: data_reg[4] <= sync2;
                S7: data_reg[5] <= sync2;
                S8: data_reg[6] <= sync2;
                S9: data_reg[7] <= sync2;
                S10: begin
                    if(nextState == S1) // if next state is S1, it means stop bit is correct, we can update data
                        data <= {sync2,data_reg};
                        data_valid <= 1'b1; // set data_valid to 1 when data is valid
                    else
                        data <= 8'b0000_0000; // if stop bit is wrong, reset data to 0
                        data_valid <= 1'b0; // set data_valid to 0 when data is invalid
                end
                default: data_reg <= 8'b0000_0000;
            endcase
        end
    end

endmodule
