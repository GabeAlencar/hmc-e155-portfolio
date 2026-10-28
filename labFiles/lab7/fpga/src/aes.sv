/*
 * Module: aes
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * Top level module with SPI interface and AES core.
 */

module aes (
    input  logic clk,
    input  logic sck,
    input  logic sdi,
    output logic sdo,
    input  logic load,
    output logic done
);

    logic [127:0] key, plaintext, cyphertext;
    logic         load_sync;

    synchronizer u_load_sync (.clk(clk), .d(load), .q(load_sync));

    aes_spi  u_spi  (.sck(sck), .sdi(sdi), .sdo(sdo), .done(done), .key(key), .plaintext(plaintext), .cyphertext(cyphertext));
    aes_core u_core (.clk(clk), .load(load_sync), .key(key), .plaintext(plaintext), .done(done), .cyphertext(cyphertext));

endmodule
