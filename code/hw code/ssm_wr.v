/*
 * @Author: Wu Shangming
 * @Email: lang_jy@outlook.com
 * @Date: 2019-06-28 23:03:50
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-06-28 23:53:36
 * @Description: 
   1.The code of ssm_wr.
   2.Record the input timestamps and write the pkt into RAM.
   3.More information in Doc.
 */
 
 `timescale 1 ns / 1 ps
module ssm_wr #(
    parameter PLATFORM = "Xilinx-OpenBox-S4"
)(
    input clk,
    input rst_n,

    input reset_wr,
    //receive data
    input [133:0] in_ssm_wr_data,
    input in_ssm_wr_data_wr,
    input in_ssm_wr_valid,
    input in_ssm_wr_valid_wr,
    //timestamps
    input [63:0] lcm2ssm_wr_time,
    //store to RAM
    output reg [10:0] ssm_wr_addr,
    output reg [133:0] out_ssm_wdata,
    output reg out_ssm_wdata_wr
);

reg [3:0] ram_pkt_num_cnt;
reg [3:0] pkt_cnt;

reg [1:0] ssm_wr_state;

localparam IDLE_S = 2'd0,
           WRITE_S = 2'd1,
           CLEAR_S = 2'd2;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ssm_wr_addr <= 11'b0;
        out_ssm_wdata <= 134'b0;
        out_ssm_wdata_wr <= 1'b0;

        ram_pkt_num_cnt <= 4'b0;
        pkt_cnt <= 4'b0;

        ssm_wr_state <= IDLE_S;
    end
    else begin
        case (ssm_wr_state)
            IDLE_S: begin
                if (in_ssm_wr_data[133:132] == 2'b01 && in_ssm_wr_data_wr == 1'b1 && reset_wr == 1'b0) begin
                    ssm_wr_addr <= ram_pkt_num_cnt * 64'd128;
                    out_ssm_wdata <= in_ssm_wr_data;
                    out_ssm_wdata_wr <= 1'b1;

                    pkt_cnt <= pkt_cnt + 4'b1;

                    ssm_wr_state <= WRITE_S;
                end
                else if (reset_wr == 1'b1) begin
                    ssm_wr_state <= CLEAR_S;
                end
                else begin
                                                   // ssm_wr_addr <= 11'b0;
                    out_ssm_wdata <= 134'b0;
                    out_ssm_wdata_wr <= 1'b0;

                                                  // ram_pkt_num_cnt <= 4'b0;
                    pkt_cnt <= 4'b0;

                    ssm_wr_state <= IDLE_S;
                end
            end

            WRITE_S: begin
                if (in_ssm_wr_data[133:132] == 2'b11 && in_ssm_wr_data_wr == 1'b1 && pkt_cnt == 4'd5) begin
                    ssm_wr_addr <= ssm_wr_addr + 11'b1;
                    //Record the input timestamps
                    out_ssm_wdata <= {in_ssm_wr_data[133:64], lcm2ssm_wr_time};
                    out_ssm_wdata_wr <= 1'b1;

                    pkt_cnt <= pkt_cnt + 4'b1;

                    ssm_wr_state <= WRITE_S;
                end
                else if (in_ssm_wr_data[133:132] == 2'b11 && in_ssm_wr_data_wr == 1'b1 && pkt_cnt != 4'd5) begin
                    ssm_wr_addr <= ssm_wr_addr + 11'b1;
                    out_ssm_wdata <= in_ssm_wr_data;
                    out_ssm_wdata_wr <= 1'b1;

                    pkt_cnt <= pkt_cnt + 4'b1;

                    ssm_wr_state <= WRITE_S;
                end
                else if (in_ssm_wr_data[133:132] == 2'b10 && in_ssm_wr_data_wr == 1'b1 && pkt_cnt == 4'd5) begin
                    ssm_wr_addr <= ssm_wr_addr + 11'b1;
                    out_ssm_wdata <= {in_ssm_wr_data[133:64], lcm2ssm_wr_time};
                    out_ssm_wdata_wr <= 1'b1;

                    ram_pkt_num_cnt <= ram_pkt_num_cnt + 4'b1;
                    pkt_cnt <= 4'b0;

                    ssm_wr_state <=IDLE_S;
                end
                else if (in_ssm_wr_data[133:132] == 2'b10 && in_ssm_wr_data_wr == 1'b1 && pkt_cnt != 4'd5) begin
                    ssm_wr_addr <= ssm_wr_addr + 11'b1;
                    out_ssm_wdata <= in_ssm_wr_data;
                    out_ssm_wdata_wr <= 1'b1;

                    ram_pkt_num_cnt <= ram_pkt_num_cnt + 4'b1;
                    pkt_cnt <= 4'b0;

                    ssm_wr_state <= IDLE_S;
                end
                else  //  error packet
                    ssm_wr_state <= IDLE_S;
            end

            CLEAR_S: begin
                if (reset_wr == 1'b1) begin
                    ssm_wr_addr <= 11'b0;
                    out_ssm_wdata <= 134'b0;
                    out_ssm_wdata_wr <= 1'b0;

                    ram_pkt_num_cnt <= 4'b0;
                    pkt_cnt <= 4'b0;

                    ssm_wr_state <= CLEAR_S;
                end
                else if (reset_wr == 1'b0) begin
                    ssm_wr_state <= IDLE_S;
                end
            end

        endcase
    end
end

endmodule