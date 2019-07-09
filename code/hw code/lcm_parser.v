/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-19 09:13:29
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:07:26
 * @Description: 
   1. The code of Parser.
   2. Parse packets to decide the operation of reading or writing.
   3. More information in Doc.
 */

`timescale 1 ns / 1 ps
module lcm_parser #(
    parameter PLATFORM = "Xilinx-OpenBox-S4",
              LMID = 8'd3
)(
    input clk,
    input rst_n,

    //Pkt Input
    input [133:0] in_lcm_data,
    input in_lcm_data_wr,
    input in_lcm_data_valid,
    input in_lcm_data_valid_wr,
    output in_lcm_data_ready,

    //Signal Output
    output reg [7:0] wr_reg_n,
    output reg [63:0] wr_reg_n_value,
    output reg [7:0] rd_reg_n
);

localparam IDLE_S = 2'd0,
           RD_S = 2'd1,
           WR_S = 2'd2;

reg [1:0] lcm_parser_state;
//reg [6:0] in_lcm_pkt_cnt;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wr_reg_n <= 8'b0;
        wr_reg_n_value <= 64'b0;
        rd_reg_n <= 8'b0;
        //in_lcm_pkt_cnt <= 7'b0;

        lcm_parser_state <= IDLE_S;
    end
    else begin
        case (lcm_parser_state)
            IDLE_S: begin
                if (in_lcm_data[133:132] == 2'b01 && in_lcm_data[48] == 1'b1) begin
                    //read registers
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;
                    //in_lcm_pkt_cnt <= in_lcm_pkt_cnt + 7'b1;

                    lcm_parser_state <= RD_S;
                end
                else if (in_lcm_data[133:132] == 2'b01 && in_lcm_data[48] == 1'b0) begin
                    //write registers
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;
                    //in_lcm_pkt_cnt <= in_lcm_pkt_cnt + 7'b1;

                    lcm_parser_state <= WR_S;
                end
                else begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;
                    //in_lcm_pkt_cnt <= 7'b0;

                    lcm_parser_state <= IDLE_S;
                end
            end

            RD_S: begin
                if (in_lcm_data[133:132] == 2'b11) begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;
                    //in_lcm_pkt_cnt <= in_lcm_pkt_cnt + 7'b1;

                    lcm_parser_state <= RD_S;
                end
                else if (in_lcm_data[133:132] == 2'b10) begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= in_lcm_data[127:120];

                    lcm_parser_state <= IDLE_S;
                end
                else begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;

                    lcm_parser_state <= IDLE_S;
                end
            end

            WR_S: begin
                if (in_lcm_data[133:132] == 2'b11) begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;
                    //in_lcm_pkt_cnt <= in_lcm_pkt_cnt + 7'b1;

                    lcm_parser_state <= WR_S;
                end
                else if (in_lcm_data[133:132] == 2'b10) begin
                    wr_reg_n <= in_lcm_data[127:120];
                    wr_reg_n_value <= in_lcm_data[119:56];
                    rd_reg_n <= 8'b0;

                    lcm_parser_state <= IDLE_S;                    
                end
                else begin
                    wr_reg_n <= 8'b0;
                    wr_reg_n_value <= 64'b0;
                    rd_reg_n <= 8'b0;

                    lcm_parser_state <= IDLE_S;
                end
            end
            
        endcase
    end
end

endmodule