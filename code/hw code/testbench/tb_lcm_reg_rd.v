/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-27 09:57:23
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-27 12:41:32
 * @Description: 
   1.Testbench for lcm_reg_rd
 */

`timescale 1 ns / 1 ps
module tb_lcm_reg_rd (

);

//***************define reg and wire***************
reg clk;
reg rst_n;

reg [63:0] ssm_bit;
reg [63:0] ssm_pkt_num;
reg [63:0] sent_start_time_n_reg_i;
reg [63:0] sent_rate_n_reg_i;
reg sent_finish;
reg [63:0] sent_bit_cnt;
reg [63:0] sent_pkt_n_cnt;
reg [63:0] sent_time_cnt;
reg [63:0] sent_time_reg_i;
reg [63:0] sent_num_cnt;
reg [63:0] sent_num_reg_i;
reg sent_ready;
reg [7:0] rd_reg_n;
reg out_lcm_data_ready;

wire [133:0] out_lcm_data;
wire out_lcm_data_wr;
wire out_lcm_data_valid;
wire out_lcm_data_valid_wr;

lcm_reg_rd lcm_reg_rd_tb (
    .clk(clk),
    .rst_n(rst_n),

    .ssm_bit(ssm_bit),
    .ssm_pkt_num(ssm_pkt_num),
    .sent_start_time_n_reg_i(sent_start_time_n_reg_i),
    .sent_rate_n_reg_i(sent_rate_n_reg_i),
    .sent_finish(sent_finish),
    .sent_bit_cnt(sent_bit_cnt),
    .sent_pkt_n_cnt(sent_pkt_n_cnt),
    .sent_time_cnt(sent_time_cnt),
    .sent_time_reg_i(sent_time_reg_i),
    .sent_ready(sent_ready),

    .rd_reg_n(rd_reg_n),
    .out_lcm_data_ready(out_lcm_data_ready),
    .out_lcm_data(out_lcm_data),
    .out_lcm_data_wr(out_lcm_data_wr),
    .out_lcm_data_valid(out_lcm_data_valid),
    .out_lcm_data_valid_wr(out_lcm_data_valid_wr)
);

parameter CYCLE = 10;

always begin
    # (CYCLE / 2)
    clk = ~clk;
end

initial begin
    clk = 0;
    rst_n = 1;
    # (CYCLE / 2)
    rst_n = 0;
    # (CYCLE / 2)
    rst_n = 1;
end

initial begin
    # CYCLE
    ssm_bit = 64'd1;
    ssm_pkt_num = 64'd2;
    sent_start_time_n_reg_i = 64'd3;
    sent_rate_n_reg_i = 64'd4;
    sent_finish = 1'b0;
    sent_bit_cnt = 64'd5;
    sent_pkt_n_cnt = 64'd6;
    sent_time_cnt = 64'd7;
    sent_time_reg_i = 64'd8;
    sent_num_cnt = 64'd9;
    sent_num_reg_i = 64'd10;
    sent_ready = 1'b1;

    # CYCLE
    rd_reg_n = 8'd1;
    /*
    # (8 * CYCLE)
    rd_reg_n = 8'd2;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd3;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd4;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd5;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd6;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd7;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd8;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd9;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd10;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd11;
    
    # (8 * CYCLE)
    rd_reg_n = 8'd12;
    */
end

endmodule