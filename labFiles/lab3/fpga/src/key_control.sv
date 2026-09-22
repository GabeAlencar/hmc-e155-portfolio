/*
 * Module: key_control
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Turns the debouncer's any_key level into a one-cycle pulse the instant a
 * newly-confirmed reading appears -- Lecture 04's level-to-pulse (strobe)
 * pattern -- then gates that pulse so only a genuine single-key reading
 * ever registers as a valid keypress.
 */

module key_control (
    input  logic clk,
    input  logic reset_b,
    input  logic one_key,
    input  logic any_key,
    output logic key_valid
);

    logic any_key_prev;
    logic fresh;

    // any_key is already synchronous (it comes from the debounced bus), so
    // no extra synchronizer is needed here -- just the edge detector.
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) any_key_prev <= 1'b0;
        else          any_key_prev <= any_key;

    assign fresh     = any_key && !any_key_prev;
    assign key_valid = fresh && one_key;

endmodule
