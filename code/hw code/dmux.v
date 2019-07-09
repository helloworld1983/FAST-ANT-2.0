/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-29 16:17:14
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-07-04 15:32:43
 * @Description: 
   1.The code of dmux.
   2.Identify the pkt through different ip protocols and inports.
   3.More information in Doc
 */

`timescale 1 ns / 1 ps
module dmux #(
    parameter PLATFORM = "Xilinx-OpenBox-S4",
              LMID = 8'd1
)(
    input clk,
    input rst_n,

    //Pkt from FPGA OS
    input [133:0] pktin_data,
    input pktin_data_wr,
    input pktin_data_valid,
    input pktin_data_valid_wr,
    output wire pktin_data_ready,

    //Pkt to PGM
    output reg [133:0] dmux2pgm_data,
    output reg dmux2pgm_data_wr,
    output reg dmux2pgm_data_valid,
    output reg dmux2pgm_data_valid_wr,
    input pgm2dmux_data_ready,

    //Pkt to LCM
    output reg [133:0] dmux2lcm_data,
    output reg dmux2lcm_data_wr,
    output reg dmux2lcm_data_valid,
    output reg dmux2lcm_data_valid_wr,
    input lcm2dmux_data_ready,

    //Pkt to SSM
    input ssm2dmux_data_ready,
    output reg [133:0] dmux2ssm_data,
    output reg dmux2ssm_data_wr,
    output reg dmux2ssm_data_valid,
    output reg dmux2ssm_data_valid_wr
);

assign pktin_data_ready = 1'b1;

localparam IDLE_S = 3'd0,
           SEND_PGM_S = 3'd1,
           SEND_LCM_S = 3'd2,
           SEND_SSM_S = 3'd3,
           STORE_S = 3'd4;


reg [2:0] dmux_state;
reg [6:0] pkt_cnt;
reg w_r_flag;
reg select_flag;
reg ip_flag;

reg [133:0] fifo_data_in;
reg fifo_data_wr;
wire [133:0] fifo_data_out;
reg fifo_data_rd;
wire fifo_data_full;
wire fifo_data_empty;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        //clear pgm
        dmux2pgm_data <= 134'b0;
        dmux2pgm_data_wr <= 1'b0;
        dmux2pgm_data_valid <= 1'b0;
        dmux2pgm_data_valid_wr <= 1'b0;

        //clear lcm
        dmux2lcm_data <= 134'b0;
        dmux2lcm_data_wr <= 1'b0;
        dmux2lcm_data_valid <= 1'b0;
        dmux2lcm_data_valid_wr <= 1'b0;

        //clear ssm
        dmux2ssm_data <= 134'b0;
        dmux2ssm_data_wr <= 1'b0;
        dmux2ssm_data_valid <= 1'b0;
        dmux2ssm_data_valid_wr <= 1'b0; 

        dmux_state <= IDLE_S;
        
        pkt_cnt <= 7'b0;
        w_r_flag <= 1'b0;
        select_flag <= 1'b0;
        ip_flag <= 1'b0;
    end
    else begin
        case (dmux_state)
            IDLE_S: begin
                if (pktin_data[133:132] == 2'b01 && pktin_data[125:120] != 6'b0 && pktin_data_wr == 1'b1) begin
                    //Pkt to SSM
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux2lcm_data <= 134'b0;
                    dmux2lcm_data_wr <= 1'b0;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux2ssm_data <= pktin_data;
                    dmux2ssm_data_wr <= 1'b1;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2ssm_data_valid_wr <= 1'b0; 

                    dmux_state <= SEND_SSM_S;
                end
                else if (pktin_data[133:132] == 2'b01 && pktin_data[125:120] == 6'b0 && pktin_data_wr == 1'b1) begin
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux2lcm_data <= 134'b0;
                    dmux2lcm_data_wr <= 1'b0;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux2ssm_data <= 134'b0;
                    dmux2ssm_data_wr <= 1'b0;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2ssm_data_valid_wr <= 1'b0; 
                    if (!fifo_data_full) begin
                        fifo_data_in <= pktin_data;
                        fifo_data_wr <= 1'b1;

                        dmux_state <= STORE_S;
                    end
                    else begin
                        fifo_data_in <= 134'b0;
                        fifo_data_wr <= 1'b0;

                        dmux_state <= IDLE_S;
                    end
                end
                else begin
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux2lcm_data <= 134'b0;
                    dmux2lcm_data_wr <= 1'b0;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux2ssm_data <= 134'b0;
                    dmux2ssm_data_wr <= 1'b0;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2ssm_data_valid_wr <= 1'b0; 

                    fifo_data_in <= 134'b0;
                    fifo_data_wr <= 1'b0;

                    dmux_state <= IDLE_S;
                end

                pkt_cnt <= 7'b0;
                w_r_flag <= 1'b0;
                select_flag <= 1'b0;
                ip_flag <= 1'b0;

                fifo_data_rd <= 1'b0;
            end
            
            STORE_S: begin
                if (pktin_data[133:132] == 2'b11 && pktin_data_wr == 1'b1) begin
                    if (pkt_cnt == 7'd1) begin
                        pkt_cnt <= pkt_cnt + 7'b1;

                        if (!fifo_data_full) begin
                            fifo_data_in <= pktin_data;
                            fifo_data_wr <= 1'b1;

                            dmux_state <= STORE_S;
                        end
                        else begin
                            fifo_data_in <= 134'b0;
                            fifo_data_wr <= 1'b0;

                            dmux_state <= IDLE_S;
                        end
                        
                        if (pktin_data[31:16] == 16'h0800) begin
                            ip_flag <= 1'b1;
                        end
                        else begin
                            ip_flag <= 1'b0;
                        end
                    end
                    else if (pkt_cnt == 7'd2) begin 
                        pkt_cnt <= pkt_cnt + 7'b1;

                        if (!fifo_data_full) begin
                            fifo_data_in <= pktin_data;
                            fifo_data_wr <= 1'b1;

                            dmux_state <= STORE_S;
                        end
                        else begin
                            fifo_data_in <= 134'b0;
                            fifo_data_wr <= 1'b0;

                            dmux_state <= IDLE_S;
                        end
                        
                        if (pktin_data[71:64] == 8'hc8 && ip_flag == 1'b1) begin
                            //To LCM-wr
                            select_flag <= 1'b0;
                            w_r_flag <= 1'b0;
                        end
                        else if (pktin_data[71:64] == 8'hc9 && ip_flag == 1'b1) begin
                            //To LCM-rd
                            select_flag <= 1'b0;
                            w_r_flag <= 1'b1;
                        end
                        else begin
                            //To PGM
                            select_flag <= 1'b1;
                        end
                    end
                    else begin
                        pkt_cnt <= pkt_cnt + 7'b1;

                        if (!fifo_data_full) begin
                            fifo_data_in <= pktin_data;
                            fifo_data_wr <= 1'b1;

                            dmux_state <= STORE_S;
                        end
                        else begin
                            fifo_data_in <= 134'b0;
                            fifo_data_wr <= 1'b0;

                            dmux_state <= IDLE_S;
                        end
                    end
                end
                else if (pktin_data[133:132] == 2'b10 && pktin_data_wr == 1'b1) begin
                    pkt_cnt <= pkt_cnt + 7'b1;
                    
                    if (!fifo_data_full) begin
                        fifo_data_in <= pktin_data;
                        fifo_data_wr <= 1'b1;
                    end
                    else begin
                        fifo_data_in <= 134'b0;
                        fifo_data_wr <= 1'b0;
                    end

                    if (select_flag == 1'b1) begin
                        dmux_state <= SEND_PGM_S;
                        fifo_data_rd <= 1'b1;
                    end
                    else begin
                        dmux_state <= SEND_LCM_S;
                        fifo_data_rd <= 1'b1;
                    end
                end
            end

            SEND_PGM_S: begin
                fifo_data_wr <= 1'b0;
                //fifo_data_rd <= 1'b1;
                
                if (fifo_data_out[133:132] != 2'b10 && !fifo_data_empty) begin
                    dmux2pgm_data <= fifo_data_out;
                    dmux2pgm_data_wr <= 1'b1;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux_state <= SEND_PGM_S;
                end
                else if (fifo_data_out[133:132] == 2'b10 && !fifo_data_empty) begin
                    dmux2pgm_data <= fifo_data_out;
                    dmux2pgm_data_wr <= 1'b1;
                    dmux2pgm_data_valid <= 1'b1;
                    dmux2pgm_data_valid_wr <= 1'b1;

                    dmux_state <= IDLE_S;
                end
                else begin
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux_state <= IDLE_S;
                end
            end

            SEND_LCM_S: begin
                fifo_data_wr <= 1'b0;
                //fifo_data_rd <= 1'b1;
                
                if (fifo_data_out[133:132] == 2'b01 && !fifo_data_empty) begin
                    dmux2lcm_data <= {fifo_data_out[133:48], w_r_flag ,fifo_data_out[47:0]};
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux_state <= SEND_LCM_S;
                end
                else if (fifo_data_out[133:132] == 2'b11 && !fifo_data_empty) begin
                    dmux2lcm_data <= fifo_data_out;
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux_state <= SEND_LCM_S;
                end
                else if (fifo_data_out[133:132] == 2'b10 && !fifo_data_empty) begin
                    dmux2lcm_data <= fifo_data_out;
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b1;
                    dmux2lcm_data_valid_wr <= 1'b1;

                    dmux_state <= IDLE_S;
                end
                else begin
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux_state <= IDLE_S;
                end
            end

            SEND_SSM_S: begin
                if (pktin_data[133:132] == 2'b11) begin
                    dmux2ssm_data <= pktin_data;
                    dmux2ssm_data_wr <= 1'b1;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux_state <= SEND_SSM_S;
                end
                else if (pktin_data[133:132] == 2'b10) begin
                    dmux2ssm_data <= pktin_data;
                    dmux2ssm_data_wr <= 1'b1;
                    dmux2ssm_data_valid <= 1'b1;
                    dmux2ssm_data_valid_wr <= 1'b1;

                    dmux_state <= IDLE_S;
                end
                else begin
                    dmux2ssm_data <= 134'b0;
                    dmux2ssm_data_wr <= 1'b0;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2ssm_data_valid_wr <= 1'b0;

                    dmux_state <= IDLE_S;
                end
            end
            
        endcase
    end
end

fifo_134_128 fifo_134_128(
    .clk(clk),
    .srst(!rst_n),
    .din(fifo_data_in),
    .wr_en(fifo_data_wr),
    .dout(fifo_data_out),
    .rd_en(fifo_data_rd),
    .full(fifo_data_full),
    .empty(fifo_data_empty)
);

endmodule