/*
 * Module: debouncer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * A canonical controller (IDLE/WAIT/PRESSED) paired with a non-canonical
 * counter -- the two-machine, "communicating FSM" pattern from Lecture 05's
 * switch-debouncer build, generalized from one switch bit to WIDTH bits so
 * it can debounce a whole column bus at once.
 *   - Down (controller -> counter): clear, asserted while IDLE.
 *   - Up   (counter -> controller): done, the counter's top bit, meaning a
 *     candidate reading has now held steady for the full debounce window.
 * Parameters:
 *   WIDTH  - number of column bits being debounced together.
 *   WAIT_W - counter width; a candidate must hold for 2**(WAIT_W-1) cycles.
 */

module debouncer #(
    parameter int WIDTH  = 4,
    parameter int WAIT_W = 20
) (
    input  logic             clk,
    input  logic             reset_b,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    typedef enum logic [1:0] {IDLE, WAIT, PRESSED} statetype;
    statetype state, nextstate;

    logic [WIDTH-1:0]  candidate;
    logic [WAIT_W-1:0] counter;
    logic              clear, done;

    // ---- the conversation between the two machines ----
    assign clear = (state == IDLE);
    assign done  = counter[WAIT_W-1];

    // ---- machine 1: the controller (canonical) ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            state     <= IDLE;
            candidate <= '0;
        end else begin
            state <= nextstate;
            if (state == IDLE && d != '0) candidate <= d;
        end

    // next state
    always_comb
        case (state)
            IDLE:    nextstate = (d != '0) ? WAIT : IDLE;
            WAIT:    if (d != candidate)  nextstate = IDLE;      // a bounce
                     else if (done)       nextstate = PRESSED;
                     else                 nextstate = WAIT;
            PRESSED: nextstate = (d == candidate) ? PRESSED : IDLE;
            default: nextstate = IDLE;
        endcase

    // ---- machine 2: the counter (non-canonical) ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b)   counter <= '0;
        else if (clear) counter <= '0;
        else            counter <= counter + 1'b1;

    assign q = (state == PRESSED) ? candidate : '0;

endmodule
