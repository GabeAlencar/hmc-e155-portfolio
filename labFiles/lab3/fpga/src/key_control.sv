/*
 * Module: key_control
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Note: this used to be an IDLE/SINGLE/MULTI FSM, but any_key dropping (the
 * only way to ever get a second fresh event) always forces a return to
 * IDLE first -- see debouncer.sv, whose q is 0 whenever it isn't currently
 * PRESSED. That made "fresh" reachable only from IDLE, so the SINGLE/MULTI
 * branches of both case statements were dead code; a valid press is just
 * "a freshly confirmed reading with exactly one key down."
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

    // any_key is already the debounced bus's validity flag (see
    // lab3_GA.sv/debouncer.sv); fresh is the one-cycle pulse the edge it
    // rises, marking the exact moment a new reading is confirmed
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) any_key_prev <= 1'b0;
        else          any_key_prev <= any_key;

    assign fresh = any_key && !any_key_prev;

    assign key_valid = fresh && one_key;

endmodule
