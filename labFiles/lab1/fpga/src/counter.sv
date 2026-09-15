/*
 * Module: counter
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 *
 * Parameters:
 *   WIDTH - number of bits in the internal count register.
 *   MAX   - count value at which the counter wraps to 0 and `blink` toggles.
 */

module counter #(
    parameter int WIDTH = 24,
    parameter int MAX   = 9_999_999
) (
    input  logic clk,
    input  logic reset,
    input  logic en,
    output logic blink
);

    logic [WIDTH-1:0] count = '0;
    logic             blink_r = 1'b0;

    assign blink = blink_r;

    always_ff @(posedge clk, posedge reset)
        if (reset) begin
            count   <= '0;
            blink_r <= 1'b0;
        end else if (en) begin
            if (count == MAX[WIDTH-1:0]) begin
                count   <= '0;
                blink_r <= ~blink_r;
            end else begin
                count <= count + 1'b1;
            end
        end

endmodule
