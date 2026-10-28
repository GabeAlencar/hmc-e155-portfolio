/*
 * Module: keyexpand
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * KeyExpansion, one round at a time
 */

module keyexpand (
    input  logic         clk,
    input  logic [127:0] key,
    input  logic [7:0]   rcon,
    output logic [127:0] y
);

    logic [31:0] w0, w1, w2, w3, rot, subword, temp, n0, n1, n2, n3;

    assign {w0, w1, w2, w3} = key;
    assign rot = {w3[23:0], w3[31:24]};

    sbox_sync u_sbox0 (.a(rot[7:0]),   .clk(clk), .y(subword[7:0]));
    sbox_sync u_sbox1 (.a(rot[15:8]),  .clk(clk), .y(subword[15:8]));
    sbox_sync u_sbox2 (.a(rot[23:16]), .clk(clk), .y(subword[23:16]));
    sbox_sync u_sbox3 (.a(rot[31:24]), .clk(clk), .y(subword[31:24]));

    assign temp = subword ^ {rcon, 24'b0};

    assign n0 = w0 ^ temp;
    assign n1 = w1 ^ n0;
    assign n2 = w2 ^ n1;
    assign n3 = w3 ^ n2;
    assign y  = {n0, n1, n2, n3};

endmodule
