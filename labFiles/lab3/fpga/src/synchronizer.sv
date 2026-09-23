/*
 * Module: synchronizer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/17/26
 * Description:
 * Parameters:
 *   WIDTH - number of bits to synchronize.
 */

module synchronizer #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             reset_b,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    logic [WIDTH-1:0] n1;

    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            n1 <= '0;
            q      <= '0;
        end else begin
            n1 <= d;
            q      <= n1;
        end

endmodule