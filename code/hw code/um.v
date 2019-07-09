/////////////////////////////////////////////////////////////////
// MIT License
//*************************************************************
//                     Basic Information
//*************************************************************
//Vendor: NUDT
//FAST URL://www.fastswitch.org 
//Target Device: Xilinx/Intel
//Filename: um.v
//Version: 1.0
//Author : FAST Group
//*************************************************************
//                     Module Description
//*************************************************************
// 1)um: top module;
//          
//*************************************************************
//                     Revision List
//*************************************************************
//      date:  2019/06/21
//      modifier: 
//      description: 
///////////////////////////////////////////////////////////////// 
`timescale 1ns / 1ps
module um(
input  wire  clk,
input  wire  rst_n,

input  wire  [133:0]pktin_data,
input  wire  pktin_data_wr,
input  wire  pktin_data_valid,
input  wire  pktin_data_valid_wr,
output wire  pktin_data_ready,
//port_0
output wire  [133:0]pktout_data_0,
output wire  pktout_data_wr_0,
output wire  pktout_data_valid_0,
output wire  pktout_data_valid_wr_0,
input  wire  pktout_data_ready_0,
//port_1
output wire  [133:0]pktout_data_1,
output wire  pktout_data_wr_1,
output wire  pktout_data_valid_1,
output wire  pktout_data_valid_wr_1,
input  wire  pktout_data_ready_1,
//port_2
output wire  [133:0]pktout_data_2,
output wire  pktout_data_wr_2,
output wire  pktout_data_valid_2,
output wire  pktout_data_valid_wr_2,
input  wire  pktout_data_ready_2,
//port_3
output wire  [133:0]pktout_data_3,
output wire  pktout_data_wr_3,
output wire  pktout_data_valid_3,
output wire  pktout_data_valid_wr_3,
input  wire  pktout_data_ready_3,
);

assign pktout_data_2 = 134'b0;
assign pktout_data_wr_2 = 1'b0;
assign pktout_data_valid_2 = 1'b0;
assign pktout_data_valid_wr_2 = 1'b0;

assign pktout_data_3 = 134'b0;
assign pktout_data_wr_3 = 1'b0;
assign pktout_data_valid_3 = 1'b0;
assign pktout_data_valid_wr_3 = 1'b0;

//dmux-pgm
 wire  [133:0]dmux2pgm_data;   
 wire  dmux2pgm_data_wr;       
 wire  dmux2pgm_data_valid;    
 wire  dmux2pgm_data_valid_wr; 
 wire  pgm2dmux_data__ready; 
//dmux-lcm
 wire  [133:0]dmux2lcm_data;   
 wire  dmux2lcm_data_wr;       
 wire  dmux2lcm_data_valid;    
 wire  dmux2lcm_data_valid_wr; 
 wire  lcm2dmux_data__ready; 
//dmux-ssm
 wire  [133:0]dmux2ssm_data;   
 wire  dmux2ssm_data_wr;       
 wire  dmux2ssm_data_valid;    
 wire  dmux2ssm_data_valid_wr; 
 wire  ssm2dmux_data__ready;  
 //ssm-mux
 wire  [133:0]ssm2mux_data;   
 wire  ssm2mux_data_wr;       
 wire  ssm2mux_data_valid;    
 wire  ssm2mux_data_valid_wr; 
 wire  mux2ssm_data__ready; 
  //lcm-mux
 wire  [133:0]lcm2mux_data;   
 wire  lcm2mux_data_wr;       
 wire  lcm2mux_data_valid;    
 wire  lcm2mux_data_valid_wr; 
 wire  mux2lcm_data_ready;   
 wire  mux2port_0_rd;
 //lcm-ssm 
 wire lcm2ssm_reset;      
 wire lcm2ssm_rd;        
 wire [10:0] lcm2ssm_addr; 
 wire [7:0] protocol_type; 
wire [63:0]ssm_bit;                   
wire [63:0]ssm_pkt_num;               
//lcm-pgm
wire	      pgm_config_reset;                                          
wire     	  table_entry_wr;         
wire [63:0]  sent_start_time_n_reg;   
wire [63:0]  sent_rate_n_reg;                                            
wire           sent_start;        
wire          sent_finish;        
wire           sent_model;                                                                                
wire [63:0]   sent_pkt_0_cnt;     
wire [63:0]   sent_pkt_1_cnt;     
wire [63:0]   sent_pkt_2_cnt;     
wire [63:0]   sent_pkt_3_cnt;     
wire [63:0]   sent_bit_cnt;       
                                  
wire [63:0]   sent_time_cnt;     
wire [63:0]    sent_time_reg;     
                                  
wire [63:0]   sent_num_cnt;       
wire [63:0]    sent_num_reg;                                     
wire          sent_ready;                                           
wire [63:0]   lcm_timestamp;
 
dmux dmux_inst(
.clk(clk),
.rst_n(rst_n),
 //Pkt from FPGA OS
.pktin_data_ready(pktin_data_ready),   
.pktin_data(pktin_data),
.pktin_data_wr(pktin_data_wr),
.pktin_data_valid(pktin_data_valid),
.pktin_data_valid_wr(pktin_data_valid_wr),                                                   
//Pkt to PGM
//.pgm2dmux_data__ready(pgm2dmux_data__ready),  
.dmux2pgm_data(dmux2pgm_data),
.dmux2pgm_data_wr(dmux2pgm_data_wr),
.dmux2pgm_data_valid(dmux2pgm_data_valid),
.dmux2pgm_data_valid_wr(dmux2pgm_data_valid_wr),                                                      
//Pkt to LCM
//.lcm2dmux_data__ready(lcm2dmux_data__ready),
.dmux2lcm_data(dmux2lcm_data),
.dmux2lcm_data_wr(dmux2lcm_data_wr),
.dmux2lcm_data_valid(dmux2lcm_data_valid),
.dmux2lcm_data_valid_wr(dmux2lcm_data_valid_wr),                                                        
//Pkt to SSM
//.ssm2dmux_data__ready(ssm2dmux_data__ready),
.dmux2ssm_data(dmux2ssm_data),
.dmux2ssm_data_wr(dmux2ssm_data_wr),
.dmux2ssm_data_valid(dmux2ssm_data_valid),
.dmux2ssm_data_valid_wr(dmux2ssm_data_valid_wr)
 );
 
lcm  lcm_inst(
.clk(clk),
.rst_n(rst_n),
//Pkt from DMUX
.in_lcm_data(dmux2lcm_data),
.in_lcm_data_wr(dmux2lcm_data_wr),
.in_lcm_data_valid(dmux2lcm_data_valid),
.in_lcm_data_valid_wr(dmux2lcm_data_valid_wr),
.in_lcm_data_ready(lcm2dmux_data__ready),

//Pkt to MUX
.out_lcm_data(lcm2mux_data),
.out_lcm_data_wr(lcm2mux_data_wr),
.out_lcm_data_valid(lcm2mux_data_valid),
.out_lcm_data_valid_wr(lcm2mux_data_valid_wr),
.out_lcm_data_ready(mux2lcm_data_ready),

//Config Information
//SSM
.lcm2ssm_reset(lcm2ssm_reset),
.lcm2ssm_rd(lcm2ssm_rd),
.lcm2ssm_addr(lcm2ssm_addr),
.protocol_type(protocol_type),
.ssm_bit(ssm_bit),
.ssm_pkt_num(ssm_pkt_num),

//PGM
.pgm_config_reset(pgm_config_reset),
.table_entry_wr(table_entry_wr), 
.sent_start_time_n_reg_out(sent_start_time_n_reg),
//.sent_start_time_n_reg_in(sent_start_time_n_reg_in),
.sent_rate_n_reg_out(sent_rate_n_reg),
//.sent_rate_n_reg_in(sent_rate_n_reg_in),
.sent_start(sent_start),
.sent_finish(sent_finish),
.sent_model(sent_model),
.sent_bit_cnt(sent_bit_cnt),
.sent_pkt_0_cnt(sent_pkt_0_cnt),
.sent_pkt_1_cnt(sent_pkt_1_cnt),
.sent_pkt_2_cnt(sent_pkt_2_cnt),
.sent_pkt_3_cnt(sent_pkt_3_cnt),
.sent_time_cnt(sent_time_cnt),
//.sent_time_reg_in(sent_time_reg_in),
.sent_time_reg_out(sent_time_reg),
.sent_num_cnt(sent_num_cnt),
//.sent_num_reg_in(sent_num_reg_in),
.sent_num_reg_out(sent_num_reg),
.sent_ready(sent_ready),
    
//MUX
.mux2port_0_rd(mux2port_0_rd),

//Timer
.lcm_timestamp(lcm_timestamp)

);
pgm pgm_inst(
.clk(clk),
.rst_n(rst_n),

.in_pgm_data(dmux2pgm_data),           
.in_pgm_data_wr(dmux2pgm_data_wr),      
.in_pgm_data_valid(dmux2pgm_data_valid),    
.in_pgm_data_valid_wr(dmux2pgm_data_valid_wr), 
//.out_pgm_data_ready(pgm2dmux_data__ready),   
                       
.pgm_config_reset(pgm_config_reset),    
                       
.table_entry_wr(table_entry_wr),          
.sent_start_time_reg(sent_start_time_n_reg),  
.sent_rate_reg(sent_rate_n_reg),        
                      
.sent_start(sent_start),           
.sent_finish(sent_finish),          
.sent_model(sent_model),           
                      
.lcm2pgm_time(lcm_timestamp),         
                       
.sent_pkt_0_cnt(sent_pkt_0_cnt),       
.sent_pkt_1_cnt(sent_pkt_1_cnt),       
.sent_pkt_2_cnt(sent_pkt_2_cnt),       
.sent_pkt_3_cnt(sent_pkt_3_cnt),       
.sent_bit_cnt(sent_bit_cnt),         
                       
.sent_time_cnt(sent_time_cnt),        
.sent_time_reg(sent_time_reg),        
                       
.sent_num_cnt(sent_num_cnt),         
.sent_num_reg(sent_num_reg),         
                      
.sent_ready(sent_ready),           
                       
//.in_pgm_data_ready(pktout_data_ready_1),    
.out_pgm_data(pktout_data_1),         
.out_pgm_data_wr(pktout_data_wr_1),      
.out_pgm_data_valid(pktout_data_valid_1),   
.out_pgm_data_valid_wr(pktout_data_valid_wr_1)
);

ssm_ram ssm_ram_inst(
.clk(clk),
.rst_n(rst_n),

.lcm2ssm_reset(lcm2ssm_reset),
.lcm2ssm_time(lcm_timestamp),
.lcm2ssm_rd(lcm2ssm_rd),
.lcm2ssm_addr(lcm2ssm_addr),

.ssm_bit(ssm_bit),
.ssm_pkt_num(ssm_pkt_num),

// port or cpu
.dmux2ssm_data(dmux2ssm_data),
.dmux2ssm_data_wr(dmux2ssm_data_wr),
.dmux2ssm_valid(dmux2ssm_data_valid),
.dmux2ssm_valid_wr(dmux2ssm_data_valid_wr),
//.ssm2dmux_data__ready(ssm2dmux_data__ready),

.ssm2mux_data(ssm2mux_data),
.ssm2mux_data_wr(ssm2mux_data_wr),
.ssm2mux_valid(ssm2mux_data_valid),
.ssm2mux_valid_wr(ssm2mux_data_valid_wr)
);

mux mux_inst(
.clk(clk),
.rst_n(rst_n),                                                                                 
                                         
//Pkt from SSM to Port_0                 
.ssm2mux_data(ssm2mux_data),              
.ssm2mux_data_wr(ssm2mux_data_wr),                   
.ssm2mux_data_valid(ssm2mux_data_valid),                
.ssm2mux_data_valid_wr(ssm2mux_data_valid_wr),
.mux2ssm_data__ready(mux2ssm_data__ready),
 //Pkt from LCM to Port_0              
.lcm2mux_data(lcm2mux_data), 
.lcm2mux_data_wr(lcm2mux_data_wr), 
.lcm2mux_data_valid(lcm2mux_data_valid), 
.lcm2mux_data_valid_wr(lcm2mux_data_valid_wr),
//.mux2lcm_data_ready(mux2lcm_data_ready), 
                                       
//Selecting Signal from LCM              
.mux2port_0_rd(mux2port_0_rd),                     
                                         
//Pkt to Port_0                          
.mux2port_0_data(pktout_data_0),      
.mux2port_0_data_wr(pktout_data_wr_0),           
.mux2port_0_data_valid(pktout_data_valid_0),        
.mux2port_0_data_valid_wr(pktout_data_valid_wr_0)
//.port2mux_0_data_ready(pktout_data_ready_0)     
);
endmodule


