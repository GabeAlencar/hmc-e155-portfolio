/*
 * Module: counter
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
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
    output logic [WIDTH-1:0] count = '0
);

    always_ff @(posedge clk, posedge reset_b)
        if (reset_b)
            count <= '0;
        else if (enable)
            if (count == MAX[WIDTH-1:0])
                count <= '0;
            else
                count <= count + 1'b1;

endmodule
