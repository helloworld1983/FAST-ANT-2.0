/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-27 08:18:14
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-27 09:56:05
 * @Description: 
   1.Testbench for lcm_reg_wr.
 */

`timescale 1 ns / 1 ps
module tb_lcm_reg_wr (

);

//***************define reg and wire***************
reg clk;
reg rst_n;

reg [7:0] wr_reg_n;
reg [63:0] wr_reg_n_value;

wire lcm2ssm_reset;
wire lcm2ssm_rd;
wire [10:0] lcm2ssm_addr;
wire [7:0] protocol_type;
wire pgm_config_reset;
wire [63:0] sent_start_time_n_reg_o;
wire [63:0] sent_rate_n_reg_o;
wire sent_start;
wire sent_model;
wire [63:0] sent_time_reg_o;
wire [63:0] sent_num_reg_o;
wire mux2port_0_rd;

lcm_reg_wr lcm_reg_wr_tb(
    .clk(clk),
    .rst_n(rst_n),
    
    .wr_reg_n(wr_reg_n),
    .wr_reg_n_value(wr_reg_n_value),

    .lcm2ssm_reset(lcm_reg_wr),
    .lcm2ssm_rd(lcm2ssm_rd),
    .lcm2ssm_addr(lcm2ssm_addr),
    .protocol_type(protocol_type),
    .pgm_config_reset(pgm_config_reset),
    .sent_start_time_n_reg_o(sent_start_time_n_reg_o),
    .sent_rate_n_reg_o(sent_rate_n_reg_o),
    .sent_start(sent_start),
    .sent_model(sent_model),
    .sent_time_reg_o(sent_time_reg_o),
    .sent_num_reg_o(sent_num_reg_o),
    .mux2port_0_rd(mux2port_0_rd)
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
    wr_reg_n = 8'd1;
    wr_reg_n_value = 64'd0;

    # CYCLE
    wr_reg_n = 8'd2;
    wr_reg_n_value = 64'd1;

    # CYCLE
    wr_reg_n = 8'd3;
    wr_reg_n_value = 64'd2;

    # CYCLE
    wr_reg_n = 8'd4;
    wr_reg_n_value = 64'd3;

    # CYCLE
    wr_reg_n = 8'd5;
    wr_reg_n_value = 64'd4;

    # CYCLE
    wr_reg_n = 8'd6;
    wr_reg_n_value = 64'd5;

    # CYCLE
    wr_reg_n = 8'd7;
    wr_reg_n_value = 64'd6;

    # CYCLE
    wr_reg_n = 8'd8;
    wr_reg_n_value = 64'd7;

    # CYCLE
    wr_reg_n = 8'd9;
    wr_reg_n_value = 64'd8;

    # CYCLE
    wr_reg_n = 8'd10;
    wr_reg_n_value = 64'd9;

    # CYCLE
    wr_reg_n = 8'd11;
    wr_reg_n_value = 64'd10;

    # CYCLE
    wr_reg_n = 8'd12;
    wr_reg_n_value = 64'd11;

    $finish;

end

endmodule