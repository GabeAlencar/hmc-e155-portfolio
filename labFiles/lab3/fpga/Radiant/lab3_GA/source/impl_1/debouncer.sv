/*
 * Module: debouncer
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
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
    output logic [WIDTH-1:0] q,
    output logic             stable,
    output logic             updated
);

    typedef enum logic [1:0] {IDLE, WAIT, PRESSED} statetype;
    statetype state, nextstate;

    logic [WIDTH-1:0]  candidate;
    logic [WAIT_W-1:0] counter;

    // state register
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) state <= IDLE;
        else          state <= nextstate;

    // candidate register: latched the instant IDLE sees a nonzero d
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) candidate <= '0;
        else if (state == IDLE && d != '0) candidate <= d;

    // The FSM owns the counter: cleared in IDLE, running everywhere else.
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b)            counter <= '0;
        else if (state == IDLE)  counter <= '0;
        else                     counter <= counter + 1'b1;

    always_comb
        case (state)
            IDLE:    nextstate = (d != '0) ? WAIT : IDLE;
            WAIT:    if (d != candidate)          nextstate = IDLE;
// a bounce
                     else if (counter[WAIT_W-1])  nextstate = PRESSED;
                     else                         nextstate = WAIT;
            PRESSED: nextstate = (d == candidate) ? PRESSED : IDLE;
            default: nextstate = IDLE;
        endcase

    assign stable = (state == PRESSED);

    // q latches candidate, and updated pulses for one cycle, exactly when
    // WAIT is about to become PRESSED -- i.e. exactly when a reading is
    // accepted. q is cleared in IDLE (release) so that re-pressing the same
    // key after a full lift-off is seen as different from the stale q and
    // still pulses updated, rather than silently comparing equal forever.
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            q       <= '0;
            updated <= 1'b0;
        end else begin
            updated <= 1'b0;
            if (state == IDLE) begin
                q <= '0;
            end else if (state == WAIT && nextstate == PRESSED) begin
                updated <= (q != candidate);
                q       <= candidate;
            end
        end

endmodule