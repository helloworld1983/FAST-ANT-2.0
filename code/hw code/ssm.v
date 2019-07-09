`timescale 1ns / 1ps
module ssm #(
     parameter PLATFORM = "Xilinx"
         //     LMID=8'd2,
         //     NIMD=8'd3
)
(
     input clk,
     input rst_n,
     
     input lcm2ssm_reset,
     input [63:0] lcm2ssm_time,
     
     // read signal
     input lcm2ssm_rd,
     input [10:0]lcm2ssm_addr,

     // statistic
     output [63:0] ssm_bit,
     output [63:0] ssm_pkt_num,

     // receive the data
     input [133:0] dmux2ssm_data,
     input dmux2ssm_data_wr,
     input dmux2ssm_valid,
     input dmux2ssm_valid_wr,

     // data transmit to next module (rd)
     output [133:0] ssm2mux_data,
     output ssm2mux_data_wr,
     output ssm2mux_valid,
     output ssm2mux_valid_wr,

     // store to RAM
     output [10:0] ssm2ram_wr_addr,
     output [133:0] ssm2ram_data,
     output ssm2ram_data_wr,

     // read from RAM
     output ssm2ram_rd,
     input [133:0] ram2ssm_data,
     output [10:0] ssm2ram_rd_addr
);




//***************************************
//            Module  Instance            
//***************************************
  ssm_reg #(
      )ssm_reg(
       .clk(clk),
       .rst_n(rst_n),
    
       //  receive data
       .in_ssm_reg_data(dmux2ssm_data),
       .in_ssm_reg_data_wr(dmux2ssm_data_wr),
       .in_ssm_reg_valid(dmux2ssm_valid),
       .in_ssm_reg_valid_wr(dmux2ssm_valid_wr),
   
       //reset
       .reset_reg(lcm2ssm_reset),
    
       // outcome
       .ssm_bit_reg2lcm(ssm_bit),
       .ssm_pkt_num2lcm(ssm_pkt_num)
  );
   
   
  ssm_wr #(
      )ssm_wr(
       .clk(clk),
       .rst_n(rst_n),

       //  receive data
       .in_ssm_wr_data(dmux2ssm_data),
       .in_ssm_wr_data_wr(dmux2ssm_data_wr),
       .in_ssm_wr_valid(dmux2ssm_valid),
       .in_ssm_wr_valid_wr(dmux2ssm_valid_wr),
       
       //  receive time
       .lcm2ssm_wr_time(lcm2ssm_time),

       //reset
       .reset_wr(lcm2ssm_reset),

       //  write data to RAM
       .ssm_wr_addr(ssm2ram_wr_addr),
       .out_ssm_wdata(ssm2ram_data),
       .out_ssm_wdata_wr(ssm2ram_data_wr)
      );

  ssm_rd #(
      )ssm_rd(
       .clk(clk),
       .rst_n(rst_n),

       //  read signal
       .lcm2ram_rd(lcm2ssm_rd),
       .lcm2ram_rd_addr(lcm2ssm_addr),

       // data read from RAM
       .ram2ssm_rd_data(ram2ssm_data),

       //  read data from RAM
       .ram_rd_addr(ssm2ram_rd_addr),
       .ram_rd(ssm2ram_rd),

       // transmit data
       .out_ssm_rd_data(ssm2mux_data),
       .out_ssm_rd_data_wr(ssm2mux_data_wr),
       .out_ssm_rd_valid(ssm2mux_valid),
       .out_ssm_rd_valid_wr(ssm2mux_valid_wr)
      );

endmodule
