/////////////////////////////////////////////////////////////////
// MIT License
//*************************************************************
//                     Basic Information
//*************************************************************
//Vendor: NUDT
//FAST URL://www.fastswitch.org 
//Target Device: Xilinx/Intel
//Filename: pgm.v
//Version: 1.0
//Author : FAST Group
//*************************************************************
//                     Module Description
//*************************************************************
// 1)top module.
//          
//*************************************************************
//                     Revision List
//*************************************************************
//      date:  2019/06/25
//      modifier: 
//      description: 
///////////////////////////////////////////////////////////////// 
module pgm#(
    parameter    PLATFORM = "xilinx"
)(
input	wire		  clk,
input	wire		  rst_n,

//receive from DMUX  
input	wire [133:0] in_pgm_data,
input	wire	      in_pgm_data_wr,
input	wire	      in_pgm_data_valid,
input	wire	      in_pgm_data_valid_wr,
output  wire         out_pgm_data_ready,
                     
//from/to LCM   
input	wire	      pgm_config_reset,

input	wire     	  table_entry_wr,
input	wire [63:0]  sent_start_time_reg,
input	wire [63:0]  sent_rate_reg, 

input   wire           sent_start,
output  wire          sent_finish,    
input   wire           sent_model,

input   wire [63:0]    lcm2pgm_time,

output  wire [63:0]   sent_pkt_0_cnt,
output  wire [63:0]   sent_pkt_1_cnt,
output  wire [63:0]   sent_pkt_2_cnt,
output  wire [63:0]   sent_pkt_3_cnt,
output  wire [63:0]   sent_bit_cnt,

output  wire [63:0]   sent_time_cnt, 
input   wire [63:0]    sent_time_reg,

output  wire [63:0]   sent_num_cnt, 
input   wire [63:0]    sent_num_reg, 

output  wire          sent_ready, 

//to FPGA OS
input wire           in_pgm_data_ready, 
output wire [133:0]  out_pgm_data,
output wire          out_pgm_data_wr, 
output wire          out_pgm_data_valid,
output wire          out_pgm_data_valid_wr

);
//***************************************************
//        Intermediate variable Declaration
//***************************************************
//all wire/reg/parameter variable 
//should be declare below here
//pgm_wr to sch_rd
wire           wr2rd_table_entry_flag;
wire  [137:0]  wr2rd_table_entry_data;

//pgm_wr to pkt_send
wire         wr2send_raddr_wr;
wire [9:0]   wr2send_raddr;
wire [133:0] wr2send_data;

//sch_rd to pkt_send
wire         rd2send_pkt_rd;
wire [9:0]   rd2send_pkt_addr;

//***************************************************
//                  Module Instance
//***************************************************
pgm_wr pgm_wr_inst(
.clk(clk),
.rst_n(rst_n), 
//receive from DMUX  
.in_pgm_data(in_pgm_data),
.in_pgm_data_wr(in_pgm_data_wr),
.out_pgm_data_ready(out_pgm_data_ready),
//receive from LCM 
.pgm_config_reset(pgm_config_reset),
.table_entry_wr(table_entry_wr),
.sent_start_time_reg(sent_start_time_reg),
.sent_rate_reg(sent_rate_reg),
//receive from PGM_RD 
.in_pgm_wr_raddr_wr(wr2send_raddr_wr),
.in_pgm_wr_raddr(wr2send_raddr),
//transmit to PGM_RD 
.table_entry_flag(wr2rd_table_entry_flag),
.table_entry_data(wr2rd_table_entry_data),
.out_pgm_wr_data(wr2send_data),
//configure four streams successfully(to lcm)
.sent_ready(sent_ready)
);

pgm_rd_schedule pgm_rd_schedule_inst(
.clk(clk),
.rst_n(rst_n),
//from/to lcm                         
.pgm_config_reset(pgm_config_reset), 
.sent_start(sent_start),       
.sent_finish(sent_finish),      
.sent_model(sent_model),       
.sent_time_cnt(sent_time_cnt),    
.sent_time_reg(sent_time_reg),    
.sent_num_cnt(sent_num_cnt),     
.sent_num_reg(sent_num_reg),                                           
//from pgm_wr                         
.table_entry_flag(wr2rd_table_entry_flag), 
.table_entry_data(wr2rd_table_entry_data),  
.ram2rd_data(wr2send_data),                                   
//transmit to pkt_send                
.sent_pkt_rd(rd2send_pkt_rd),      
.sent_pkt_addr(rd2send_pkt_addr)        

);

pgm_rd_pkt_send pgm_rd_pkt_send_inst(
.clk(clk),
.rst_n(rst_n),
//from sch_rd
.sent_pkt_rd(rd2send_pkt_rd),
.sent_pkt_addr(rd2send_pkt_addr),  
//from pgm_ram
.ram2rd_data(wr2send_data), 
//from/to lcm 
.pgm_config_reset(pgm_config_reset),
.lcm2pgm_time(lcm2pgm_time),  
.sent_pkt_0_cnt(sent_pkt_0_cnt),
.sent_pkt_1_cnt(sent_pkt_1_cnt),
.sent_pkt_2_cnt(sent_pkt_2_cnt),
.sent_pkt_3_cnt(sent_pkt_3_cnt),
.sent_bit_cnt(sent_bit_cnt),
//to pgm_ram
.rd2ram_rd(wr2send_raddr_wr),
.rd2ram_addr(wr2send_raddr),
//to FPGA OS
.in_pgm_data_ready(in_pgm_data_ready), 
.out_pgm_data(out_pgm_data),
.out_pgm_data_wr(out_pgm_data_wr), 
.out_pgm_data_valid(out_pgm_data_valid),
.out_pgm_data_valid_wr(out_pgm_data_valid_wr)

);
endmodule

