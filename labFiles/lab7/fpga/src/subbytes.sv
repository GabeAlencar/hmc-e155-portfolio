/*
 * Module: subbytes
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * SubBytes
 */

module subbytes (
    input  logic         clk,
    input  logic [127:0] a,
    output logic [127:0] y
);

    sbox_sync u_sbox0  (.a(a[7:0]), .clk(clk), .y(y[7:0]));
    sbox_sync u_sbox1  (.a(a[15:8]), .clk(clk), .y(y[15:8]));
    sbox_sync u_sbox2  (.a(a[23:16]), .clk(clk), .y(y[23:16]));
    sbox_sync u_sbox3  (.a(a[31:24]), .clk(clk), .y(y[31:24]));
    sbox_sync u_sbox4  (.a(a[39:32]), .clk(clk), .y(y[39:32]));
    sbox_sync u_sbox5  (.a(a[47:40]), .clk(clk), .y(y[47:40]));
    sbox_sync u_sbox6  (.a(a[55:48]), .clk(clk), .y(y[55:48]));
    sbox_sync u_sbox7  (.a(a[63:56]), .clk(clk), .y(y[63:56]));
    sbox_sync u_sbox8  (.a(a[71:64]), .clk(clk), .y(y[71:64]));
    sbox_sync u_sbox9  (.a(a[79:72]), .clk(clk), .y(y[79:72]));
    sbox_sync u_sbox10 (.a(a[87:80]), .clk(clk), .y(y[87:80]));
    sbox_sync u_sbox11 (.a(a[95:88]), .clk(clk), .y(y[95:88]));
    sbox_sync u_sbox12 (.a(a[103:96]), .clk(clk), .y(y[103:96]));
    sbox_sync u_sbox13 (.a(a[111:104]), .clk(clk), .y(y[111:104]));
    sbox_sync u_sbox14 (.a(a[119:112]), .clk(clk), .y(y[119:112]));
    sbox_sync u_sbox15 (.a(a[127:120]), .clk(clk), .y(y[127:120]));

endmodule
