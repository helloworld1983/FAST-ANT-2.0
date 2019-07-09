`timescale 1ns/1ps
module tb_dmux
     (
      );
      reg clk;
      reg rst_n;

      //Pkt from FPGA OS
    reg [133:0] pktin_data;
    reg pktin_data_wr;
    reg pktin_data_valid;
    reg pktin_data_valid_wr;
    //                                                       output reg pktin_ready,

    //Pkt to PGM
    wire [133:0] dmux2pgm_data;
    wire dmux2pgm_data_wr;
    wire dmux2pgm_data_valid;
    wire dmux2pgm_data_valid_wr;
    //                                                       input pgm2dmux_data_ready,

    //Pkt to LCM
    wire [133:0] dmux2lcm_data;
    wire dmux2lcm_data_wr;
    wire dmux2lcm_data_valid;
    wire dmux2lcm_data_valid_wr;
    //                                                        input lcm2dmux_data_ready,

    //Pkt to SSM
    wire [133:0] dmux2ssm_data;
    wire dmux2ssm_data_wr;
    wire dmux2ssm_data_valid;
    wire dmux2ssm_data_valid_wr;
    //                                                      input ssm2dmux_data_ready



// initial module
    dmux dmux_ctl_tb(
        .clk(clk),
        .rst_n(rst_n),
        
         //Pkt from FPGA OS
        .pktin_data(pktin_data),
        .pktin_data_wr(pktin_data_wr),
        .pktin_data_valid(pktin_data_valid),
        .pktin_data_valid_wr(pktin_data_valid_wr),
    //                                                       

    //Pkt to PGM
        .dmux2pgm_data(dmux2pgm_data),
        .dmux2pgm_data_wr(dmux2pgm_data_wr),
        .dmux2pgm_data_valid(dmux2pgm_data_valid),
        .dmux2pgm_data_valid_wr(dmux2pgm_data_valid_wr),
    //                                                        

    //Pkt to LCM
        .dmux2lcm_data(dmux2lcm_data),
        .dmux2lcm_data_wr(dmux2lcm_data_wr),
        .dmux2lcm_data_valid(dmux2lcm_data_valid),
        .dmux2lcm_data_valid_wr(dmux2lcm_data_valid_wr),
    //                                                         

    //Pkt to SSM
        .dmux2ssm_data(dmux2ssm_data),
        .dmux2ssm_data_wr(dmux2ssm_data_wr),
        .dmux2ssm_data_valid(dmux2ssm_data_valid),
        .dmux2ssm_data_valid_wr(dmux2ssm_data_valid_wr)

    );


       parameter CYCLE=10;


       //  reset
       initial begin
           clk = 0;
           rst_n =1;
           #(5)
           rst_n =0;
           #(5)
           rst_n =1;
       end


       // user define
       initial begin
           //  1 packet   pgm 1
           #CYCLE
            pktin_data ={6'b010000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd0 };
            pktin_data_wr =1'b1;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;
           
            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd1 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd2 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd3 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd4 };

            #CYCLE
            pktin_data ={6'b100000, 8'b0000_0000, 8'b0000_0000, 3'b001, 109'd5 };
            pktin_data_valid =1'b1;
            pktin_data_valid_wr =1'b1;

            #CYCLE
            pktin_data =134'b0;
            pktin_data_wr =1'b0;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;



            //  2 packet    lcm 2
            #CYCLE
            pktin_data ={6'b010000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd0 };
            pktin_data_wr =1'b1;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;
           
            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd1 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd2 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd3 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd4 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd5 };

            #CYCLE
            pktin_data ={6'b100000, 8'b0000_0000, 8'b0000_0000, 3'b111, 109'd6 };
            pktin_data_valid =1'b1;
            pktin_data_valid_wr =1'b1;

            #CYCLE
            pktin_data =134'b0;
            pktin_data_wr =1'b0;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;



             //  3 packet    ssm 3
            #CYCLE
            pktin_data ={6'b010000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd0 };
            pktin_data_wr =1'b1;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;
           
            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd1 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd2 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd3 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd4 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd5 };

            #CYCLE
            pktin_data ={6'b110000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd6 };
            
            #CYCLE
            pktin_data ={6'b100000, 8'b0000_0001, 8'b0000_0000, 3'b111, 109'd7 };
            pktin_data_valid =1'b1;
            pktin_data_valid_wr =1'b1;

            #CYCLE
            pktin_data =134'b0;
            pktin_data_wr =1'b0;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;



            //finish
            #CYCLE
            pktin_data =134'b0;
            pktin_data_wr =1'b0;
            pktin_data_valid =1'b0;
            pktin_data_valid_wr =1'b0;

            #(100*CYCLE);
            $finish;
        end

        always begin
           #(CYCLE/2) clk = ~clk;  
        end

endmodule