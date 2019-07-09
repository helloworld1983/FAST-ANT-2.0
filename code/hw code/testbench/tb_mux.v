/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-26 15:00:55
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-27 09:49:02
 * @Description: 
   1.Testbench for mux.
 */

`timescale 1 ns / 1 ps

module tb_mux(

);

//***************define reg and wire***************
reg clk;
reg rst_n;

//Pkt from LCM to Port_0
reg [133:0] lcm2mux_data;
reg lcm2mux_data_wr;
reg lcm2mux_data_valid;
reg lcm2mux_data_valid_wr;

//Pkt from SSM to Port_0
reg [133:0] ssm2mux_data;
reg ssm2mux_data_wr;
reg ssm2mux_data_valid;
reg ssm2mux_data_valid_wr;

//Selecting Signal from LCM
reg mux2port_0_rd;

//Pkt to Port_0
wire [133:0] mux2port_0_data;
wire mux2port_0_data_wr;
wire mux2port_0_data_valid;
wire mux2port_0_data_valid_wr;

mux mux_tb (
    .clk(clk),
    .rst_n(rst_n),

    .lcm2mux_data(lcm2mux_data),
    .lcm2mux_data_wr(lcm2mux_data_wr),
    .lcm2mux_data_valid(lcm2mux_data_valid),
    .lcm2mux_data_valid_wr(lcm2mux_data_valid_wr),

    .ssm2mux_data(ssm2mux_data),
    .ssm2mux_data_wr(ssm2mux_data_wr),
    .ssm2mux_data_valid(ssm2mux_data_valid),
    .ssm2mux_data_valid_wr(ssm2mux_data_valid_wr),

    .mux2port_0_rd(mux2port_0_rd),
    
    .mux2port_0_data(mux2port_0_data),
    .mux2port_0_data_wr(mux2port_0_data_wr),
    .mux2port_0_data_valid(mux2port_0_data_valid),
    .mux2port_0_data_valid_wr(mux2port_0_data_valid_wr)
);

parameter CYCLE = 10;

initial begin
    clk = 0;
    rst_n = 1;
    # (CYCLE / 2)
    rst_n = 0;
    # (CYCLE / 2)
    rst_n = 1;
end

always begin
    # (CYCLE / 2)
    clk = ~clk;
end

initial begin
    //tb for lcm2mux
    //mux select signal for lcm
    # CYCLE
    mux2port_0_rd = 1'b0;

    //lcm2mux pkt
    //1st
    # CYCLE
    lcm2mux_data = {6'b010000, 1'b1, 1'b1, 6'b0, 2'b0, 6'b0, 3'b0, 1'b0, 12'd96, 8'd3, 8'd129, 8'b00000100, 72'b0};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;
    //2nd
    # CYCLE
    lcm2mux_data = {6'b110000, 128'b0};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;
    //3rd
    # CYCLE
    lcm2mux_data = {6'b110000, 128'h0023cd76631a002185c52b8f08004500};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;
    //4th
    # CYCLE
    lcm2mux_data = {6'b110000, 128'h00327919000040017dfcc0a80164c0a8};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;
    //5th
    # CYCLE
    lcm2mux_data = {6'b110000, 128'h01010800c15b04000500ffffffffffff};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;
    //6th
    # CYCLE
    lcm2mux_data = {6'b100000, 8'd1, 64'd3, 56'b0};
    lcm2mux_data_wr = 1'b1;
    lcm2mux_data_valid = 1'b1;
    lcm2mux_data_valid_wr = 1'b1;
    
    //reset lcm
    #CYCLE
    lcm2mux_data = 134'b0;
    lcm2mux_data_wr = 1'b0;
    lcm2mux_data_valid = 1'b0;
    lcm2mux_data_valid_wr = 1'b0;

    //tb for lcm2mux
    //mux select signal for ssm
    #CYCLE
    mux2port_0_rd = 1'b1;
    //ssm2mux pkt
    //1st
    # CYCLE
    ssm2mux_data = {6'b010000, 1'b0, 1'b1, 6'b1, 2'b0, 6'b0, 3'b0, 1'b0, 12'd96, 8'd3, 8'd129, 8'b00000100, 72'b0};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b0;
    ssm2mux_data_valid_wr = 1'b0;
    //2nd
    # CYCLE
    ssm2mux_data = {6'b110000, 128'b0};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b0;
    ssm2mux_data_valid_wr = 1'b0;
    //3rd
    # CYCLE
    ssm2mux_data = {6'b110000, 128'h0023cd76631a002185c52b8f08004500};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b0;
    ssm2mux_data_valid_wr = 1'b0;
    //4th
    # CYCLE
    ssm2mux_data = {6'b110000, 128'h00327919000040017dfcc0a80164c0a8};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b0;
    ssm2mux_data_valid_wr = 1'b0;
    //5th
    # CYCLE
    ssm2mux_data = {6'b110000, 128'h01010800c15b04000500ffffffffffff};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b0;
    ssm2mux_data_valid_wr = 1'b0;
    //6th
    # CYCLE
    ssm2mux_data = {6'b100000, 8'd3, 64'd7, 56'b0};
    ssm2mux_data_wr = 1'b1;
    ssm2mux_data_valid = 1'b1;
    ssm2mux_data_valid_wr = 1'b1;
    
    $finish;
end

endmodule