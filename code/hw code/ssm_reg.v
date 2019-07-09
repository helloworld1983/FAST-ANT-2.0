/*
 * @Author: Wu Shangming
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-28 23:03:42
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:31:20
 * @Description: 
   1.The code of ssm_reg.
   2.Statistic related data and information.
   3.More information in Doc.
 */

`timescale 1 ns / 1 ps
module ssm_reg #(
    parameter PLATFORM = "Xilinx-OpenBox-S4"
)(
    input clk,
    input rst_n,
    //reset signal from sw
    input reset_reg,
    //receive data
    input [133:0] in_ssm_reg_data,
    input in_ssm_reg_data_wr,
    input in_ssm_reg_valid,
    input in_ssm_reg_valid_wr,
    //statistic
    output reg [63:0] ssm_bit_reg2lcm,
    output reg [63:0] ssm_pkt_num2lcm
);

reg [1:0] ssm_reg_state;
reg [11:0] bit_cnt;

localparam IDLE_S = 2'd0,
           STAT_S = 2'd1,
           CLEAR_S = 2'd2;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ssm_bit_reg2lcm <= 64'b0;
        ssm_pkt_num2lcm <= 64'b0;

        ssm_reg_state <= IDLE_S;
    end
    else begin
        case (ssm_reg_state)
            IDLE_S: begin
                if (in_ssm_reg_data[133:132] == 2'b01 && in_ssm_reg_data_wr == 1'b1 && reset_reg == 1'b0) begin
                    ssm_bit_reg2lcm <= ssm_bit_reg2lcm + (in_ssm_reg_data[107:96] - 12'd32) * 12'd8;
                    bit_cnt <= in_ssm_reg_data[107:96];
                    ssm_reg_state <= STAT_S;
                end
                else if (reset_reg == 1'b1) begin
                    ssm_reg_state <= CLEAR_S;
                end
                else begin
                   // ssm_bit_reg2lcm <= 64'b0;
                   // ssm_pkt_num2lcm <= 64'b0;
                    ssm_reg_state <= IDLE_S;
                end
            end

            STAT_S: begin
                if (in_ssm_reg_data[133:132] == 2'b11 && in_ssm_reg_data_wr == 1'b1) begin
                    ssm_reg_state <= STAT_S;
                end
                else if (in_ssm_reg_data[133:132] == 2'b10 && in_ssm_reg_data_wr == 1'b1) begin                 
                    ssm_pkt_num2lcm <= ssm_pkt_num2lcm + 64'b1;
                    ssm_reg_state <= IDLE_S;
                end
                else begin     //  error packet
                    ssm_bit_reg2lcm <= ssm_bit_reg2lcm - (bit_cnt - 12'd32) * 12'd8;
                    ssm_reg_state <= IDLE_S;
                end
            end

            CLEAR_S: begin
                if (reset_reg == 1'b1) begin
                    ssm_bit_reg2lcm <= 64'b0;
                    ssm_pkt_num2lcm <= 64'b0;
                    ssm_reg_state <= CLEAR_S;
                end
                else if (reset_reg == 1'b0) begin
                    ssm_reg_state <= IDLE_S;
                end
            end
        endcase
    end
end

endmodule