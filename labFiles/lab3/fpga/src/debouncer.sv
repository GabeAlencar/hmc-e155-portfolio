/*
 * Module: debouncer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Parameters:
 *   WIDTH  - number of column bits being debounced together.
 *   WAIT_W - counter width; a n1 must hold for 2**(WAIT_W-1) cycles.
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

    typedef enum logic [1:0] {IDLE, WAIT, PRESSED, RELEASING} statetype;
    statetype state, nextstate;

    logic [WIDTH-1:0]  n1;
    logic [WAIT_W-1:0] counter;
    logic              clear, done;

    // ---- the conversation between the two machines ----
    // clear covers both rest states (IDLE, PRESSED) so the counter always
    // starts fresh whenever a new confirmation window (WAIT or RELEASING)
    // begins
    assign clear = (state == IDLE) || (state == PRESSED);
    assign done  = counter[WAIT_W-1];

    // ---- machine 1: the controller (canonical) ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            state <= IDLE;
            n1    <= '0;
        end else begin
            state <= nextstate;
            if (state == IDLE && d != '0) n1 <= d;
        end

    // ---- machine 2: the counter (non-canonical) ----
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b)   counter <= '0;
        else if (clear) counter <= '0;
        else            counter <= counter + 1'b1;

    // next state
    always_comb
        case (state)
            IDLE:      nextstate = (d != '0) ? WAIT : IDLE;
            WAIT:      if (d != n1)   nextstate = IDLE;       // a press-side bounce
                       else if (done) nextstate = PRESSED;
                       else           nextstate = WAIT;
            PRESSED:   nextstate = (d != n1) ? RELEASING : PRESSED;
            RELEASING: if (d == n1)   nextstate = PRESSED;    // a release-side bounce
                       else if (done) nextstate = IDLE;
                       else           nextstate = RELEASING;
            default:   nextstate = IDLE;
        endcase

    // q holds through RELEASING too, so a release-bounce that snaps back to
    // the same candidate never drops q to 0 and back up -- that drop/rise
    // is exactly what looked like a second press to key_control
    assign q = (state == PRESSED || state == RELEASING) ? n1 : '0;

endmodule
