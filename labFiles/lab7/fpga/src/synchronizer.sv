/*
 * Module: synchronizer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * Two flop synchronizer for a single asynchronous input.
 */

module synchronizer (
    input  logic clk,
    input  logic d,
    output logic q
);

    logic n1;

    always_ff @(posedge clk) begin
        n1 <= d;
        q    <= n1;
    end

endmodule