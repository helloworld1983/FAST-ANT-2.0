`timescale 1ns / 1ps

`define   WITE            4              //å¸§é—´­v?
`define   INPORT          0             //inport
`define   SMID            0              //smid(128:from cpu     å…¶ä»–ï¼šfrom port)

module tb_um();
reg       clk;
reg       rst_n;

reg        pktin_data_valid;
reg        pktin_data_valid_wr;
reg[133:0] pktin_data;
reg        pktin_data_wr;
wire       pktin_ready;


initial begin//100Mhz
    clk = 1'b0;
    forever #4 clk = ~clk;
end

initial begin//reset
    rst_n = 1'b0;
    #100;
    rst_n = 1'b1;
end
//************************************************************
//                  tran to pgm
//************************************************************
task generator_yuyue_esw;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0]PCP; 
	reg         [2:0] priority;                     
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		
        PCP     <= 3'h4;
        priority <= 3'b000;  //tran to pgm
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h6e,SMID,8'h1,80'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
//		wait (pktin_ready == 1'b1);			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h8100,PCP,13'h1280};  
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd0,124'd0};          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////stream0
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
	       pktin_data <= {2'b11,4'b0000,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h0;
		   pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);
//            @(posedge clk); // data
//              pktin_data <= {2'b11,4'b0000,128'h1};   
//              pktin_data_wr <= 1'b1;           
//              pktin_data_valid  <= 1'h0;
//              pktin_data_valid_wr <= 1'b0;    		   
//		 @(posedge clk);//å¸§é—´­v?
//               repeat(81)begin
//                       pktin_data <= {2'b11,4'b0000,128'h1};  
//                       pktin_data_wr <= 1'b1;                    
//                       pktin_data_valid  <= 1'h0;
//                       pktin_data_valid_wr <= 1'b0;        
//               @(posedge clk);     
//               end          
      
           @(posedge clk); // data
                 pktin_data <= {2'b10,4'b0010,128'h0};   
                 pktin_data_wr <= 1'b1;           
                 pktin_data_valid  <= 1'h1;
                 pktin_data_valid_wr <= 1'b1;      
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
		   
	end
endtask
task generator_tsn_esw;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0]PCP; 
	reg         [2:0] priority;           
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		
        PCP     <= 3'h6;
        priority <= 3'b000;  //tran to pgm
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h6e,SMID,8'h1,80'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h8100,PCP,13'h1280};  
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd1,124'd0};      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////stream1
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b11,4'b0000,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h0;
		   pktin_data_valid_wr <= 1'b0;	

		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0010,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	 
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
task generator_best_esw;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0]PCP; 
	reg         [2:0] priority; 	                    
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		
        PCP     <= 3'h0;
        priority <= 3'b000;  //tran to pgm
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h6e,SMID,8'h1,80'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h8100,PCP,13'h1280};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd2,124'd0};      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////stream2
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b11,4'b0000,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h0;
		   pktin_data_valid_wr <= 1'b0;	

		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0010,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
task generator_ptp_esw;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	                    
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;

		priority <= 3'b000;  //tran to pgm
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h6e,SMID,8'h1,80'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      //////////////////////////////////////////////////////////////////////////////////////////////////////////////stream3  
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b11,4'b0000,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h0;
		   pktin_data_valid_wr <= 1'b0;	

		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0010,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask


