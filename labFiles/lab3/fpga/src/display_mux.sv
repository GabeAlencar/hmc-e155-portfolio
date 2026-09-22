/*
 * Module: display_mux
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Parameters:
 *   MUX_W - width of the free-running mux counter; its MSB sets the
 *           digit-select rate (mux frequency = clk / 2**MUX_W).
 */

module display_mux #(
    parameter int MUX_W = 17
) (
    input  logic       clk,
    input  logic       reset_b,
    input  logic [3:0] digit_left,
    input  logic [3:0] digit_right,
    output logic [6:0] seg,
    output logic [1:0] anode_n
);

    logic [MUX_W-1:0] mux_count;
    logic              sel_left;
    logic [3:0]        digit_shown;

    counter #(.WIDTH(MUX_W), .MAX((2**MUX_W)-1)) u_mux_counter (.clk(clk), .reset_b(reset_b), .enable(1'b1), .count(mux_count));

    assign sel_left    = mux_count[MUX_W-1];
    assign digit_shown = sel_left ? digit_left : digit_right;
    assign anode_n     = sel_left ? 2'b01 : 2'b10;

    sevenseg_decoder u_sevenseg (.s(digit_shown), .seg(seg));

endmodule
