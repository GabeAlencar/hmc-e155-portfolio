/*
 * Module: tick_gen
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/22/26
 * Parameters:
 *   TICK_W - width of the free-running counter; tick strobes high for one
 *            clock cycle every 2**TICK_W cycles.
 */

module tick_gen #(
    parameter int TICK_W = 19
) (
    input  logic clk,
    input  logic reset_b,
    output logic tick
);

    logic [TICK_W-1:0] count;

    // free-running counter
    counter #(.WIDTH(TICK_W), .MAX((2**TICK_W)-1)) u_tick_counter (.clk(clk), .reset_b(reset_b), .enable(1'b1), .count(count));

    // one-cycle enable strobe on the last count
    assign tick = &count;

endmodule
