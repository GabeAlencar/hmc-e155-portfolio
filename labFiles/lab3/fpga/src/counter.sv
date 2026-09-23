/*
 * Module: counter
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 * Parameters:
 *   WIDTH - number of bits in the count register.
 *   MAX   - count value at which the counter wraps back to 0.
 */

module counter #(
    parameter int WIDTH = 24,
    parameter int MAX   = 9_999_999
) (
    input  logic             clk,
    input  logic             reset_b,
    input  logic             enable,
    output logic [WIDTH-1:0] count
);

    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            count <= '0;
        end else if (enable) begin
            if (count == MAX[WIDTH-1:0])
                count <= '0;
            else
                count <= count + 1'b1;
        end

endmodule