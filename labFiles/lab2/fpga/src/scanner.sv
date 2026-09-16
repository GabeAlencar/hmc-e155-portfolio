/*
 * Module: scanner
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 * Parameters:
 *   DIV   - clock cycles each row stays active.
 *   DIV_W - number of bits in the prescaler count register.
 */

module scanner #(
    parameter int DIV   = 6_000_000,
    parameter int DIV_W = 23
) (
    input  logic       clk,
    input  logic       reset_b,
    input  logic       enable,
    output logic [3:0] rows
);

    logic [DIV_W-1:0] div_count;
    logic             tick;
    logic [1:0]       state;

    // prescaler counter
    counter #(.WIDTH(DIV_W), .MAX(DIV - 1)) u_prescaler (.clk(clk), .reset_b(reset_b), .enable(enable), .count(div_count));

    // prescaler-tick logic
    assign tick = enable & (div_count == DIV - 1);

    // row state counter
    counter #(.WIDTH(2), .MAX(3)) u_state_ctr (.clk(clk), .reset_b(reset_b), .enable(tick), .count(state));

    // row decoder OL
    assign rows = 4'b0001 << state;

endmodule