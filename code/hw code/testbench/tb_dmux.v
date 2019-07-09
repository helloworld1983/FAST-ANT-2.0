/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-29 19:43:21
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-30 09:41:44
 * @Description: 
   1.Testbench for dmux.
 */

`timescale 1 ns / 1 ps
module tb_dmux (

);

//***************define reg and wire***************
reg clk;
reg rst_n;

reg [133:0] pktin_data;
reg pktin_data_wr;
reg pktin_data_valid;
reg pktin_data_valid_wr;
wire pktin_data_ready;

wire [133:0] dmux2pgm_data;
wire dmux2pgm_data_wr;
wire dmux2pgm_data_valid;
wire dmux2pgm_data_valid_wr;
reg pgm2dmux_data_ready;

wire [133:0] dmux2lcm_data;
wire dmux2lcm_data_wr;
wire dmux2lcm_data_valid;
wire dmux2lcm_data_valid_wr;
reg lcm2dmux_data_ready;

wire [133:0] dmux2ssm_data;
wire dmux2ssm_data_wr;
wire dmux2ssm_data_valid;
wire dmux2ssm_data_valid_wr;
reg ssm2dmux_data_ready;

dmux dmux(
    .clk(clk),
    .rst_n(rst_n),

    .pktin_data(pktin_data),
    .pktin_data_wr(pktin_data_wr),
    .pktin_data_valid(pktin_data_valid),
    .pktin_data_valid_wr(pktin_data_valid_wr),
    .pktin_data_ready(pktin_data_ready),

    .dmux2pgm_data(dmux2pgm_data),
    .dmux2pgm_data_wr(dmux2pgm_data_wr),
    .dmux2pgm_data_valid(dmux2pgm_data_valid),
    .dmux2pgm_data_valid_wr(dmux2pgm_data_valid_wr),
    .pgm2dmux_data_ready(pgm2dmux_data_ready),

    .dmux2lcm_data(dmux2lcm_data),
    .dmux2lcm_data_wr(dmux2lcm_data_wr),
    .dmux2lcm_data_valid(dmux2lcm_data_valid),
    .dmux2lcm_data_valid_wr(dmux2lcm_data_valid_wr),
    .lcm2dmux_data_ready(lcm2dmux_data_ready),
    

    .dmux2ssm_data(dmux2ssm_data),
    .dmux2ssm_data_wr(dmux2ssm_data_wr),
    .dmux2ssm_data_valid(dmux2ssm_data_valid),
    .dmux2ssm_data_valid_wr(dmux2ssm_data_valid_wr),
    .ssm2dmux_data_ready(ssm2dmux_data_ready)
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
    //pkt to ssm
    //1st
    # CYCLE 
    pktin_data = {6'b010000, 2'b0, 6'b1, 120'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //2nd
    # CYCLE
    pktin_data = {6'b110000, 128'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //3rd
    # CYCLE
    pktin_data = {6'b110000, 128'b1};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //4th
    # CYCLE
    pktin_data = {6'b110000, 128'd2};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //5th
    # CYCLE
    pktin_data = {6'b110000, 128'd3};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //6th
    # CYCLE
    pktin_data = {6'b100000, 128'd4};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b1;
    pktin_data_valid_wr = 1'b1;

    //pkt to lcm
    //1st
    # (CYCLE * 10)
    pktin_data = {6'b010000, 6'b010000, 2'b0, 6'b0, 120'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //2nd
    #CYCLE
    pktin_data = {6'b110000, 128'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //3rd
    #CYCLE
    pktin_data = {6'b110000, 96'b0, 16'h0800, 16'b1};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //4th
    #CYCLE
    pktin_data = {6'b110000, 56'b0, 8'hc8, 64'd2};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //5th
    #CYCLE
    pktin_data = {6'b110000, 128'd3};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //6th
    # CYCLE
    pktin_data = {6'b100000, 128'd4};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b1;
    pktin_data_valid_wr = 1'b1;

    //pkt to pgm
    //1st
    #(CYCLE * 10)
    pktin_data = {6'b010000, 6'b010000, 2'b0, 6'b0, 120'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //2nd
    #CYCLE
    pktin_data = {6'b110000, 128'b0};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //3rd
    #CYCLE
    pktin_data = {6'b110000, 128'b1};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //4th
    #CYCLE
    pktin_data = {6'b110000, 56'b0, 8'he9, 64'd2};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //5th
    #CYCLE
    pktin_data = {6'b110000, 128'd3};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b0;
    pktin_data_valid_wr = 1'b0;
    //6th
    # CYCLE
    pktin_data = {6'b100000, 128'd5};
    pktin_data_wr = 1'b1;
    pktin_data_valid = 1'b1;
    pktin_data_valid_wr = 1'b1;
end

endmodule