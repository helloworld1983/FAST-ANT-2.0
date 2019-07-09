/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-19 15:07:18
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:07:41
 * @Description:
   1. The code of Reg_WR.
   2. Write data from sw to intended registers.
   3. More information in Doc.
 */

`timescale 1 ns / 1 ps
module lcm_reg_wr #(
    parameter PLATFORM = "Xilinx-OpenBox-S4",
              LMID = 8'd31
)(
    input clk,
    input rst_n,

    input [7:0] wr_reg_n,
    input [63:0] wr_reg_n_value,

    output reg lcm2ssm_reset,
    output reg lcm2ssm_rd,
    output reg [10:0] lcm2ssm_addr,
    output reg [7:0] protocol_type,
    output reg pgm_config_reset,
    output reg [63:0] sent_start_time_n_reg_o,
    output reg [63:0] sent_rate_n_reg_o,
    output reg table_entry_wr,
    output reg sent_start,
    output reg sent_model,
    output reg [63:0] sent_time_reg_o,
    output reg [63:0] sent_num_reg_o,
    output reg mux2port_0_rd
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcm2ssm_reset <= 1'b0;
        lcm2ssm_rd <= 1'b0;
        lcm2ssm_addr <= 11'b0;
        protocol_type <= 8'b0;
        pgm_config_reset <= 1'b0;
        sent_start_time_n_reg_o <= 64'b0;
        sent_rate_n_reg_o <= 64'b0;
        table_entry_wr <= 1'b0;
        sent_start <= 1'b0;
        sent_model <= 1'b0;
        sent_time_reg_o <= 64'b0;
        sent_num_reg_o <= 64'b0;
        mux2port_0_rd <= 1'b0;
    end
    else begin
        case (wr_reg_n)
            8'd1: lcm2ssm_reset <= wr_reg_n_value[0];

            8'd2: begin 
                      lcm2ssm_addr <= wr_reg_n_value[10:0];
                      lcm2ssm_rd <= wr_reg_n_value[11];    
            end

           // 8'd3: lcm2ssm_addr <= wr_reg_n_value[10:0];

            8'd4: protocol_type <= wr_reg_n_value[7:0];

            8'd5: pgm_config_reset <= wr_reg_n_value[0];

            8'd6: sent_start_time_n_reg_o <= wr_reg_n_value;

            8'd7: begin
                  sent_rate_n_reg_o <= wr_reg_n_value;
                  table_entry_wr <= 1'b1;
            end

            8'd8: sent_start <= wr_reg_n_value[0];

            8'd9: sent_model <= wr_reg_n_value[0];

            8'd10: sent_time_reg_o <= wr_reg_n_value;

            8'd11: sent_num_reg_o <= wr_reg_n_value;

            8'd12: mux2port_0_rd <= wr_reg_n_value[0];

            default: begin
                table_entry_wr <= 1'b0;
                pgm_config_reset <= 1'b0;
                lcm2ssm_rd <= 1'b0;
            end
        endcase
    end
end

endmodule