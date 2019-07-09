/////////////////////////////////////////////////////////////////
// MIT License
//*************************************************************
//                     Basic Information
//*************************************************************
//Vendor: NUDT
//FAST URL://www.fastswitch.org 
//Target Device: Xilinx/Intel
//Filename: pgm_rd_pkt_send.v
//Version: 1.0
//Author : FAST Group
//*************************************************************
//                     Module Description
//*************************************************************
// 1)pgm_rd_pkt_send: generate sub-stream;
//          
//*************************************************************
//                     Revision List
//*************************************************************
//      date:  2019/06/21
//      modifier: 
//      description: 
///////////////////////////////////////////////////////////////// 
`timescale 1ns / 1ps
module pgm_rd_pkt_send #(
	parameter    PLATFORM = "xilinx"
)(
input wire   clk,
input wire   rst_n,

//from sch_rd
input wire [9:0]    sent_pkt_addr,
input wire          sent_pkt_rd,  

//from pgm_ram
input wire [133:0]  ram2rd_data, 

//from/to lcm 
input wire	         pgm_config_reset,
input wire [63:0]   lcm2pgm_time,  
output reg [63:0]   sent_pkt_0_cnt,
output reg [63:0]   sent_pkt_1_cnt,
output reg [63:0]   sent_pkt_2_cnt,
output reg [63:0]   sent_pkt_3_cnt,
output reg [63:0]   sent_bit_cnt,

//to pgm_ram
output reg          rd2ram_rd,
output reg [9:0]    rd2ram_addr,

//to FPGA OS
input wire          in_pgm_data_ready, 
output reg [133:0]  out_pgm_data,
output reg          out_pgm_data_wr, 
output reg          out_pgm_data_valid,
output reg          out_pgm_data_valid_wr

);

//************************************************************
//                    read from RAM
//************************************************************
reg [133:0] ram_rdata;
reg         ram_rdata_wr;
reg [2:0]   ram_read_state;
localparam R_IDLE_S = 3'd0,
           R_HAUNT1_S = 3'd1,
		   R_HAUNT2_S = 3'd2,
		   READ_S = 3'd3;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin		
		rd2ram_rd <= 1'b0;
		rd2ram_addr <= 10'b0;
		
	    ram_rdata <= 134'b0;
		ram_rdata_wr <= 1'b0; 
		ram_read_state <= R_IDLE_S;
	end
	else begin
	    case(ram_read_state)
		    R_IDLE_S:begin
	            ram_rdata <= 134'b0;
		        ram_rdata_wr <= 1'b0; 
	            if(sent_pkt_rd == 1'b1)begin
		    	    rd2ram_rd <= 1'b1;
	                rd2ram_addr <= sent_pkt_addr;
		    		ram_read_state <= R_HAUNT1_S;
		        end
		        else begin
		    	    rd2ram_rd <= 1'b0;
	                rd2ram_addr <= 10'b0;
		    		ram_read_state <= R_IDLE_S;
		        end
		    end
		    R_HAUNT1_S:begin
		    	rd2ram_rd <= 1'b1;
	            rd2ram_addr <= rd2ram_addr + 10'd1;
		    	ram_read_state <= R_HAUNT2_S;
		    end
		    R_HAUNT2_S:begin
		    	rd2ram_rd <= 1'b1;
	            rd2ram_addr <= rd2ram_addr + 10'd1;
		        ram_read_state <= READ_S;
		    end
		    READ_S:begin
		    	ram_rdata <= ram2rd_data; 
		    	if(ram2rd_data[133:132] == 2'b10)begin
		    	    rd2ram_rd <= 1'b0;
		    		rd2ram_addr <= 10'd0;
                    ram_rdata_wr <= 1'b1;
		    		ram_read_state <= R_IDLE_S;
                end
                else begin
		    	    rd2ram_rd <= 1'b1;
		    		rd2ram_addr <= rd2ram_addr + 10'd1;
                    ram_rdata_wr <= 1'b1;
		    		ram_read_state <= READ_S;
                end			
		    end	
	    endcase
	end
end
//************************************************************
//                    generate sub-stream
//************************************************************
reg [6:0] cycle_cnt;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin	
        cycle_cnt <= 7'd0;	
	    out_pgm_data <= 134'b0;
		out_pgm_data_wr <= 1'b0; 
		out_pgm_data_valid <= 1'b0;
		out_pgm_data_valid_wr <= 1'b0;
	end
	else begin
		if(ram_rdata_wr == 1'b1)begin
		    if(ram_rdata[133:132] == 2'b10 && cycle_cnt != 7'd5)begin
			    out_pgm_data <= ram_rdata;
		        out_pgm_data_wr <= 1'b1;
		        out_pgm_data_valid <= 1'b1;
		    	out_pgm_data_valid_wr <= 1'b1;
		        cycle_cnt <= 7'd0;
		    end
		    else if(ram_rdata[133:132] == 2'b10 && cycle_cnt == 7'd5)begin
			    out_pgm_data[133:128] <= ram_rdata[133:128];
			    out_pgm_data[127:64] <= lcm2pgm_time;
			    out_pgm_data[63:0] <= ram_rdata[63:0];
		        out_pgm_data_wr <= 1'b1;
		        out_pgm_data_valid <= 1'b1;
		    	out_pgm_data_valid_wr <= 1'b1;
		        cycle_cnt <= 7'd0;
		    end
		    else begin
		        out_pgm_data_wr <= 1'b1;
		        out_pgm_data_valid <= 1'b0;
		    	out_pgm_data_valid_wr <= 1'b0;
		        cycle_cnt <= cycle_cnt + 7'd1;
		        if(cycle_cnt == 7'd3 && sent_pkt_addr == 10'd0)begin    //stream 0;modify src ip
		            out_pgm_data[133:48] <= ram_rdata[133:48];
	                out_pgm_data[47:16] <= ram_rdata[47:16] + sent_pkt_0_cnt;
		            out_pgm_data[15:0] <= ram_rdata[15:0];
		        end
		        else if(cycle_cnt == 7'd4 && sent_pkt_addr == 10'd128)begin  //stream 1;modify dst ip
		            out_pgm_data[133:128] <= ram_rdata[133:128];
	                out_pgm_data[127:112] <= ram_rdata[127:112] + sent_pkt_1_cnt;
		            out_pgm_data[111:0] <= ram_rdata[111:0];				
		        end			
		        else if(cycle_cnt == 7'd4 && sent_pkt_addr == 10'd256)begin  //stream 2;modify source port
		            out_pgm_data[133:112] <= ram_rdata[133:112];
	                out_pgm_data[111:96] <= ram_rdata[111:96] + sent_pkt_2_cnt;
	                out_pgm_data[95:0] <= ram_rdata[95:0];   					
	            end
	            else if(cycle_cnt == 7'd4 && sent_pkt_addr == 10'd384)begin  //stream 3;modify source port
	                out_pgm_data[133:96] <= ram_rdata[133:96];
	                out_pgm_data[95:80] <= ram_rdata[95:80] + sent_pkt_3_cnt;
	                out_pgm_data[79:0] <= ram_rdata[79:0];
                    end
	            else if(cycle_cnt == 7'd5)begin  //add timestamp
			        out_pgm_data[133:128] <= ram_rdata[133:128];
			        out_pgm_data[127:64] <= lcm2pgm_time;
			        out_pgm_data[63:0] <= ram_rdata[63:0];
                    end
	            else begin
	        	    out_pgm_data <= ram_rdata;
	            end										
	        end
	    end
	    else begin
	    	out_pgm_data <= 134'b0;
	        out_pgm_data_wr <= 1'b0;
	        out_pgm_data_valid <= 1'b0;
	    	out_pgm_data_valid_wr <= 1'b0;
	        cycle_cnt <= 7'd0;					
	    end
    end		
end
//************************************************************
//                        cnt
//************************************************************
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    sent_pkt_0_cnt <= 64'd0;
		sent_pkt_1_cnt <= 64'd0;
		sent_pkt_2_cnt <= 64'd0;
		sent_pkt_3_cnt <= 64'd0;	
		sent_bit_cnt <= 64'd0;
	end
	else begin
	    /***********pkt_cnt and bit_cnt***********/
	    if(pgm_config_reset == 1'b0)begin
	        if(out_pgm_data_wr <= 1'b1 && out_pgm_data[133:132] == 2'b01)begin
	            sent_bit_cnt <= sent_bit_cnt + ({52'b0,out_pgm_data[107:96]} << 64'd3);
		        if(sent_pkt_addr == 10'd0)begin
			        sent_pkt_0_cnt <= sent_pkt_0_cnt + 64'd1;
			    end
			    else if(sent_pkt_addr == 10'd128)begin
			        sent_pkt_1_cnt <= sent_pkt_1_cnt + 64'd1;
			    end
			    else if(sent_pkt_addr == 10'd256)begin
			        sent_pkt_2_cnt <= sent_pkt_2_cnt + 64'd1;
			    end
			    else if(sent_pkt_addr == 10'd384)begin
			        sent_pkt_3_cnt <= sent_pkt_3_cnt + 64'd1;
			    end
			    else begin
			        sent_pkt_0_cnt <= sent_pkt_0_cnt;
				    sent_pkt_1_cnt <= sent_pkt_1_cnt;
				    sent_pkt_2_cnt <= sent_pkt_2_cnt;
				    sent_pkt_3_cnt <= sent_pkt_3_cnt;
			    end			
		    end
		    else begin
		        sent_bit_cnt <= sent_bit_cnt;
		        sent_pkt_0_cnt <= sent_pkt_0_cnt;
			    sent_pkt_1_cnt <= sent_pkt_1_cnt;
			    sent_pkt_2_cnt <= sent_pkt_2_cnt;
			    sent_pkt_3_cnt <= sent_pkt_3_cnt;	    
		    end
		end
		else begin
		    sent_pkt_0_cnt <= 64'd0;		
            sent_pkt_1_cnt <= 64'd0;		
            sent_pkt_2_cnt <= 64'd0;		
            sent_pkt_3_cnt <= 64'd0;		
            sent_bit_cnt <= 64'd0;
		end		
	end
end
endmodule
