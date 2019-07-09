`timescale 1ns/1ps
module lcm_parser_tb
    (     
     );
     reg clk;
     reg rst_n;

    //Pkt Input
    reg [133:0] in_lcm_data;
    reg in_lcm_data_wr;
    reg in_lcm_data_valid;
    reg in_lcm_data_valid_wr;
    wire in_lcm_data_ready;

    //Signal Output
    wire [7:0] wr_reg_n;
    wire [63:0] wr_reg_n_value;
    wire [7:0] rd_reg_n;


    //initial   module
    lcm_parser  lcm_parser_ctl_tb(
        .clk(clk),
        .rst_n(rst_n),

    //Pkt Input
        .in_lcm_data(in_lcm_data),
        .in_lcm_data_wr(in_lcm_data_wr),
        .in_lcm_data_valid(in_lcm_data_valid),
        .in_lcm_data_valid_wr(in_lcm_data_valid_wr),
        .in_lcm_data_ready(in_lcm_data_ready),

    //Signal Output
        .wr_reg_n(wr_reg_n),
        .wr_reg_n_value(wr_reg_n_value),
        .rd_reg_n(rd_reg_n)    

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

       //  USER define
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
 
             #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;


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
              in_lcm_data ={6'b110000, 8'h04, 64'h0000_0000_0000_0004, 7'b0000_000, 1'b0, 48'h0000_0000_0004};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h15, 64'h0000_0000_0000_2345, 7'b0000_000, 1'b0, 48'h0000_0000_0005};
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h06, 64'h0000_0000_0000_0006, 7'b0000_000, 1'b0, 48'h0000_0000_0006};
            
            #CYCLE
              in_lcm_data ={6'b100000, 8'h07, 64'h0000_0000_0000_0007, 7'b0000_000, 1'b0, 48'h0000_0000_0007};

            #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;


             //  3 packet  rd  1
            #CYCLE
              in_lcm_data ={6'b010000, 8'h01, 64'h0000_0000_0000_0001, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
              in_lcm_data_wr =1'b1;
              in_lcm_data_valid =1'b0;
              in_lcm_data_valid_wr =1'b0;
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h02, 64'h0000_0000_0000_0002, 7'b0000_000, 1'b1, 48'h0000_0000_0002};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h03, 64'h0000_0000_0000_0003, 7'b0000_000, 1'b1, 48'h0000_0000_000};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h04, 64'h0000_0000_0000_0004, 7'b0000_000, 1'b1, 48'h0000_0000_0001};

            #CYCLE
              in_lcm_data ={6'b110000, 8'h05, 64'h0000_0000_0000_0005, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
            
            #CYCLE
              in_lcm_data ={6'b110000, 8'h06, 64'h0000_0000_0000_0006, 7'b0000_000, 1'b1, 48'h0000_0000_0001};
            
            #CYCLE
              in_lcm_data ={6'b100000, 8'h07, 64'h0000_0000_0000_0007, 7'b0000_000, 1'b1, 48'h0000_0000_0001};

            #CYCLE
              in_lcm_data =134'b0;
              in_lcm_data_wr =1'b0;
              in_lcm_data_valid =1'b1;
              in_lcm_data_valid_wr =1'b1;

            
            

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
              #(CYCLE/2)  clk =~clk;
         end

endmodule


