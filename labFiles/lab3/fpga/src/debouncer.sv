/*
 * Module: debouncer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/22/26
 */

module debouncer (
    input  logic clk,
    input  logic reset_b,
    input  logic tick,          // time base from tick_gen
    input  logic sw,            // raw, already synchronized
    output logic debounced_sw
);

    typedef enum logic [2:0] {IDLE = 3'b001, WAIT = 3'b010, PRESSED = 3'b100} statetype;
    statetype state, nextstate;

    // ---- state register ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) state <= IDLE;
        else          state <= nextstate;

    // ---- next state logic ----
    always_comb
        case (state)
            IDLE:    nextstate = (sw & tick) ? WAIT : IDLE;
            WAIT:    if      (!sw)  nextstate = IDLE;      // it was a bounce
                     else if (tick) nextstate = PRESSED;
                     else           nextstate = WAIT;
            PRESSED: nextstate = sw ? PRESSED : IDLE;
            default: nextstate = IDLE;
        endcase

    // ---- output logic (Moore; one-hot, so this is a wire) ----
    assign debounced_sw = (state == PRESSED);

endmodule