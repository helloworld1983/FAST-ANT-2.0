/////////////////////////////////////////////////////////////////
// MIT License
//*************************************************************
//                     Basic Information
//*************************************************************
//Vendor: NUDT
//FAST URL://www.fastswitch.org 
//Target Device: Xilinx/Intel
//Filename: pgm_wr.v
//Version: 1.0
//Author : FAST Group
//*************************************************************
//                     Module Description
//*************************************************************
// 1)pgm_wr: transmit schedule table entries to PGM_RD;
//           transmit PKT to PGM_RAM.
//*************************************************************
//                     Revision List
//*************************************************************
//      date:  2019/06/21
//      modifier: 
//      description: 
///////////////////////////////////////////////////////////////// 
`timescale 1ns / 1ps
module pgm_wr #(
	parameter    PLATFORM = "xilinx"
)(
input	wire	     clk,
input	wire	     rst_n,
                     
//receive from DMUX  
input	wire [133:0] in_pgm_data,
input	wire	      in_pgm_data_wr,
output  wire          out_pgm_data_ready,
                     
//receive from LCM   
input	wire	     pgm_config_reset,
input	wire     	 table_entry_wr,
input	wire [63:0]  sent_start_time_reg,
input	wire [63:0]  sent_rate_reg,
                     
//receive from PGM_RD  
input	wire         in_pgm_wr_raddr_wr,
input	wire [9:0]   in_pgm_wr_raddr,
                     
//transmit to PGM_RD 
output	reg          table_entry_flag,
output	reg [137:0]  table_entry_data,
   
//output	reg          out_pgm_wr_data_wr,
output	wire [133:0]  out_pgm_wr_data,

//successfully configure four streams
output reg      sent_ready 


);
assign    out_pgm_data_ready = 1'b1;
//************************************************************
//                  four table entries
//************************************************************
reg [9:0] wr_entry_cnt;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		table_entry_flag <= 1'b0;
        table_entry_data <= 138'b0;
		wr_entry_cnt <= 10'd0;
	end
	else begin
	    if(pgm_config_reset == 1'b0)begin
		    if(table_entry_wr == 1'b1)begin
		        wr_entry_cnt <= wr_entry_cnt + 10'd1;
		        table_entry_flag <= 1'b1;
		    	table_entry_data <= {sent_start_time_reg,sent_rate_reg,wr_entry_cnt << 10'd7};
            end
            else begin
		        wr_entry_cnt <= wr_entry_cnt;
		        table_entry_flag <= 1'b0;
		    	table_entry_data <= 138'b0;
            end
         /*   if(table_entry_wr == 1'b1)begin
                wr_entry_cnt <= wr_entry_cnt + 10'd1;
                if(wr_entry_cnt == 10'd0 || wr_entry_cnt == 10'd2 || wr_entry_cnt == 10'd4 || wr_entry_cnt == 10'd6)begin
                    table_entry_flag <= 1'b0;
		    	    table_entry_data[137:74] <= sent_start_time_reg;
		    	    table_entry_data[73:0] <= table_entry_data[73:0];
                end
                else if(wr_entry_cnt == 10'd1)begin
                    table_entry_flag <= 1'b1;
		    	    table_entry_data[137:74] <= table_entry_data[137:74];
		    	    table_entry_data[73:0] <= {sent_rate_reg,10'd0};
                end
                else if(wr_entry_cnt == 10'd3)begin
                    table_entry_flag <= 1'b1;
		    	    table_entry_data[137:74] <= table_entry_data[137:74];
		    	    table_entry_data[73:0] <= {sent_rate_reg,10'd1};
                end
                else if(wr_entry_cnt == 10'd5)begin
                    table_entry_flag <= 1'b1;
		    	    table_entry_data[137:74] <= table_entry_data[137:74];
		    	    table_entry_data[73:0] <= {sent_rate_reg,10'd2};
		    	end
                else if(wr_entry_cnt == 10'd7)begin
                    table_entry_flag <= 1'b1;
		    	    table_entry_data[137:74] <= table_entry_data[137:74];
		    	    table_entry_data[73:0] <= {sent_rate_reg,10'd3};
                end
                else begin
                    table_entry_flag <= 1'b0;
                end
            end
            else begin
                table_entry_flag <= 1'b0;
                table_entry_data <= table_entry_data;
            end
            */
        end
        else begin
            wr_entry_cnt <= 10'd0;
        end		
	end
end

//************************************************************
//                  write to RAM
//************************************************************
reg [9:0]    ram_waddr;
reg          ram_wr;
reg [133:0]  ram_wdata;

reg [9:0] pkt_cnt;
reg [1:0] pgm_wr_state;
localparam W_IDLE_S = 2'd0,
		   W_STORE_S = 2'd1;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
        ram_wr <= 1'b0;
		ram_waddr <= 10'b0;
		ram_wdata <= 134'b0;
        pkt_cnt <= 10'd0;
        pgm_wr_state <= W_IDLE_S;		
	end
	else begin
		case(pgm_wr_state)
		    W_IDLE_S:begin
			    if(pgm_config_reset == 1'b0)begin
			        if(in_pgm_data_wr == 1'b1 && in_pgm_data[133:132] == 2'b01)begin
					    ram_waddr <= (pkt_cnt << 10'd7);
				    	ram_wr <= 1'b1;
				    	ram_wdata <= in_pgm_data; 
				    	pkt_cnt <= pkt_cnt + 10'd1;
				        pgm_wr_state <= W_STORE_S;	
				    end
				    else begin
				    	ram_waddr <= 10'b0;					
				    	ram_wr <= 1'b0;
				    	ram_wdata <= 134'b0;
				    	pkt_cnt <= pkt_cnt;
				    	pgm_wr_state <= W_IDLE_S;		
				    end
				end
				else begin
				    pkt_cnt <= 10'd0;
					ram_waddr <= 10'b0;
					ram_wr <= 1'b0;
					ram_wdata <= 134'b0;
					pgm_wr_state <= W_IDLE_S;		
				end
			end
		    W_STORE_S:begin
			    if(in_pgm_data_wr == 1'b1 && in_pgm_data[133:132] == 2'b10)begin
					ram_waddr <= ram_waddr + 10'd1;
					ram_wr <= 1'b1;
					ram_wdata <= in_pgm_data; 
				    pgm_wr_state <= W_IDLE_S;	
				end
				else begin
				    ram_waddr <= ram_waddr + 10'd1;
					ram_wr <= 1'b1;
					ram_wdata <= in_pgm_data; 
				    pgm_wr_state <= W_STORE_S;		
				end
			end
			default:begin
				ram_waddr <= 10'b0;
				ram_wr <= 1'b0;
				ram_wdata <= 134'b0;
				pkt_cnt <= pkt_cnt;
				pgm_wr_state <= W_IDLE_S;	
			end
		endcase
    end		
end
//************************************************************
//         whether configured streams is successful
//************************************************************
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
        sent_ready <= 1'b0;
	end
	else begin
	    if(pkt_cnt == 10'd4)begin
	        sent_ready <= 1'b1;	  
	    end
	    else begin
	        sent_ready <= 1'b0;
	    end
	end
end
ram_134_512 cache_streams
(      
    .clka(clk),
	.ena(ram_wr),
    .dina(ram_wdata),
    .wea(1'b1),
    .addra(ram_waddr[8:0]),	
    
    .clkb(clk),
	.enb(in_pgm_wr_raddr_wr),
    .addrb(in_pgm_wr_raddr[8:0]),
    .doutb(out_pgm_wr_data)    
);
endmodule