//************************************************************
//                  tran to ssm
//************************************************************
task generator_pkt_ssm;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0]PCP; 
	reg         [2:0] priority;                     
	begin
		WITE    <= `WITE   ;
		//INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		INPORT  <= 6'd1 ;  //tran to ssm
        PCP     <= 3'h4;
        priority <= 3'b000;  //tran to pgm
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h6e,SMID,8'h1,80'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
//		wait (pktin_ready == 1'b1);			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h8100,PCP,13'h1280};  
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd0,124'd0};          //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////stream0
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
//		wait (pktin_ready == 1'b1);		   
		 @(posedge clk); // data
	       pktin_data <= {2'b11,4'b0000,128'h0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h0;
		   pktin_data_valid_wr <= 1'b0;	
//		wait (pktin_ready == 1'b1);
//            @(posedge clk); // data
//              pktin_data <= {2'b11,4'b0000,128'h1};   
//              pktin_data_wr <= 1'b1;           
//              pktin_data_valid  <= 1'h0;
//              pktin_data_valid_wr <= 1'b0;    		   
//		 @(posedge clk);//å¸§é—´­v?
//               repeat(81)begin
//                       pktin_data <= {2'b11,4'b0000,128'h1};  
//                       pktin_data_wr <= 1'b1;                    
//                       pktin_data_valid  <= 1'h0;
//                       pktin_data_valid_wr <= 1'b0;        
//               @(posedge clk);     
//               end          
      
           @(posedge clk); // data
                 pktin_data <= {2'b10,4'b0010,128'h0};   
                 pktin_data_wr <= 1'b1;           
                 pktin_data_valid  <= 1'h1;
                 pktin_data_valid_wr <= 1'b1;      
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
		   
	end
endtask
//************************************************************
//        tran to lcm (configure stream0 start_time)
//************************************************************
task generator_stream0_start_time;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		num <= 8'd6  ;
		reg_data <= 64'd0    ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to lcm (configure stream0 start_time)
//************************************************************
task generator_stream0_interval;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd101    ;
		num <= 8'd7  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure stream1 start_time)
//************************************************************
task generator_stream1_start_time;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd100    ;
		num <= 8'd6  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to lcm (configure stream1 start_time)
//************************************************************
task generator_stream1_interval;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd202    ;
		num <= 8'd7  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure stream2 start_time)
//************************************************************
task generator_stream2_start_time;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd200    ;
		num <= 8'd6  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to lcm (configure stream2 start_time)
//************************************************************
task generator_stream2_interval;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd303    ;
		num <= 8'd7  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure stream3 start_time)
//************************************************************
task generator_stream3_start_time;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd300    ;
		num <= 8'd6  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to lcm (configure stream3 start_time)
//************************************************************
task generator_stream3_interval;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd404    ;
		num <= 8'd7  ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure sent_model)
//************************************************************
task generator_sent_model;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd1    ;
		num <= 8'd9 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure sent_time_reg)
//************************************************************
task generator_sent_time_reg;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd1000_000    ;
		num <= 8'd10 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure sent_num_reg)
//************************************************************
task generator_sent_num_reg;
	reg         [7:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd100    ;
		num <= 8'd11 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        tran to lcm (configure sent_start)
//************************************************************
task generator_sent_start;
	reg         [63:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		//WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		WITE    <= 64'd5_000   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd1    ;
		num <= 8'd8 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask

//************************************************************
//        read reg from lcm
//************************************************************
task generator_rd_sent_bit_cnt;
	reg         [63:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		//WITE    <= `WITE;
		INPORT  <= `INPORT;
		SMID    <= `SMID;
	    wr_or_rd <= 1'b1;      //read reg
		priority <= 3'b111;  //tran to lcm
	//	reg_data <= 64'd100;
		num <= 8'd7;
		WITE    <= 64'd10;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,64'd0,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask


