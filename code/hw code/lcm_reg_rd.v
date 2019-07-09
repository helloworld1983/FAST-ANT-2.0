/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-19 15:07:38
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-07-06 21:46:57
 * @Description:
   1. The code of Reg_RD.
   2. Read data for sw from intended registers.
   3. More information in Doc. 
 */

`timescale 1 ns / 1 ps
module lcm_reg_rd #(
    parameter PLATFORM = "Xilinx-OpenBox-S4",
              LMID = 8'd32
)(
    input clk,
    input rst_n,

    input [63:0] ssm_bit,
    input [63:0] ssm_pkt_num,
    input [63:0] sent_start_time_n_reg_i,
    input [63:0] sent_rate_n_reg_i,
    input sent_finish,
    input [63:0] sent_bit_cnt,
    input [63:0] sent_pkt_0_cnt,
    input [63:0] sent_pkt_1_cnt,
    input [63:0] sent_pkt_2_cnt,
    input [63:0] sent_pkt_3_cnt,
    input [63:0] sent_time_cnt,
    input [63:0] sent_time_reg_i,
    input [63:0] sent_num_cnt,
    input [63:0] sent_num_reg_i,
    input sent_ready,

    input [7:0] rd_reg_n,
    input out_lcm_data_ready,
    output reg [133:0] out_lcm_data,
    output reg out_lcm_data_wr,
    output reg out_lcm_data_valid,
    output reg out_lcm_data_valid_wr
);

reg [1:0] reg_rd_state;
reg [63:0] reg_rd_data_tmp;
reg [2:0] upload_pkt_cnt;

localparam IDLE_S = 2'd0,
           SEND_S = 2'd1;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_lcm_data <= 134'b0;
        out_lcm_data_wr <= 1'b0;
        out_lcm_data_valid <= 1'b0;
        out_lcm_data_valid_wr <= 1'b0;
        reg_rd_data_tmp <= 64'b0;
        upload_pkt_cnt <= 3'b0;
        
        reg_rd_state <= IDLE_S;
    end
    else begin
        case (reg_rd_state)
            IDLE_S: begin
                out_lcm_data <= 134'b0;          
                out_lcm_data_wr <= 1'b0;         
                out_lcm_data_valid <= 1'b0;      
                out_lcm_data_valid_wr <= 1'b0;   
                case (rd_reg_n)
                    8'd1: begin
                        reg_rd_data_tmp <= ssm_bit;
                        reg_rd_state <= SEND_S;  
                    end

                    8'd2: begin
                        reg_rd_data_tmp <= ssm_pkt_num;
                        reg_rd_state <= SEND_S;
                    end

                    8'd3: begin
                        reg_rd_data_tmp <= sent_start_time_n_reg_i;
                        reg_rd_state <= SEND_S;
                    end

                    8'd4: begin
                        reg_rd_data_tmp <= sent_rate_n_reg_i;
                        reg_rd_state <= SEND_S;
                    end

                    8'd5: begin
                        reg_rd_data_tmp <= {63'b0, sent_finish};
                        reg_rd_state <= SEND_S;
                    end

                    8'd6: begin
                        reg_rd_data_tmp <= sent_bit_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd7: begin
                        reg_rd_data_tmp <= sent_pkt_0_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd8: begin
                        reg_rd_data_tmp <= sent_pkt_1_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd9: begin
                        reg_rd_data_tmp <= sent_pkt_2_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd10: begin
                        reg_rd_data_tmp <= sent_pkt_3_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd11: begin
                        reg_rd_data_tmp <= sent_time_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd12: begin
                        reg_rd_data_tmp <= sent_time_reg_i;
                        reg_rd_state <= SEND_S;
                    end

                    8'd13: begin
                        reg_rd_data_tmp <= sent_num_cnt;
                        reg_rd_state <= SEND_S;
                    end

                    8'd14: begin
                        reg_rd_data_tmp <= sent_num_reg_i;
                        reg_rd_state <= SEND_S;
                    end

                    8'd15: begin
                        reg_rd_data_tmp <= {63'b0, sent_ready};
                        reg_rd_state <= SEND_S;
                    end

                    default: begin
                        reg_rd_data_tmp <= 64'b0;
                        reg_rd_state <= IDLE_S;
                    end
            
                endcase    
            end

            SEND_S: begin
                if (upload_pkt_cnt == 3'd0) begin
                    //MD 0
                    out_lcm_data <= {6'b010000, 1'b1, 1'b1, 6'b0, 2'b0, 6'b0, 3'b0, 1'b0, 12'd96, 8'd3, 8'd129, 8'b00000100, 72'b0};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;

                    upload_pkt_cnt <= upload_pkt_cnt + 3'd1;
                    reg_rd_state <= SEND_S;
                end
                else if (upload_pkt_cnt == 3'd1) begin
                    //MD 1
                    out_lcm_data <= {6'b110000, 128'b0};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;

                    upload_pkt_cnt <= upload_pkt_cnt + 3'd1;
                    reg_rd_state <= SEND_S;
                end
                else if (upload_pkt_cnt == 3'd2) begin
                    //PKT
                    out_lcm_data <= {6'b110000, 128'h0023cd76631a002185c52b8f08004500};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;

                    upload_pkt_cnt <= upload_pkt_cnt + 3'd1;
                    reg_rd_state <= SEND_S;
                end
                else if (upload_pkt_cnt == 3'd3) begin
                    out_lcm_data <= {6'b110000, 128'h00327919000040d57d28c0a80164c0a8};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;

                    upload_pkt_cnt <= upload_pkt_cnt + 3'd1;
                    reg_rd_state <= SEND_S;
                end
                else if (upload_pkt_cnt == 3'd4) begin
                    out_lcm_data <= {6'b110000, 128'h0101ffffffffffffffffffffffffffff};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;

                    upload_pkt_cnt <= upload_pkt_cnt + 3'd1;
                    reg_rd_state <= SEND_S;
                end
                else if (upload_pkt_cnt == 3'd5) begin
                    out_lcm_data <= {6'b100000, rd_reg_n, reg_rd_data_tmp, 56'b0};
                    out_lcm_data_wr <= 1'b1;
                    out_lcm_data_valid <= 1'b1;
                    out_lcm_data_valid_wr <= 1'b1;
                    upload_pkt_cnt <= 3'b0;

                    reg_rd_state <= IDLE_S;
                end
                else begin
                    out_lcm_data <= 134'b0;
                    out_lcm_data_wr <= 1'b0;
                    out_lcm_data_valid <= 1'b0;
                    out_lcm_data_valid_wr <= 1'b0;
                    upload_pkt_cnt <= 3'b0;

                    reg_rd_state <= IDLE_S;
                end
            end
        endcase
    end
end

endmodule