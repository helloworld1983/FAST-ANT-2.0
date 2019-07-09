/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-18 17:08:04
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:07:50
 * @Description:
   1. The code of LCM.
   2. Local Control Model is able to read or write registers in hw. 
   3. More information in Doc.
 */

`timescale 1 ns / 1 ps
module lcm #(
    parameter PLATFORM = "Xilinx-OpenBox-S4",
              LMID = 8'd3
)(
    input clk,
    input rst_n,

    //Pkt from DMUX
    input [133:0] in_lcm_data,
    input in_lcm_data_wr,
    input in_lcm_data_valid,
    input in_lcm_data_valid_wr,
    output in_lcm_data_ready,

    //Pkt to MUX
    output [133:0] out_lcm_data,
    output out_lcm_data_wr,
    output out_lcm_data_valid,
    output out_lcm_data_valid_wr,
    input out_lcm_data_ready,

    //Config Information
    //SSM
    output lcm2ssm_reset,
    output lcm2ssm_rd,
    output [10:0] lcm2ssm_addr,
    output [7:0] protocol_type,
    input [63:0]ssm_bit,
    input [63:0]ssm_pkt_num,

    //PGM
    output pgm_config_reset,
    output [63:0] sent_start_time_n_reg_out,
    input [63:0] sent_start_time_n_reg_in,
    output [63:0] sent_rate_n_reg_out,
    input [63:0] sent_rate_n_reg_in,
    output table_entry_wr,
    output sent_start,
    input sent_finish,
    output sent_model,
    input [63:0] sent_bit_cnt,
    input [63:0] sent_pkt_0_cnt,
    input [63:0] sent_pkt_1_cnt,
    input [63:0] sent_pkt_2_cnt,
    input [63:0] sent_pkt_3_cnt,
    input [63:0] sent_time_cnt,
    input [63:0] sent_time_reg_in,
    output [63:0] sent_time_reg_out,
    input [63:0] sent_num_cnt,
    input [63:0] sent_num_reg_in,
    output [63:0] sent_num_reg_out,
    input sent_ready,
    
    //MUX
    output mux2port_0_rd,

    //Timer
    output reg [63:0] lcm_timestamp
);

//timer
always @ (posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    lcm_timestamp <= 64'b0;
  end
  else begin
    lcm_timestamp <= lcm_timestamp + 64'b1;
  end
end

//*********************module instance*********************
//parser to reg_wr and reg_rd
wire [7:0] wr_reg_n;
wire [63:0] wr_reg_n_value;
wire [7:0] rd_reg_n;

lcm_parser #(
    ) lcm_parser (
      .clk(clk),
      .rst_n(rst_n),
      //PKT Input
      .in_lcm_data(in_lcm_data),
      .in_lcm_data_wr(in_lcm_data_wr),
      .in_lcm_data_valid(in_lcm_data_valid),
      .in_lcm_data_valid_wr(in_lcm_data_valid_wr),

      .wr_reg_n(wr_reg_n),
      .wr_reg_n_value(wr_reg_n_value),
      .rd_reg_n(rd_reg_n)
);

lcm_reg_wr #(
    ) lcm_reg_wr (
      .clk(clk),
      .rst_n(rst_n),

      .wr_reg_n(wr_reg_n),
      .wr_reg_n_value(wr_reg_n_value),

      .lcm2ssm_reset(lcm2ssm_reset),
      .lcm2ssm_rd(lcm2ssm_rd),
      .lcm2ssm_addr(lcm2ssm_addr),
      .protocol_type(protocol_type),
      .pgm_config_reset(pgm_config_reset),
      .sent_start_time_n_reg_o(sent_start_time_n_reg_out),
      .sent_rate_n_reg_o(sent_rate_n_reg_out),
      .table_entry_wr(table_entry_wr),
      .sent_start(sent_start),
      .sent_model(sent_model),
      .sent_time_reg_o(sent_time_reg_out),
      .sent_num_reg_o(sent_num_reg_out),
      .mux2port_0_rd(mux2port_0_rd)
);

lcm_reg_rd #(
    ) lcm_reg_rd (
      .clk(clk),
      .rst_n(rst_n),
      
      .ssm_bit(ssm_bit),
      .ssm_pkt_num(ssm_pkt_num),
      .sent_start_time_n_reg_i(sent_start_time_n_reg_in),
      .sent_rate_n_reg_i(sent_rate_n_reg_in),
      .sent_finish(sent_finish),
      .sent_bit_cnt(sent_bit_cnt),
      .sent_pkt_0_cnt(sent_pkt_0_cnt),
      .sent_pkt_1_cnt(sent_pkt_1_cnt),
      .sent_pkt_2_cnt(sent_pkt_2_cnt),
      .sent_pkt_3_cnt(sent_pkt_3_cnt),
      .sent_time_cnt(sent_time_cnt),
      .sent_time_reg_i(sent_time_reg_in),
      .sent_num_cnt(sent_num_cnt),
      .sent_num_reg_i(sent_num_reg_in),
      .sent_ready(sent_ready),

      .rd_reg_n(rd_reg_n),

      .out_lcm_data(out_lcm_data),
      .out_lcm_data_wr(out_lcm_data_wr),
      .out_lcm_data_valid(out_lcm_data_valid),
      .out_lcm_data_valid_wr(out_lcm_data_valid_wr)
);

endmodule
