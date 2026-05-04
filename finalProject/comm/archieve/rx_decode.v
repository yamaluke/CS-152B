

module rx_decode(
    input wire clk,
    input wire rst,
    input wire rx_line,

    output reg [7:0] cmd,
    output reg [15:0] addr,
    output reg [15:0] len,
    output reg [7:0] payload,
    // output wire [7:0] payload [0:255],
    output reg payload_valid,
    output reg packet_done,
    output reg crc_error
);

    parameter WAIT_SOF = 3'd0, GET_CMD = 3'd1, GET_ADDR_HI = 3'd2, GET_ADDR_LO = 3'd3, GET_LEN_HI = 3'd4, GET_LEN_LO = 3'd5, GET_PAYLOAD = 3'd6, GET_CRC = 3'd7;
    parameter MAX_PAYLOAD_SIZE = 256;

    reg [2:0] state; 

    reg [15:0] payload_count;
    // reg [7:0] payload_mem [0:MAX_PAYLOAD_SIZE-1];
    reg [7:0] crc_calc;
    // reg [7:0] crc_recv;

    wire [7:0] rx_data;
    wire rx_valid;

    rx uart_rx (
        .clk_100mhz(clk),
        .rst(rst),
        .rx_line(rx_line),

        .data(rx_data),
        .data_valid(rx_valid)
    );

    // assign payload = payload_mem;

    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            state <= WAIT_SOF;
            payload_count <= 0;
            crc_calc <= 0;
            packet_done <= 0;
            crc_error <= 0;
            payload_valid <= 0;
            cmd <= 0;
            addr <= 0;
            len <= 0;
            payload <= 0;
        end
        else begin
            packet_done <= 0;
            payload_valid <= 0;

            if (rx_valid) begin
                case(state)

                    WAIT_SOF:
                        if (rx_data == 8'hAA) begin
                            state <= GET_CMD;
                            crc_calc <= 0;
                        end

                    GET_CMD:
                        begin
                            cmd <= rx_data;
                            crc_calc <= rx_data;
                            state <= GET_ADDR_HI;
                        end

                    GET_ADDR_HI:
                        begin
                            addr[15:8] <= rx_data;
                            crc_calc <= crc_calc ^ rx_data;
                            state <= GET_ADDR_LO;
                        end

                    GET_ADDR_LO:
                        begin
                            addr[7:0] <= rx_data;
                            crc_calc <= crc_calc ^ rx_data;
                            state <= GET_LEN_HI;
                        end

                    GET_LEN_HI:
                        begin
                            len[15:8] <= rx_data;
                            crc_calc <= crc_calc ^ rx_data;
                            state <= GET_LEN_LO;
                        end

                    GET_LEN_LO:
                        begin
                            len[7:0] <= rx_data;
                            crc_calc <= crc_calc ^ rx_data;
                            payload_count <= 0;
                            if({len[15:8], rx_data} == 0) // if length is zero, skip to CRC check
                                state <= GET_CRC;
                            else
                                state <= GET_PAYLOAD;
                        end

                    GET_PAYLOAD:
                        begin
                            payload <= rx_data;
                            payload_valid <= 1;
                            crc_calc <= crc_calc ^ rx_data;
                            payload_count <= payload_count + 1;

                            if (payload_count + 1 >= len)
                                state <= GET_CRC;
                        end

                    GET_CRC:
                        begin
                            if (crc_calc == rx_data) begin
                                packet_done <= 1;
                                crc_error <= 0;
                            end
                            else begin
                                crc_error <= 1;
                            end

                            state <= WAIT_SOF;
                        end
                    default:
                        state <= WAIT_SOF;
                endcase
            end
        end
    end

endmodule