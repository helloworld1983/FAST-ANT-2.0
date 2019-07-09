`timescale 1ns / 1ps
module ssm_ram #(
    parameter PLATFORM = "Xilinx"
)(
    input clk,
    input rst_n,

    // 
    input lcm2ssm_reset,
    input [63:0] lcm2ssm_time,
    input lcm2ssm_rd,
    input [10:0] lcm2ssm_addr,
    
    //
    output [63:0] ssm_bit,
    output [63:0] ssm_pkt_num,

    // port or cpu
    input [133:0] dmux2ssm_data,
    input dmux2ssm_data_wr,
    input dmux2ssm_valid,
    input dmux2ssm_valid_wr,

    output [133:0] ssm2mux_data,
    output ssm2mux_data_wr,
    output ssm2mux_valid,
    output ssm2mux_valid_wr
);
    //  RAM  write and read
    wire [10:0] ssm2ram_wr_addr;
    wire [133:0] ssm2ram_data;
    wire ssm2ram_data_wr;

    wire [133:0] ram2ssm_data;
    wire [10:0] ssm2ram_rd_addr;
    wire ssm2ram_rd;



//****************************************************
//             Module Instance
//****************************************************

ssm #( 
  //  .PLATFORM(PLATFORM),
 //   .LMID(),
 //   .NMID()
)ssm (
    .clk(clk),
    .rst_n(rst_n),

    .lcm2ssm_reset(lcm2ssm_reset),
    .lcm2ssm_time(lcm2ssm_time),
    .lcm2ssm_rd(lcm2ssm_rd),
    .lcm2ssm_addr(lcm2ssm_addr),

    .ssm_bit(ssm_bit),
    .ssm_pkt_num(ssm_pkt_num),

    .dmux2ssm_data(dmux2ssm_data),
    .dmux2ssm_data_wr(dmux2ssm_data_wr),
    .dmux2ssm_valid(dmux2ssm_valid),
    .dmux2ssm_valid_wr(dmux2ssm_valid_wr),

    .ssm2mux_data(ssm2mux_data),
    .ssm2mux_data_wr(ssm2mux_data_wr),
    .ssm2mux_valid(ssm2mux_valid),
    .ssm2mux_valid_wr(ssm2mux_valid_wr),

    .ssm2ram_wr_addr(ssm2ram_wr_addr),
    .ssm2ram_data(ssm2ram_data),
    .ssm2ram_data_wr(ssm2ram_data_wr),

    .ram2ssm_data(ram2ssm_data),
    .ssm2ram_rd_addr(ssm2ram_rd_addr),
    .ssm2ram_rd(ssm2ram_rd)
);


//************IP CORES
ram_134_2048  ram_134_2048_inst(
    .clka(clk),
    .addra(ssm2ram_wr_addr),
    .dina(ssm2ram_data),
    .ena(1'b1),
    .wea(ssm2ram_data_wr),

    .clkb(clk),
    .addrb(ssm2ram_rd_addr),
    .doutb(ram2ssm_data),
    .enb(ssm2ram_rd)
);

endmodule
