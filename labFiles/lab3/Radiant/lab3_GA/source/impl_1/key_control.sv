/*
 * Module: key_control
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module key_control (
    input  logic clk,
    input  logic reset_b,
    input  logic updated,
    input  logic stable,
    input  logic one_key,
    input  logic any_key,
    input  logic key_is_new,
    output logic key_valid
);

    typedef enum logic [2:0] {IDLE = 3'b001, SINGLE = 3'b010, MULTI = 3'b100} statetype;
    statetype state, nextstate;

    logic fresh;  // a newly-confirmed, settled reading is available this cycle

    assign fresh = updated && stable;

    // ---- state register ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) state <= IDLE;
        else          state <= nextstate;

    // ---- next state logic ----
    always_comb begin
        nextstate = state;
        if (fresh)
            case (state)
                IDLE:    nextstate = !any_key ? IDLE   : (one_key ? SINGLE : MULTI);
                SINGLE:  nextstate = !any_key ? IDLE   : (one_key ? SINGLE : MULTI);
                MULTI:   nextstate = !any_key ? IDLE   : (one_key ? SINGLE : MULTI);
                default: nextstate = IDLE;
            endcase
    end

    // ---- output logic (Mealy: key_valid pulses the same cycle the FSM
    //      decides a press should be registered) ----
    always_comb begin
        key_valid = 1'b0;
        if (fresh && one_key)
            case (state)
                IDLE:    key_valid = 1'b1;         // fresh single press
                SINGLE:  key_valid = key_is_new;   // defensive; see header
                MULTI:   key_valid = 1'b1;         // roll-off out of a multi-press
                default: key_valid = 1'b0;
            endcase
    end

endmodule
