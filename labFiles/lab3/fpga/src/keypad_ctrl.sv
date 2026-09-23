/*
 * Module: keypad_ctrl
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/22/26
 * Parameters:
 *   SCAN_DIV   - clock cycles each row is driven (passed to scanner.DIV).
 *   SCAN_DIV_W - bits needed to count to SCAN_DIV (passed to scanner.DIV_W).
 *   TICK_W     - debounce time base; the stable time is 2**TICK_W cycles.
 *   SYNC_DEPTH - depth of the column synchronizer, so rows_aligned matches it.
 */

module keypad_ctrl #(
    parameter int SCAN_DIV   = 320_000,
    parameter int SCAN_DIV_W = 19,
    parameter int TICK_W     = 19,
    parameter int SYNC_DEPTH = 2,     // flops in the column synchronizer
) (
    input  logic       clk,
    input  logic       reset_b,
    input  logic       any_key,   
    input  logic       one_key,   
    input  logic       key_new,   
    output logic [3:0] rows,      
    output logic [3:0] rows_aligned,
    output logic       capture      
);

    typedef enum logic [3:0] {SCAN  = 4'b0001,
                              PRESS = 4'b0010,
                              HOLD  = 4'b0100,
                              MULTI = 4'b1000} statetype;
    statetype state, nextstate;

    logic       tick, key_down, single_key;
    logic       scan_en;
    logic [3:0] scan_rows;
    logic [3:0] rows_low;                 
    logic [3:0] rows_dly [SYNC_DEPTH];

    // debounce time
    tick_gen #(.TICK_W(TICK_W)) u_tick_gen (
        .clk(clk), .reset_b(reset_b), .tick(tick));

    debouncer u_any_debounce (.clk(clk), .reset_b(reset_b), .tick(tick), .sw(any_key), .debounced_sw(key_down));

    debouncer u_one_debounce (.clk(clk), .reset_b(reset_b), .tick(tick), .sw(one_key), .debounced_sw(single_key));

    assign scan_en = (state == SCAN) & ~any_key;

    scanner #(.DIV(SCAN_DIV), .DIV_W(SCAN_DIV_W)) u_scanner (.clk(clk), .reset_b(reset_b), .enable(scan_en), .rows(scan_rows));

    // row pattern
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) rows_low <= 4'b1110;
        else          rows_low <= ~scan_rows;

    // row pattern delayed
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b)
            for (int i = 0; i < SYNC_DEPTH; i++) rows_dly[i] <= 4'b1110;
        else begin
            rows_dly[0] <= rows_low;
            for (int i = 1; i < SYNC_DEPTH; i++) rows_dly[i] <= rows_dly[i-1];
        end

    assign rows_aligned = rows_dly[SYNC_DEPTH-1];

    // controller state register
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) state <= SCAN;
        else          state <= nextstate;

    // controller: next state logic
    always_comb
        case (state)
            SCAN:    nextstate = single_key ? PRESS : SCAN;
            PRESS:   nextstate = HOLD;
            HOLD:    if      (!key_down)   nextstate = SCAN;
                     else if (!single_key) nextstate = MULTI;
                     else                  nextstate = HOLD;
            MULTI:   if      (!key_down)              nextstate = SCAN;
                     else if (single_key &  key_new)  nextstate = PRESS;
                     else                             nextstate = MULTI;
            default: nextstate = SCAN;
        endcase

    // controller output logic
    assign capture = (state == PRESS);

endmodule