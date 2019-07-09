`timescale 1ns/1ps
module tb_lcm
    (
     );
     reg clk;
     reg rst_n;

       //Pkt from DMUX
     reg [133:0] in_lcm_data;
     reg in_lcm_data_wr;
     reg in_lcm_data_valid;
     reg in_lcm_data_valid_wr;
     wire in_lcm_data_ready;

    //Pkt to MUX
     wire [133:0] out_lcm_data;
     wire out_lcm_data_wr;
     wire out_lcm_data_valid;
     wire out_lcm_data_valid_wr;
     reg out_lcm_data_ready;

    //Config Information
    //SSM
     wire lcm2ssm_reset;
     wire  lcm2ssm_rd;
     wire [10:0] lcm2ssm_addr;
     wire [7:0] protocol_type;
     reg ssm_bit;
     reg ssm_pkt_num;

    //PGM
     wire pgm_config_reset;
     wire [63:0] sent_start_time_n_reg_out;
     reg [63:0] sent_start_time_n_reg_in;
     wire [63:0] sent_rate_n_reg_out;
     reg [63:0] sent_rate_n_reg_in;
     wire sent_start;
     reg sent_finish;
     wire sent_model;
     reg [63:0] sent_bit_cnt;
     reg [63:0] sent_pkt_n_cnt;
     reg [63:0] sent_time_cnt;
     reg [63:0] sent_time_reg_in;
     wire [63:0] sent_time_reg_out;
     reg [63:0] sent_num_cnt;
     reg [63:0] sent_num_reg_in;
     wire [63:0] sent_num_reg_out;
     reg sent_ready;
    
    //MUX
     wire mux2port_0_rd;

    //Timer
     wire [63:0] lcm_timestamp;


     //  initial module
     lcm  lcm_ctl_tb(
        .clk(clk),
        .rst_n(rst_n),

       //Pkt from DMUX
        .in_lcm_data(in_lcm_data),
        .in_lcm_data_wr(in_lcm_data_wr),
        .in_lcm_data_valid(in_lcm_data_valid),
        .in_lcm_data_valid_wr(in_lcm_data_valid_wr),
        .in_lcm_data_ready(in_lcm_data_ready),

    //Pkt to MUX
        .out_lcm_data(out_lcm_data),
        .out_lcm_data_wr(out_lcm_data_wr),
        .out_lcm_data_valid(out_lcm_data_valid),
        .out_lcm_data_valid_wr(out_lcm_data_valid_wr),
        .out_lcm_data_ready(out_lcm_data_ready),

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
        .sent_start_time_n_reg_out(sent_start_time_n_reg_out),
        .sent_start_time_n_reg_in(sent_start_time_n_reg_in),
        .sent_rate_n_reg_out(sent_rate_n_reg_out),
        .sent_rate_n_reg_in(sent_rate_n_reg_in),
        .sent_start(sent_start),
        .sent_finish(sent_finish),
        .sent_model(sent_model),
        .sent_bit_cnt(sent_bit_cnt),
        .sent_pkt_n_cnt(sent_pkt_n_cnt),
        .sent_time_cnt(sent_time_cnt),
        .sent_time_reg_in(sent_time_reg_in),
        .sent_time_reg_out(sent_time_reg_out),
        .sent_num_cnt(sent_num_cnt),
        .sent_num_reg_in(sent_num_reg_in),
        .sent_num_reg_out(sent_num_reg_out),
        .sent_ready(sent_ready),
    
    //MUX
        .mux2port_0_rd(mux2port_0_rd),

    //Timer
        .lcm_timestamp(lcm_timestamp)

     );


     parameter CYCLE=10;

     //  reset
     initial begin
         clk =0;
         rst_n =1;
         #(5)
         rst_n =0;
         #(5)
         rst_n =1;
     end


     //
     initial begin
           //  1 packet  rd  1
            #CYCLE
              in_lcm_data ={6'b010000, 8'h01, 64'h0000_0000_0000_0001, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
              in_lcm_data_wr =1'b1;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h02, 64'h0000_0000_0000_0002, 7'b0000_000, 1'b1, 48'h0000_0000_0002};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h03, 64'h0000_0000_0000_0003, 7'b0000_000, 1'b1, 48'h0000_0000_0003};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h04, 64'h0000_0000_0000_0004, 7'b0000_000, 1'b1, 48'h0000_0000_0004};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h05, 64'h0000_0000_0000_0005, 7'b0000_000, 1'b1, 48'h0000_0000_0005};
            
            #CYCLE
              in_lcm_data ={6'b100000, 8'h06, 64'h0000_0000_0000_0006, 7'b0000_000, 1'b1, 48'h0000_0000_0006};
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;


             #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;


               //  2 packet  wr  2
            #CYCLE
              in_lcm_data ={6'b010000, 8'h01, 64'h0000_0000_0000_0007, 7'b0000_000, 1'b0, 48'h0000_0000_0007};
              in_lcm_data_wr =1'b1;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h02, 64'h0000_0000_0000_0008, 7'b0000_000, 1'b0, 48'h0000_0000_0008};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h03, 64'h0000_0000_0000_0009, 7'b0000_000, 1'b0, 48'h0000_0000_0009};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h04, 64'h0000_0000_0000_000a, 7'b0000_000, 1'b0, 48'h0000_0000_0004};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h15, 64'h0000_0000_0000_000b, 7'b0000_000, 1'b0, 48'h0000_0000_0005};
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h06, 64'h0000_0000_0000_000c, 7'b0000_000, 1'b0, 48'h0000_0000_0006};
            
            #CYCLE
              in_lcm_data ={6'b100000, 8'h07, 64'h0000_0000_0000_000d, 7'b0000_000, 1'b0, 48'h0000_0000_0007};
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;

            #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;


             //  3 packet  rd  1
            #CYCLE
              in_lcm_data ={6'b010000, 8'h01, 64'h0000_0000_0000_000e, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
              in_lcm_data_wr =1'b1;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h02, 64'h0000_0000_0000_000f, 7'b0000_000, 1'b1, 48'h0000_0000_0002};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h03, 64'h0000_0000_0000_0010, 7'b0000_000, 1'b1, 48'h0000_0000_000};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h04, 64'h0000_0000_0000_0011, 7'b0000_000, 1'b1, 48'h0000_0000_0001};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h05, 64'h0000_0000_0000_0012, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h06, 64'h0000_0000_0000_0013, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
            
            #CYCLE
              in_lcm_data ={6'b100000, 8'h07, 64'h0000_0000_0000_0014, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;

            #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;

            
            

            //  finish
            #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;

             
             #(100*CYCLE);
             $finish;

     end
  
     always begin
        #(5)  clk =~clk; 
     end


endmodule