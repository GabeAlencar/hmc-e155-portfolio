/*
 * Module: aes_datapath
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * Datapath for aes_core
 */

module aes_datapath (
    input  logic         clk,
    input  logic         init_en,
    input  logic         round_en,
    input  logic         last_round,
    input  logic [127:0] key,
    input  logic [127:0] plaintext,
    output logic [127:0] cyphertext
);

    logic [127:0] state, roundkey, nextkey;
    logic [127:0] init_state, subbed, shifted, mixed, round_out, round_state;
    logic [7:0]   rcon, rcon_next;

    // AddRoundKey
    addroundkey u_ark_init (.a(plaintext), .k(key), .y(init_state));

    // Round
    subbytes    u_subbytes  (.clk(clk), .a(state), .y(subbed));
    shiftrows   u_shiftrows (.a(subbed), .y(shifted));
    mixcolumns  u_mixcolumns(.a(shifted), .y(mixed));
    assign round_out = last_round ? shifted : mixed;

    keyexpand   u_keyexpand (.clk(clk), .key(roundkey), .rcon(rcon), .y(nextkey));
    addroundkey u_ark_round (.a(round_out), .k(nextkey), .y(round_state));

    // rcon doubled 
    galoismult  u_rcon      (.a(rcon), .y(rcon_next));
    
    always_ff @(posedge clk)
        if (init_en) begin
            state    <= init_state;
            roundkey <= key;
            rcon     <= 8'h01;
        end else if (round_en) begin
            state    <= round_state;
            roundkey <= nextkey;
            rcon     <= rcon_next;
        end

    assign cyphertext = state;

endmodule
