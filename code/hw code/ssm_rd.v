/*
 * @Author: Wu Shangming
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-28 23:03:30
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-29 00:19:24
 * @Description: 
 */

`timescale 1 ns / 1 ps
module ssm_rd #(
    parameter PLATFORM = "Xilinx-OpenBox-S4"
)(
    input clk,
    input rst_n,
    //receive from lcm
    input lcm2ram_rd,
    input [10:0] lcm2ram_rd_addr,
    //read from RAM
    input [133:0] ram2ssm_rd_data,
    //read addr and siganl
    output reg [10:0] ram_rd_addr,
    output reg ram_rd,
    //output data
    output reg [133:0] out_ssm_rd_data,
    output reg out_ssm_rd_data_wr,
    output reg out_ssm_rd_valid,
    output reg out_ssm_rd_valid_wr
);

reg [2:0] ssm_rd_state;

localparam IDLE_S = 3'd0,
           HAUNT1_S = 3'd1,
           HAUNT2_S = 3'd2,
           READ_S = 3'd3,
           RD_FIN_S = 3'd4;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ram_rd_addr <= 11'b0;
        ram_rd <= 1'b0;

        out_ssm_rd_data <= 134'b0;
        out_ssm_rd_data_wr <= 1'b0;
        out_ssm_rd_valid <= 1'b0;
        out_ssm_rd_valid_wr <= 1'b0;

        ssm_rd_state <= IDLE_S;
    end
    else begin
        case (ssm_rd_state)
            IDLE_S: begin
                out_ssm_rd_data <= 134'b0;
                out_ssm_rd_data_wr <= 1'b0;
                out_ssm_rd_valid <= 1'b0;
                out_ssm_rd_valid_wr <= 1'b0;

                if (lcm2ram_rd == 1'b1) begin
                    ram_rd_addr <= lcm2ram_rd_addr;
                    ram_rd <= 1'b1;
                    
                    ssm_rd_state <= HAUNT1_S;
                end
                else begin
                    ram_rd_addr <= 11'b0;
                    ram_rd <= 1'b0;
                    
                    ssm_rd_state <= IDLE_S;
                end
            end

            HAUNT1_S: begin
                ram_rd_addr <= ram_rd_addr + 11'b1;
                ram_rd <= 1'b1;
                
                ssm_rd_state <= HAUNT2_S;
            end

            HAUNT2_S: begin
                ram_rd_addr <= ram_rd_addr + 11'b1;
                ram_rd <= 1'b1;

                ssm_rd_state <= READ_S;
            end

            READ_S: begin
                if (ram2ssm_rd_data[133:132] == 2'b01) begin
                    out_ssm_rd_data <= ram2ssm_rd_data;
                    out_ssm_rd_data_wr <= 1'b1;
                    out_ssm_rd_valid <= 1'b0;
                    out_ssm_rd_valid_wr <= 1'b0;

                    ram_rd_addr <= ram_rd_addr + 11'b1;
                    ram_rd <= 1'b1;

                    ssm_rd_state <= READ_S;
                end
                else if (ram2ssm_rd_data[133:132] == 2'b10) begin
                    out_ssm_rd_data <= ram2ssm_rd_data;
                    out_ssm_rd_data_wr <= 1'b1;
                    out_ssm_rd_valid <= 1'b1;
                    out_ssm_rd_valid_wr <= 1'b1;

                    ram_rd_addr <= 11'b0;
                    ram_rd <= 1'b0;
                    ssm_rd_state <= RD_FIN_S;
                end 
                else if (ram2ssm_rd_data[133:132] == 2'b11) begin
                    out_ssm_rd_data <= ram2ssm_rd_data;
                    out_ssm_rd_data_wr <= 1'b1;
                    out_ssm_rd_valid <= 1'b0;
                    out_ssm_rd_valid_wr <= 1'b0;

                    ram_rd_addr <= ram_rd_addr + 11'b1;
                    ram_rd <= 1'b1;

                    ssm_rd_state <= READ_S;
                end
                else begin
                    out_ssm_rd_data <= 134'b0;
                    out_ssm_rd_data_wr <= 1'b0;
                    out_ssm_rd_valid <= 1'b0;
                    out_ssm_rd_valid_wr <= 1'b0;

                    ram_rd_addr <= 11'b0;
                    ram_rd <= 1'b0;

                    ssm_rd_state <= IDLE_S;
                end
            end

            RD_FIN_S: begin
                if (lcm2ram_rd == 1'b1) begin
                    out_ssm_rd_data <= 134'b0;
                    out_ssm_rd_data_wr <= 1'b0;
                    out_ssm_rd_valid <= 1'b0;
                    out_ssm_rd_valid_wr <= 1'b0;

                    ram_rd_addr <= 11'b0;
                    ram_rd <= 1'b0;

                    ssm_rd_state <= RD_FIN_S;
                end
                else begin
                    out_ssm_rd_data <= 134'b0;
                    out_ssm_rd_data_wr <= 1'b0;
                    out_ssm_rd_valid <= 1'b0;
                    out_ssm_rd_valid_wr <= 1'b0;
                    ssm_rd_state <= IDLE_S;
                end
            end
        endcase
    end
end

endmodule