/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-18 14:47:39
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:07:16
 * @Description: 
   1. The hardware code of DMUX.
   2. Identify packets.
   3. More information in Doc.
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
    output reg [133:0] dmux2ssm_data,
    output reg dmux2ssm_data_wr,
    output reg dmux2ssm_data_valid,
    output reg dmux2ssm_data_valid_wr,
    input ssm2dmux_data_ready
);
assign pktin_data_ready = 1'b1;

localparam IDLE_S = 2'd0,
           SEND_PGM_S = 2'd1,
           SEND_LCM_S = 2'd2,
           SEND_SSM_S = 2'd3;

reg [1:0] dmux_state;


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
    end
    else begin
        case (dmux_state)
            IDLE_S: begin
                if (pktin_data[133:132] == 2'b01 && pktin_data[125:120] == 6'b0 && pktin_data[111:109] != 3'b111) begin
                    //Pkt to PGM
                    dmux2pgm_data <= pktin_data;
                    dmux2pgm_data_wr <= 1'b1;
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

                    dmux_state <= SEND_PGM_S;
                end
                else if (pktin_data[133:132] == 2'b01 && pktin_data[125:120] == 6'b0 && pktin_data[111:109] == 3'b111) begin
                    //Pkt to LCM
                    dmux2pgm_data <= 134'b0;
                    dmux2pgm_data_wr <= 1'b0;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;

                    dmux2lcm_data <= pktin_data;
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux2ssm_data <= 134'b0;
                    dmux2ssm_data_wr <= 1'b0;
                    dmux2ssm_data_valid <= 1'b0;
                    dmux2ssm_data_valid_wr <= 1'b0; 

                    dmux_state <= SEND_LCM_S;
                end
                else if (pktin_data[133:132] == 2'b01 && pktin_data[125:120] != 6'b0) begin
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

                    dmux_state <= IDLE_S;
                end
            end

            SEND_PGM_S: begin
                if (pktin_data[133:132] == 2'b11) begin
                    dmux2pgm_data <= pktin_data;
                    dmux2pgm_data_wr <= 1'b1;
                    dmux2pgm_data_valid <= 1'b0;
                    dmux2pgm_data_valid_wr <= 1'b0;
                    
                    dmux_state <= SEND_PGM_S;
                end
                else if (pktin_data[133:132] == 2'b10) begin
                    dmux2pgm_data <= pktin_data;
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
                if (pktin_data[133:132] == 2'b11) begin
                    dmux2lcm_data <= pktin_data;
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

                    dmux_state <= SEND_LCM_S;
                end
                else if (pktin_data[133:132] == 2'b10) begin
                    dmux2lcm_data <= pktin_data;
                    dmux2lcm_data_wr <= 1'b1;
                    dmux2lcm_data_valid <= 1'b1;
                    dmux2lcm_data_valid_wr <= 1'b1;

                    dmux_state <= IDLE_S;
                end
                else begin
                    dmux2lcm_data <= 134'b0;
                    dmux2lcm_data_wr <= 1'b0;
                    dmux2lcm_data_valid <= 1'b0;
                    dmux2lcm_data_valid_wr <= 1'b0;

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


endmodule