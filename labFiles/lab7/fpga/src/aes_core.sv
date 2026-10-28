/*
 * Module: aes_core
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 */

module aes_core (
    input  logic         clk,
    input  logic         load,
    input  logic [127:0] key,
    input  logic [127:0] plaintext,
    output logic         done,
    output logic [127:0] cyphertext
);

    logic init_en, round_en, last_round;

    aes_ctrl     u_ctrl     (.clk(clk), .load(load), .init_en(init_en), .round_en(round_en), .last_round(last_round), .done(done));
    aes_datapath u_datapath (.clk(clk), .init_en(init_en), .round_en(round_en), .last_round(last_round), .key(key), .plaintext(plaintext), .cyphertext(cyphertext));

endmodule
