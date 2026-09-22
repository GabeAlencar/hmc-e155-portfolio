/*
 * Module: lab3_GA
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/17/26
 * Parameters:
 *   SCAN_DIV   - clock cycles each keypad row is driven; same value used in lab2.
 *   SCAN_DIV_W - bit width for SCAN_DIV; same value used in lab2.
 *   WAIT_W     - debouncer counter width; a reading must hold for 2**(WAIT_W-1)
 *                clock cycles (wall-clock time, independent of SCAN_DIV) to accept.
 *   MUX_W      - width of the display multiplexing counter.
 *
 */

module lab3_GA #(
    parameter int SCAN_DIV   = 6_000_000,
    parameter int SCAN_DIV_W = 23,
    parameter int WAIT_W     = 20,
    parameter int MUX_W      = 17
) (
    input  logic       reset_b,
    input  logic [3:0] cols,
    output logic [3:0] rows,
    output logic [6:0] seg,
    output logic [1:0] anode_n
);

    logic       clk;
    logic [3:0] cols_active_high, cols_sync, cols_stable;
    logic       hold;
    logic       one_key, any_key, key_valid;
    logic [3:0] key, digit_left, digit_right;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // convert to the active-high domain used everywhere downstream *before*
    // synchronizing, so the synchronizer's reset value (0) means "idle" --
    // syncing the raw active-low signal and inverting after would instead
    // read as "every column pressed" for the first couple cycles out of reset.
    assign cols_active_high = ~cols;
    synchronizer #(.WIDTH(4)) u_col_sync (.clk(clk), .reset_b(reset_b), .d(cols_active_high), .q(cols_sync));

    // park the scan on the current row while any key in that row is down
    assign hold = |cols_sync;

    // keypad row scanner (registers its own output internally)
    scanner #(.DIV(SCAN_DIV), .DIV_W(SCAN_DIV_W)) u_scanner (.clk(clk), .reset_b(reset_b), .enable(~hold), .rows(rows));

    // switch debouncing
    debouncer #(.WIDTH(4), .WAIT_W(WAIT_W)) u_debouncer (.clk(clk), .reset_b(reset_b), .d(cols_sync), .q(cols_stable));

    // row/column to hex key
    key_decoder u_key_decoder (.rows(rows), .cols(cols_stable), .key(key), .one_key(one_key), .any_key(any_key));

    // key control
    key_control u_key_control (.clk(clk), .reset_b(reset_b), .one_key(one_key), .any_key(any_key), .key_valid(key_valid));

    // last two digits entered
    digit_reg u_digit_reg (.clk(clk), .reset_b(reset_b), .enable(key_valid), .key(key), .digit_left(digit_left), .digit_right(digit_right));

    // display multiplexing and seven-segment decode
    display_mux #(.MUX_W(MUX_W)) u_display_mux (.clk(clk), .reset_b(reset_b), .digit_left(digit_left), .digit_right(digit_right), .seg(seg), .anode_n(anode_n));

endmodule