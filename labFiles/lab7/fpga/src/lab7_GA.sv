/*
 * Module: lab7_GA
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * Top level for the UPduino. Adds the internal oscillator.
 */

module lab7_GA (
    input  logic sck,
    input  logic sdi,
    output logic sdo,
    input  logic load,
    output logic done
);

    logic clk;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    aes u_aes (.clk(clk), .sck(sck), .sdi(sdi), .sdo(sdo), .load(load), .done(done));

endmodule