//************************************************************
//        tran to lcm (configure reset)
//************************************************************
task generator_config_reset;
	reg         [63:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		//WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		WITE    <= 64'd5_000   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd1;
		num <= 8'd5 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to mux_ssm_pkt 
//************************************************************
task generator_mux_ssm_pkt;
	reg         [63:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		//WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		WITE    <= 64'd5_000   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= 64'd1;
		num <= 8'd12 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask
//************************************************************
//        tran to lcm(read ssm pkt )
//************************************************************
task generator_read_ssm_pkt;
	reg         [63:0] WITE;   
	reg			[5:0] INPORT; 
	reg 		[7:0] SMID;   
	reg         [2:0] priority; 	
	reg         wr_or_rd; 
	reg         [63:0]reg_data; 
	reg         [7:0]num;                  
	begin
		//WITE    <= `WITE   ;
		INPORT  <= `INPORT ;
		SMID    <= `SMID   ;
		WITE    <= 64'd5_000   ;
	    wr_or_rd <= 1'b0;      //write reg
		priority <= 3'b111;  //tran to lcm
		reg_data <= {52'd0,1'd1,11'd128};
		num <= 8'd2 ;
		wait (pktin_ready == 1'b1);
		 @(posedge clk); //metadta0
			pktin_data <={2'b01,4'b0000,2'b00,INPORT,8'h0,priority,1'b0,12'h60,SMID,8'h1,31'h0,wr_or_rd,48'h0};
			pktin_data_wr <= 1'b1; 
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;
			
		 @(posedge clk); //metadta1
	        pktin_data <=  {2'b11,4'b0000,128'h0};
		    pktin_data_wr <= 1'b1; 
            pktin_data_valid  <= 1'h0;
		    pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,48'hffffffffffff,48'h000a35000001,16'h88f7,16'h4500};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,4'd3,124'd0};      
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;	
		   
		 @(posedge clk); // data
			pktin_data <= {2'b11,4'b0000,128'h0};   
			pktin_data_wr <= 1'b1;		   
			pktin_data_valid  <= 1'h0;
			pktin_data_valid_wr <= 1'b0;		
		   
		 @(posedge clk); // data
	       pktin_data <= {2'b10,4'b0000,num,reg_data,56'd0};   
		   pktin_data_wr <= 1'b1;		   
           pktin_data_valid  <= 1'h1;
		   pktin_data_valid_wr <= 1'b1;	
		   
		 @(posedge clk);//å¸§é—´­v?
           repeat(WITE)begin
                   pktin_data <= 134'h0;
                   pktin_data_wr <= 1'b0;                    
                   pktin_data_valid  <= 1'h0;
                   pktin_data_valid_wr <= 1'b0;        
           @(posedge clk);     
		   end
	end
endtask







initial begin
pktin_data <= 134'h0;
pktin_data_wr <= 1'b0;                    
pktin_data_valid  <= 1'h0;
pktin_data_valid_wr <= 1'b0;     
  wait (rst_n == 1'b1);
  /*repeat(100)*/ @(posedge clk);
  ////////////////////////////////////////4 streams///////////////////////////////////////////
repeat(1)begin
     generator_yuyue_esw();
end
repeat(1)begin
       generator_tsn_esw();
  end
repeat(1)begin
     generator_best_esw();
end    
repeat(1)begin
       generator_ptp_esw();
end  
 ////////////////////////////////////////4 Ê±¿Ìµ÷¶È±í///////////////////////////////////////////
repeat(1)begin
    generator_stream0_start_time();
end 
repeat(1)begin
    generator_stream0_interval();
end  
repeat(1)begin
    generator_stream1_start_time();
end 
repeat(1)begin
    generator_stream1_interval();
end 
repeat(1)begin
    generator_stream2_start_time();
end 
repeat(1)begin
    generator_stream2_interval();
end 
repeat(1)begin
    generator_stream3_start_time();
end 
repeat(1)begin
    generator_stream3_interval();
end 
////////////////////////////////////////////sent_time_reg////////////////////////////////////
repeat(1)begin
generator_sent_time_reg();
end
////////////////////////////////////////////sent_num_reg////////////////////////////////////
repeat(1)begin
generator_sent_num_reg();
end
////////////////////////////////////////////sent_model////////////////////////////////////
repeat(1)begin
generator_sent_model();
end
////////////////////////////////////////////sent_start////////////////////////////////////
repeat(1)begin
generator_sent_start();
end

////////////////////////////////////////////rd_sent_bit_cnt////////////////////////////////////
repeat(1)begin
generator_rd_sent_bit_cnt();
end





////////////////////////////////////////////config_reset////////////////////////////////////
repeat(1)begin
generator_config_reset();
end
 ////////////////////////////////////////4 Ê±¿Ìµ÷¶È±í///////////////////////////////////////////
repeat(1)begin
    generator_stream0_start_time();
end 
repeat(1)begin
    generator_stream0_interval();
end  
repeat(1)begin
    generator_stream1_start_time();
end 
repeat(1)begin
    generator_stream1_interval();
end 
repeat(1)begin
    generator_stream2_start_time();
end 
repeat(1)begin
    generator_stream2_interval();
end 
repeat(1)begin
    generator_stream3_start_time();
end 
repeat(1)begin
    generator_stream3_interval();
end 
////////////////////////////////////////////to_ssm_pkt////////////////////////////////////
repeat(10)begin
generator_pkt_ssm();
end
////////////////////////////////////////////mux_ssm_pkt////////////////////////////////////
repeat(1)begin
generator_mux_ssm_pkt();
end
////////////////////////////////////////////to_ssm_pkt////////////////////////////////////
repeat(1)begin
generator_read_ssm_pkt();
end
end
um um_tb(
.clk(clk),
.rst_n(rst_n),                    
.pktin_data(pktin_data),    
.pktin_data_wr(pktin_data_wr),        
.pktin_data_valid(pktin_data_valid),     
.pktin_data_valid_wr(pktin_data_valid_wr),  
.pktin_data_ready(pktin_ready),     
                      
.pktout_data_0(), 
.pktout_data_wr_0(),     
.pktout_data_valid_0(),  
.pktout_data_valid_wr_0(),
.pktout_data_ready_0(),  
                      
.pktout_data(),
.pktout_data_wr(),   
.pktout_data_valid(), 
.pktout_data_valid_wr(),
.pktout_data_ready()         
);
endmodule