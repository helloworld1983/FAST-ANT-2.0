/////////////////////////////////////////////////////////////////
// MIT License
//*************************************************************
//                     Basic Information
//*************************************************************
//Vendor: NUDT
//FAST URL://www.fastswitch.org 
//Target Device: Xilinx/Intel
//Filename: pgm_rd_schedule.v
//Version: 1.0
//Author : FAST Group
//*************************************************************
//                     Module Description
//*************************************************************
// 1)pgm_rd_schedule: pool;
//          
//*************************************************************
//                     Revision List
//*************************************************************
//      date:  2019/06/21
//      modifier: 
//      description: 
///////////////////////////////////////////////////////////////// 
`timescale 1ns / 1ps
module pgm_rd_schedule #(
	parameter    PLATFORM = "xilinx"
)(
input wire   clk,
input wire   rst_n,

//from/to lcm 
input wire          pgm_config_reset,
input wire          sent_start,
output reg          sent_finish,    
input wire          sent_model, 
output reg [63:0]   sent_time_cnt, 
input wire [63:0]   sent_time_reg,
output reg [63:0]   sent_num_cnt, 
input wire [63:0]   sent_num_reg,

//from pgm_ram
input wire [133:0]  ram2rd_data,

//from pgm_wr   
input wire          table_entry_flag,
input wire [137:0]  table_entry_data,

//transmit to pkt_send
output reg          sent_pkt_rd,
output reg [9:0]    sent_pkt_addr


);

//************************************************************
//                           poll
//************************************************************
reg [2:0]    sch_entry_cnt;
reg [137:0]  reg_entry_0_data;
reg [137:0]  reg_entry_1_data;
reg [137:0]  reg_entry_2_data;
reg [137:0]  reg_entry_3_data;

reg [2:0]    poll_cnt;
reg [2:0] sch_rd_state;
localparam IDLE_S = 3'd0,
           POLL_TIME_S = 3'd1,
		   POLL_CNT_S = 3'd2,
		   SENT_PKT_S = 3'd3,
		   CLEAR_S = 3'd4;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    reg_entry_0_data <= 138'b0;
		reg_entry_1_data <= 138'b0;
		reg_entry_2_data <= 138'b0;
		reg_entry_3_data <= 138'b0;	
		
		sent_pkt_rd <= 1'b0;
		sent_pkt_addr <= 10'd0;
		
		sent_num_cnt <= 64'd0;
		sent_time_cnt <= 64'd0;
		
		sch_entry_cnt <= 3'd0;
		poll_cnt <= 3'd0;
		
		sent_finish <= 1'b0;
		
		sch_rd_state <= IDLE_S;
	end
	else begin
	    case(sch_rd_state)
		    IDLE_S:begin		        
		        sent_pkt_rd <= 1'b0;
		        sent_pkt_addr <= 10'd0;
			    poll_cnt <= 3'd0;
			    
			    sent_num_cnt <= sent_num_cnt;
			    /*****configured parameters of four streams*****/
	            if(table_entry_flag == 1'b1)begin
			    	if(sch_entry_cnt == 3'd0)begin
	                    reg_entry_0_data <= table_entry_data;
			    		sch_entry_cnt <= sch_entry_cnt + 3'd1;
		            end
		            else if(sch_entry_cnt == 3'd1)begin
		            	reg_entry_1_data <= table_entry_data;
			    		sch_entry_cnt <= sch_entry_cnt + 3'd1;
		            end
		            else if(sch_entry_cnt == 3'd2)begin
		            	reg_entry_2_data <= table_entry_data;
			    		sch_entry_cnt <= sch_entry_cnt + 3'd1;
		            end
		            else if(sch_entry_cnt == 3'd3)begin
		            	reg_entry_3_data <= table_entry_data;
			    		sch_entry_cnt <= sch_entry_cnt + 3'd1;
		            end
                    else begin
			    	    sch_entry_cnt <= sch_entry_cnt;
                        reg_entry_0_data <= reg_entry_0_data;
			    		reg_entry_1_data <= reg_entry_1_data;
			    		reg_entry_2_data <= reg_entry_2_data;
			    		reg_entry_3_data <= reg_entry_3_data;
                    end	
                end			
	            else begin
			        sch_entry_cnt <= sch_entry_cnt;
                    reg_entry_0_data <= reg_entry_0_data;
			    	reg_entry_1_data <= reg_entry_1_data;
			    	reg_entry_2_data <= reg_entry_2_data;
			    	reg_entry_3_data <= reg_entry_3_data;
		        end
		        
			    
			    /***********start and model***********/
			    if(sent_start == 1'b1 && sch_entry_cnt == 3'd4 && sent_finish == 1'b0)begin
			        //sent_time_cnt <= sent_time_cnt + 64'd1;
			    	if(sent_model == 1'b0)begin    //sent_time
			    	    sch_rd_state <= POLL_TIME_S;
			    	end
			    	else begin
			    		sch_rd_state <= POLL_CNT_S; //sent_cnt
			    	end
			    end
			    else begin  
			        if(pgm_config_reset == 1'b1)begin
			        	sch_rd_state <= CLEAR_S;
			        end
			        else begin
			            sch_rd_state <= IDLE_S;
			        end
			    end
		    end
		    POLL_TIME_S:begin
		        if(sent_time_cnt < sent_time_reg)begin
		            sent_time_cnt <= sent_time_cnt + 64'd1;
		    	    case(poll_cnt)
		    	        3'd0:begin
		    	            if(sent_time_cnt >= reg_entry_0_data[137:74])begin
                                reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	            	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		                        sent_pkt_addr <= reg_entry_0_data[9:0];
		                        sent_pkt_rd <= 1'b1;
		                        sch_rd_state <= SENT_PKT_S;
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg   
                                poll_cnt <= poll_cnt + 3'd1;
                                sch_rd_state <= POLL_TIME_S; 	    
		    	            end
		    	        end

		    	        3'd1:begin
		    	            if(sent_time_cnt >= reg_entry_1_data[137:74])begin
                                reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	            	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		                        sent_pkt_addr <= reg_entry_1_data[9:0];
		                        sent_pkt_rd <= 1'b1;
		                        sch_rd_state <= SENT_PKT_S;
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg  
                                poll_cnt <= poll_cnt + 3'd1;
                                sch_rd_state <= POLL_TIME_S;   	    
		    	            end
		    	        end	
		    	        
		    	        3'd2:begin
		    	            if(sent_time_cnt >= reg_entry_2_data[137:74])begin
                                reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	            	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];
		                        sent_pkt_addr <= reg_entry_2_data[9:0];
		                        sent_pkt_rd <= 1'b1;
		                        sch_rd_state <= SENT_PKT_S;
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg
                                poll_cnt <= poll_cnt + 3'd1;
                                sch_rd_state <= POLL_TIME_S;                                    	    
		    	            end
		    	        end	
		    	       
		    	        3'd3:begin
		    	            if(sent_time_cnt >= reg_entry_3_data[137:74])begin
                                reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	            	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		                        sent_pkt_addr <= reg_entry_3_data[9:0];
		                        sent_pkt_rd <= 1'b1;
		                        sch_rd_state <= SENT_PKT_S;
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg    
                                poll_cnt <= 3'd0;
                                sch_rd_state <= POLL_TIME_S;                                  	    
		    	            end
		    	        end 
		    	        default:begin
		    	            sent_pkt_rd <= 1'b0;   
                            poll_cnt <= 3'd0;
                            sch_rd_state <= POLL_TIME_S;  
		    	        end   	            
		    	    endcase
		    	end
		        else begin
		    	    sent_finish <= 1'b1;
		    		sent_pkt_rd <= 1'b0;
		    	    sent_pkt_addr <= 10'd0;	
		    	    poll_cnt <= 3'd0;	
		    		sch_rd_state <= IDLE_S;			
		    	end
		    end
		    POLL_CNT_S:begin
		        sent_time_cnt <= sent_time_cnt + 64'd1;
		    	if(sent_num_cnt < sent_num_reg)begin
		    	    case(poll_cnt)
		    	        3'd0:begin
		    	            if(sent_time_cnt >= reg_entry_0_data[137:74])begin
                                reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	            	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		    	            	sent_pkt_addr <= reg_entry_0_data[9:0];
		    	            	sent_pkt_rd <= 1'b1;
		    		        	sent_num_cnt <= sent_num_cnt + 64'd1;
		    		        	sch_rd_state <= SENT_PKT_S;
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg    
                                poll_cnt <= poll_cnt + 3'd1;
                                sch_rd_state <= POLL_CNT_S;    	    
		    	            end
		    	        end
		    	        
		    	        3'd1:begin
		    	            if(sent_time_cnt >= reg_entry_1_data[137:74])begin
                                reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	            	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		    	            	sent_pkt_addr <= reg_entry_1_data[9:0];
		    	            	sent_pkt_rd <= 1'b1;
                                sent_num_cnt <= sent_num_cnt + 64'd1;	
                                sch_rd_state <= SENT_PKT_S;				
		    	            end
		    	            else begin
                                sent_pkt_rd <= 1'b0;  //not updata reg    
                                poll_cnt <= poll_cnt + 3'd1;
                                sch_rd_state <= POLL_CNT_S;   	    
		    	            end
		    	        end
		    	        
		    	    3'd2:begin
		    	        if(sent_time_cnt >= reg_entry_2_data[137:74])begin
                            reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	        	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];
		    	        	sent_pkt_addr <= reg_entry_2_data[9:0];	
		    	        	sent_pkt_rd <= 1'b1;
		    		    	sent_num_cnt <= sent_num_cnt + 64'd1;
		    		    	sch_rd_state <= SENT_PKT_S;
		    	        end
		    	        else begin
                            sent_pkt_rd <= 1'b0;  //not updata reg    
                            poll_cnt <= poll_cnt + 3'd1;
                            sch_rd_state <= POLL_CNT_S;   	    
		    	        end
		    	   end
		    	   
		    	   3'd3:begin     		    	    
		    	        if(sent_time_cnt >= reg_entry_3_data[137:74])begin
                            reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	        	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		    	        	sent_pkt_addr <= reg_entry_3_data[9:0];
		    	        	sent_pkt_rd <= 1'b1;
                            sent_num_cnt <= sent_num_cnt + 64'd1;
                            sch_rd_state <= SENT_PKT_S;					
		    	        end
		    	        else begin
                            sent_pkt_rd <= 1'b0;  //not updata reg    
                            poll_cnt <= 3'd0;
                            sch_rd_state <= POLL_CNT_S;   	    	    
		    	        end
		    	    end
		    	    default:begin
		    	        sent_pkt_rd <= 1'b0;   
                        poll_cnt <= 3'd0;
                        sch_rd_state <= POLL_CNT_S;  
		    	    end
		    	    endcase
		        end
		        else begin
		    	    sent_finish <= 1'b1;
		    		sent_pkt_rd <= 1'b0;
		    		sent_pkt_addr <= 10'b0;
		    		poll_cnt <= 3'd0;
		    		sch_rd_state <= IDLE_S;			
		    	end	    
		    end
		    SENT_PKT_S:begin
		        sent_time_cnt <= sent_time_cnt + 64'd1;
		        sent_pkt_rd <= 1'b0;
		        if(ram2rd_data[133:132] == 2'b10)begin
		            if(sent_model == 1'b0)begin
		                sch_rd_state <= POLL_TIME_S;
		            end
		            else begin
		                sch_rd_state <= POLL_CNT_S;
		            end	
		            	
		            if(poll_cnt == 3'd3)begin
		                poll_cnt <= 3'd0;
		            end
		            else begin
		                poll_cnt <= poll_cnt + 3'd1;
		            end
		        end
		        else begin
		            sch_rd_state <= SENT_PKT_S;		
		        end
		    end
            CLEAR_S:begin
                sent_num_cnt <= 64'd0;
		    	sent_time_cnt <= 64'd0;
		    	sch_entry_cnt <= 3'd0;
		    	sent_finish <= 1'b0;
		    	sch_rd_state <= IDLE_S;	
            end	
        endcase			
	end
end

endmodule


/*
//************************************************************
//                           poll
//************************************************************
reg [2:0]    entry_cnt;
reg [137:0]  reg_entry_0_data;
reg [137:0]  reg_entry_1_data;
reg [137:0]  reg_entry_2_data;
reg [137:0]  reg_entry_3_data;

reg [2:0] sch_rd_state;
localparam IDLE_S = 3'd0,
           POLL_TIME_S = 3'd1,
		   POLL_CNT_S = 3'd2,
		   CLEAR_S = 3'd3;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    reg_entry_0_data <= 138'b0;
		reg_entry_1_data <= 138'b0;
		reg_entry_2_data <= 138'b0;
		reg_entry_3_data <= 138'b0;	
		
		sent_pkt_rd <= 1'b0;
		sent_pkt_addr <= 10'd0;
		
		sent_num_cnt <= 64'd0;
		sent_time_cnt <= 64'd0;
		
		entry_cnt <= 3'd0;
		
		sent_finish <= 1'b0;
		
		sch_rd_state <= IDLE_S;
	end
	else begin
	    case(sch_rd_state)
		    IDLE_S:begin
		        sent_pkt_rd <= 1'b0;
		        sent_pkt_addr <= 10'd0;
			    
			    sent_num_cnt <= sent_num_cnt;
			    sent_time_cnt <= sent_time_cnt + 64'd1;
			    /*****configured parameters of four streams*****/
/*	            if(table_entry_flag == 1'b1)begin
			    	if(entry_cnt == 3'd0)begin
	                    reg_entry_0_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd1)begin
		            	reg_entry_1_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd2)begin
		            	reg_entry_2_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd3)begin
		            	reg_entry_3_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
                    else begin
			    	    entry_cnt <= entry_cnt;
                        reg_entry_0_data <= reg_entry_0_data;
			    		reg_entry_1_data <= reg_entry_1_data;
			    		reg_entry_2_data <= reg_entry_2_data;
			    		reg_entry_3_data <= reg_entry_3_data;
                    end	
                end			
	            else begin
			        entry_cnt <= entry_cnt;
                    reg_entry_0_data <= reg_entry_0_data;
			    	reg_entry_1_data <= reg_entry_1_data;
			    	reg_entry_2_data <= reg_entry_2_data;
			    	reg_entry_3_data <= reg_entry_3_data;
		        end
		        
			    
			    /***********start and model***********/
/*			    if(sent_start == 1'b1 && sent_finish == 1'b0)begin
			    	if(sent_model == 1'b0)begin    //sent_time
			    	    sch_rd_state <= POLL_TIME_S;
			    	end
			    	else begin
			    		sch_rd_state <= POLL_CNT_S; //sent_cnt
			    	end
			    end
			    else if(pgm_config_reset == 1'b1)begin
			    	sch_rd_state <= CLEAR_S;
			    end
			    else begin
			        sch_rd_state <= IDLE_S;
			    end
		    end
		    POLL_TIME_S:begin
		        sent_time_cnt <= sent_time_cnt + 64'd1;
		    	if(sent_time_cnt <= sent_time_reg)begin
		    	    sch_rd_state <= POLL_TIME_S;
		    	    if(sent_time_cnt == reg_entry_0_data[137:74])begin
                        reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	    	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_0_data[9:0];
		    	    end
		    	    else if(sent_time_cnt == reg_entry_1_data[137:74])begin
                        reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	    	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_1_data[9:0];				
		    	    end
		    	    else if(sent_time_cnt == reg_entry_2_data[137:74])begin
                        reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	    	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];	
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_2_data[9:0];
		    	    end
		    	    else if(sent_time_cnt == reg_entry_3_data[137:74])begin
                        reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	    	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_3_data[9:0];				
		    	    end
		    		else begin
		    	    	sent_pkt_rd <= 1'b0;
		    	    	sent_pkt_addr <= sent_pkt_addr;					
		    		end
		    	end
		        else begin
		    	    sent_finish <= 1'b1;
		    		sent_pkt_rd <= 1'b0;
		    	    sent_pkt_addr <= 10'd0;		
		    		sch_rd_state <= IDLE_S;			
		    	end
		    end
		    POLL_CNT_S:begin
		    	if(sent_num_cnt <= sent_num_reg)begin
		    	    sch_rd_state <= POLL_CNT_S;
		    	    if(sent_time_cnt == reg_entry_0_data[137:74])begin
                        reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	    	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_0_data[9:0];
		    			sent_num_cnt <= sent_num_cnt + 64'd1;
		    	    end
		    	    else if(sent_time_cnt == reg_entry_1_data[137:74])begin
                        reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	    	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_1_data[9:0];	
                        sent_num_cnt <= sent_num_cnt + 64'd1;					
		    	    end
		    	    else if(sent_time_cnt == reg_entry_2_data[137:74])begin
                        reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	    	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];	
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_2_data[9:0];
		    			sent_num_cnt <= sent_num_cnt + 64'd1;
		    	    end
		    	    else if(sent_time_cnt == reg_entry_3_data[137:74])begin
                        reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	    	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		    	    	sent_pkt_rd <= 1'b1;
		    	    	sent_pkt_addr <= reg_entry_3_data[9:0];	
                        sent_num_cnt <= sent_num_cnt + 64'd1;					
		    	    end
		    		else begin
		    	    	sent_pkt_rd <= 1'b0;
		    	    	sent_pkt_addr <= 10'd0;	
                        sent_num_cnt <= sent_num_cnt;					
		    		end
		    	end
		        else begin
		    	    sent_finish <= 1'b1;
		    		sent_pkt_rd <= 1'b0;
		    	    sent_pkt_addr <= 10'd0;		
		    		sch_rd_state <= IDLE_S;			
		    	end	    
		    end
            CLEAR_S:begin
                sent_num_cnt <= 64'd0;
		    	sent_time_cnt <= 64'd0;
		    	sch_rd_state <= IDLE_S;	
            end	
        endcase			
	end
end
*/





//************************************************************
//                           poll
//************************************************************
/*reg [2:0]    entry_cnt;
reg [3:0]    reg_pkt_rd;
reg [137:0]  reg_entry_0_data;
reg [137:0]  reg_entry_1_data;
reg [137:0]  reg_entry_2_data;
reg [137:0]  reg_entry_3_data;

reg [2:0] sch_rd_state;
localparam IDLE_S = 3'd0,
           POLL_TIME_S = 3'd1,
		   POLL_CNT_S = 3'd2,
		   CLEAR_S = 3'd3;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	    reg_entry_0_data <= 138'b0;
		reg_entry_1_data <= 138'b0;
		reg_entry_2_data <= 138'b0;
		reg_entry_3_data <= 138'b0;	
		reg_pkt_rd <= 4'b0;
		
		//sent_pkt_rd <= 1'b0;
		//sent_pkt_addr <= 10'd0;
		
		sent_num_cnt <= 64'd0;
		sent_time_cnt <= 64'd0;
		
		entry_cnt <= 3'd0;
		
		sent_finish <= 1'b0;
		
		sch_rd_state <= IDLE_S;
	end
	else begin
	    case(sch_rd_state)
		    IDLE_S:begin
		        reg_pkt_rd <= 4'b0;
		        
		        //sent_pkt_rd <= 1'b0;
		        //sent_pkt_addr <= 10'd0;
			    
			    sent_num_cnt <= sent_num_cnt;
			    sent_time_cnt <= sent_time_cnt + 64'd1;
			    /*****configured parameters of four streams*****/
/*	            if(table_entry_flag == 1'b1)begin
			    	if(entry_cnt == 3'd0)begin
	                    reg_entry_0_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd1)begin
		            	reg_entry_1_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd2)begin
		            	reg_entry_2_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
		            else if(entry_cnt == 3'd3)begin
		            	reg_entry_3_data <= table_entry_data;
			    		entry_cnt <= entry_cnt + 3'd1;
		            end
                    else begin
			    	    entry_cnt <= entry_cnt;
                        reg_entry_0_data <= reg_entry_0_data;
			    		reg_entry_1_data <= reg_entry_1_data;
			    		reg_entry_2_data <= reg_entry_2_data;
			    		reg_entry_3_data <= reg_entry_3_data;
                    end	
                end			
	            else begin
			        entry_cnt <= entry_cnt;
                    reg_entry_0_data <= reg_entry_0_data;
			    	reg_entry_1_data <= reg_entry_1_data;
			    	reg_entry_2_data <= reg_entry_2_data;
			    	reg_entry_3_data <= reg_entry_3_data;
		        end
		        
			    
			    /***********start and model***********/
/*			    if(sent_start == 1'b1 && sent_finish == 1'b0)begin
			    	if(sent_model == 1'b0)begin    //sent_time
			    	    sch_rd_state <= POLL_TIME_S;
			    	end
			    	else begin
			    		sch_rd_state <= POLL_CNT_S; //sent_cnt
			    	end
			    end
			    else if(pgm_config_reset == 1'b1)begin
			    	sch_rd_state <= CLEAR_S;
			    end
			    else begin
			        sch_rd_state <= IDLE_S;
			    end
		    end
		    POLL_TIME_S:begin
		        sent_time_cnt <= sent_time_cnt + 64'd1;
		    	if(sent_time_cnt < sent_time_reg)begin
		    	    sch_rd_state <= POLL_TIME_S;
		    	    if(sent_time_cnt == reg_entry_0_data[137:74])begin
                        reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	    	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		    	    	reg_pkt_rd[0] <= 1'b1;  
		    	    end
		    	    else begin
                        reg_entry_0_data <= reg_entry_0_data;  //not updata reg
		    	    	reg_pkt_rd[0] <= 1'b0;	    	    
		    	    end
		    	    
		    	    if(sent_time_cnt == reg_entry_1_data[137:74])begin
                        reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	    	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		    	    	reg_pkt_rd[1] <= 1'b1;		
		    	    end
		    	    else begin
                        reg_entry_1_data <= reg_entry_1_data;  //not updata reg
		    	    	reg_pkt_rd[1] <= 1'b0;			    	    
		    	    end
		    	    
		    	    if(sent_time_cnt == reg_entry_2_data[137:74])begin
                        reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	    	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];	
		    	    	reg_pkt_rd[2] <= 1'b1;
		    	    end
		    	    else begin
                        reg_entry_2_data <= reg_entry_2_data;  //not updata reg
		    	    	reg_pkt_rd[2] <= 1'b0;		    	    
		    	    end
		    	    
                    if(sent_time_cnt == reg_entry_3_data[137:74])begin
                        reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	    	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		    	    	reg_pkt_rd[3] <= 1'b1;		
		    	    end
		    	    else begin
                        reg_entry_3_data <= reg_entry_3_data;  //not updata reg
		    	    	reg_pkt_rd[3] <= 1'b0;			    	    
		    	    end
		    	end
		        else begin
		    	    sent_finish <= 1'b1;
		    		reg_pkt_rd <= 4'b0;
		    	   // sent_pkt_addr <= 10'd0;		
		    		sch_rd_state <= IDLE_S;			
		    	end
		    end
		    POLL_CNT_S:begin
		        sent_time_cnt <= sent_time_cnt + 64'd1;
		    	if(sent_num_cnt < sent_num_reg)begin
		    	    sch_rd_state <= POLL_CNT_S;
		    	    if(sent_time_cnt >= reg_entry_0_data[137:74])begin
                        reg_entry_0_data[137:74] <= reg_entry_0_data[137:74] + reg_entry_0_data[73:10];  //updata reg
		    	    	reg_entry_0_data[73:0] <= reg_entry_0_data[73:0];
		    	    	reg_pkt_rd[0] <= 1'b1;
		    			sent_num_cnt <= sent_num_cnt + 64'd1;
		    	    end
		    	    else begin
                        reg_entry_0_data <= reg_entry_0_data;  //not updata reg
		    	    	reg_pkt_rd[0] <= 1'b0;    	    
		    	    end
		    	    
		    	    if(sent_time_cnt >= reg_entry_1_data[137:74])begin
                        reg_entry_1_data[137:74] <= reg_entry_1_data[137:74] + reg_entry_1_data[73:10];  //updata reg
		    	    	reg_entry_1_data[73:0] <= reg_entry_1_data[73:0];
		    	    	reg_pkt_rd[1] <= 1'b1;
                        sent_num_cnt <= sent_num_cnt + 64'd1;					
		    	    end
		    	    else begin
                        reg_entry_1_data <= reg_entry_1_data;  //not updata reg
		    	    	reg_pkt_rd[1] <= 1'b0;    	    
		    	    end
		    	    
		    	    if(sent_time_cnt >= reg_entry_2_data[137:74])begin
                        reg_entry_2_data[137:74] <= reg_entry_2_data[137:74] + reg_entry_2_data[73:10];  //updata reg
		    	    	reg_entry_2_data[73:0] <= reg_entry_2_data[73:0];	
		    	    	reg_pkt_rd[2] <= 1'b1;
		    			sent_num_cnt <= sent_num_cnt + 64'd1;
		    	    end
		    	    else begin
                        reg_entry_2_data <= reg_entry_2_data;  //not updata reg
		    	    	reg_pkt_rd[2] <= 1'b0;    	    
		    	    end
		    	    		    	    
		    	    if(sent_time_cnt >= reg_entry_3_data[137:74])begin
                        reg_entry_3_data[137:74] <= reg_entry_3_data[137:74] + reg_entry_3_data[73:10];  //updata reg
		    	    	reg_entry_3_data[73:0] <= reg_entry_3_data[73:0];
		    	    	reg_pkt_rd[3] <= 1'b1;
                        sent_num_cnt <= sent_num_cnt + 64'd1;					
		    	    end
		    	    else begin
                        reg_entry_3_data <= reg_entry_3_data;  //not updata reg
		    	    	reg_pkt_rd[3] <= 1'b0;    	    
		    	    end
		    	end
		        else begin
		    	    sent_finish <= 1'b1;
		    		reg_pkt_rd <= 4'b0;
		    		sch_rd_state <= IDLE_S;			
		    	end	    
		    end
            CLEAR_S:begin
                sent_num_cnt <= 64'd0;
		    	sent_time_cnt <= 64'd0;
		    	sch_rd_state <= IDLE_S;	
            end	
        endcase			
	end
end
*/