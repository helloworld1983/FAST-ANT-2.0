`timescale 1 ns/ 1ps
module tb_ssm_ram
   (    
    );
    reg clk;
    reg rst_n;
      
    reg lcm2ssm_reset;
    reg [63:0] lcm2ssm_time;
    reg lcm2ssm_rd;
    reg [10:0] lcm2ssm_addr;
    
    //
    wire [63:0] ssm_bit;
    wire [63:0] ssm_pkt_num;

    // port or cpu
    reg [133:0] dmux2ssm_data;
    reg dmux2ssm_data_wr;
    reg dmux2ssm_valid;
    reg dmux2ssm_valid_wr;

    wire [133:0] ssm2mux_data;
    wire ssm2mux_data_wr;
    wire ssm2mux_valid;
    wire ssm2mux_valid_wr;



    //initialize module
        ssm_ram   ssm_ram_ctl_tb(
            .clk(clk),
            .rst_n(rst_n),

            .lcm2ssm_reset(lcm2ssm_reset),
            .lcm2ssm_time(lcm2ssm_time),
            .lcm2ssm_rd(lcm2ssm_rd),
            .lcm2ssm_addr(lcm2ssm_addr),
    
    //
            .ssm_bit(ssm_bit),
            .ssm_pkt_num(ssm_pkt_num),

    // port or cpu
            .dmux2ssm_data(dmux2ssm_data),
            .dmux2ssm_data_wr(dmux2ssm_data_wr),
            .dmux2ssm_valid(dmux2ssm_valid),
            .dmux2ssm_valid_wr(dmux2ssm_valid_wr),

            .ssm2mux_data(ssm2mux_data),
            .ssm2mux_data_wr(ssm2mux_data_wr),
            .ssm2mux_valid(ssm2mux_valid),
            .ssm2mux_valid_wr(ssm2mux_valid_wr)
        );


     parameter CYCLE=10;

       //******reset
       initial begin
           clk = 0;
           rst_n =1;
           #(5)
           rst_n =0;
           #(5)
           rst_n =1;
       end
        
       //******user code
       initial begin
         //   1 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010000, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b100000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

         /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */



        //   2 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010000, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b100000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

         /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   3 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010000, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b100000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

         /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */



         /*
 
          #CYCLE
          lcm2ssm_rd =1'b1;
          lcm2ssm_addr =11'd128;

        

           #(CYCLE*4'd15)
           lcm2ssm_rd =1'b0;
           
           #CYCLE
           lcm2ssm_rd =1'b1;
           lcm2ssm_addr =11'd256;
          */



          //  finish
          


           //                               #CYCLE
           //                               lcm2ssm_reset =1'b1;


            
           //again  456
           //   again 4 packet
         #CYCLE
          
          lcm2ssm_rd =1'b1;            //read 2
          lcm2ssm_addr =11'd128;

          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          //lcm2ssm_rd =1'b0;
          //lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010000, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};
          lcm2ssm_rd =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};
         

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};
          lcm2ssm_rd =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b100000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;



        //  again 5 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010001, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b010001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b100001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;
      
           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //  again 6 packet  error packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010010, 8'b0000_0001, 12'h000, 12'h0e0, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          
          //
          #CYCLE
          dmux2ssm_data = {6'b010010, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          
          #CYCLE
          dmux2ssm_data = {6'b110010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_1000};

          #CYCLE
          dmux2ssm_data = {6'b100010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          

          //789
           //  7 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010011, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b100011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */


        //   8 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010100, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b100100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

          /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   9 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010101, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b110101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b100101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */


          // 10  11  12
           //   10 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010110, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b100110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

          /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */



        //  11 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010111, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b100111, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   12 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010101, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b111000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b101000, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //  13  14  15
           //   13 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011001, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b101001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */


/*
          #CYCLE
           lcm2ssm_rd =1'b1;
           lcm2ssm_addr =11'd896;
*/

        //   14 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          lcm2ssm_rd =1'b1;     // read 8
          lcm2ssm_addr =11'd896;

          dmux2ssm_data = {6'b011010, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};
          lcm2ssm_rd =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b101010, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   15 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011011, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b111011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b101011, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

          /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

            
          //  16  17  18
           //   16 packet
  
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011100, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b101100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */



        //   17 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011101, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b101101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   18 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011110, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b101110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          
           //  19  20  21
             //   19 packet

         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1111;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011100, 8'b0000_0001, 12'h000, 12'h060, 48'h0000_0000_0000, 48'h0000_0000_0001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b101100, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */



        //   20 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1110;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011101, 8'b0000_0001, 12'h000, 12'h070, 48'h0000_0000_0000, 48'h0000_0000_1000};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b101101, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */

          //   21 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b011110, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b111110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b101110, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */
        
         //   22 packet
         #CYCLE
          lcm2ssm_reset =1'b0;
          lcm2ssm_time =64'h0000_0000_0000_1100;
          lcm2ssm_rd =1'b0;
          lcm2ssm_addr =11'b0;

          dmux2ssm_data = {6'b010001, 8'b0000_0001, 12'h000, 12'h080, 48'h0000_0000_0000, 48'h0000_0000_1001};
          dmux2ssm_data_wr =1'b1;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0;

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0010};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0011};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0100};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0101};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0110};

          #CYCLE
          dmux2ssm_data = {6'b110001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};

          #CYCLE
          dmux2ssm_data = {6'b100001, 8'b0000_0001, 12'h000, 12'h000, 48'h0000_0000_0000, 48'h0000_0000_0111};
          dmux2ssm_valid =1'b1;
          dmux2ssm_valid_wr =1'b1;

           /*
          #CYCLE
          dmux2ssm_data = 134'b0;
          dmux2ssm_data_wr =1'b0;
          dmux2ssm_valid =1'b0;
          dmux2ssm_valid_wr =1'b0; 
          */


          #CYCLE
           lcm2ssm_reset =1'b1;

           #CYCLE
           #CYCLE
           lcm2ssm_reset =1'b0;
          


          #(100*CYCLE);
          $finish;
       end 


       always begin
       #(CYCLE/2) clk = ~clk;
       end

endmodule