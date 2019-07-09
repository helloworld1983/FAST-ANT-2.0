/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-18 16:04:52
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:07:11
 * @Description:
   1. The code of MUX.
   2. Decide which packet to port_0.
   3. More information in Doc.
 */

`timescale 1 ns / 1 ps 
module mux #(
    parameter PLATFOMR = "Xilinx-OpenBox-S4",
              LMID = 8'd5
 )(
     input clk,
     input rst_n,

     //Pkt from LCM to Port_0
     input [133:0] lcm2mux_data,
     input lcm2mux_data_wr,
     input lcm2mux_data_valid,
     input lcm2mux_data_valid_wr,
     output reg mux2lcm_data__ready,
     //Pkt from SSM to Port_0
     input [133:0] ssm2mux_data,
     input ssm2mux_data_wr,
     input ssm2mux_data_valid,
     input ssm2mux_data_valid_wr,
     output reg mux2ssm_data__ready,
     //Selecting Signal from LCM
     input mux2port_0_rd,

     //Pkt to Port_0
    // input port2mux_0_data_ready,
     output reg [133:0] mux2port_0_data,
     output reg mux2port_0_data_wr,
     output reg mux2port_0_data_valid,
     output reg mux2port_0_data_valid_wr
 );

localparam IDLE_S = 2'd0,
           LCM_SEND_S = 2'd1,
           SSM_SEND_S = 2'd2;

reg [1:0] mux_state;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mux2port_0_data <= 134'b0;
        mux2port_0_data_wr <= 1'b0;
        mux2port_0_data_valid <= 1'b0;
        mux2port_0_data_valid_wr <= 1'b0;

        mux_state <= IDLE_S;
    end
    else begin
        case (mux_state)
            IDLE_S: begin
                if (mux2port_0_rd == 1'b0 && lcm2mux_data[133:132] == 2'b01) begin
                    mux2port_0_data <= lcm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= LCM_SEND_S;
                end
                else if (mux2port_0_rd == 1'b1 && ssm2mux_data[133:132] == 2'b01) begin
                    mux2port_0_data <= ssm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= SSM_SEND_S;
                end
                else begin
                    mux2port_0_data <= 134'b0;
                    mux2port_0_data_wr <= 1'b0;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= IDLE_S;
                end
            end

            LCM_SEND_S: begin
                if (lcm2mux_data[133:132] == 2'b11) begin
                    mux2port_0_data <= lcm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= LCM_SEND_S;
                end
                else if (lcm2mux_data[133:132] == 2'b10) begin
                    mux2port_0_data <= lcm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b1;
                    mux2port_0_data_valid_wr <= 1'b1;

                    mux_state <= IDLE_S;
                end
                else begin
                    mux2port_0_data <= 134'b0;
                    mux2port_0_data_wr <= 1'b0;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= IDLE_S;
                end
            end

            SSM_SEND_S: begin
                if (ssm2mux_data[133:132] == 2'b11) begin
                    mux2port_0_data <= ssm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <= 1'b0;

                    mux_state <= SSM_SEND_S;
                end
                else if (ssm2mux_data[133:132] == 2'b10) begin
                    mux2port_0_data <= ssm2mux_data;
                    mux2port_0_data_wr <= 1'b1;
                    mux2port_0_data_valid <= 1'b1;
                    mux2port_0_data_valid_wr <= 1'b1;

                    mux_state <= IDLE_S;
                end
                else begin
                    mux2port_0_data <= 134'b0;
                    mux2port_0_data_wr <= 1'b0;
                    mux2port_0_data_valid <= 1'b0;
                    mux2port_0_data_valid_wr <=1'b0;

                    mux_state <= IDLE_S;
                end
            end
            
        endcase
    end
end

endmodule