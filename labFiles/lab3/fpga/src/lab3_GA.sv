/*
 * Module: lab3_GA
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/22/26
 * Parameters:
 *   SCAN_DIV   - clock cycles each keypad row is driven.
 *   SCAN_DIV_W - bits needed to count to SCAN_DIV.
 *   MUX_W      - display multiplexing counter width.
 */

module lab3_GA #(
    parameter int SCAN_DIV   = 320_000,
    parameter int SCAN_DIV_W = 19,
    parameter int MUX_W      = 17
) (
    input  logic       reset_b,
    input  logic [3:0] cols,
    output logic [3:0] rows,
    output logic [6:0] seg,
    output logic [1:0] anode_n
);

    logic       clk;
    logic [3:0] cols_sync, rows_aligned;
    logic       any_key, one_key, key_new, capture;
    logic [3:0] key, d0, d1;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // col sync
    synchronizer #(.WIDTH(4)) u_col_sync (.clk(clk), .reset_b(reset_b), .d(cols), .q(cols_sync));

    key_decoder u_key_decoder (.rows(rows_aligned), .cols(cols_sync), .key(key), .one_key(one_key), .any_key(any_key));

    assign key_new = (key != d0);

    // keypad controller
    keypad_ctrl #(.SCAN_DIV(SCAN_DIV), .SCAN_DIV_W(SCAN_DIV_W)) u_keypad_ctrl (.clk(clk), .reset_b(reset_b), .any_key(any_key), .one_key(one_key), .key_new(key_new), .rows(rows), .rows_aligned(rows_aligned), .capture(capture));

    // digit shift register
    digit_reg u_digit_reg (.clk(clk), .reset_b(reset_b), .enable(capture), .key(key), .d0(d0), .d1(d1));

    // display multiplexing and seven-segment decodej
    display_mux #(.MUX_W(MUX_W)) u_display_mux (.clk(clk), .reset_b(reset_b), .digit_left(d1), .digit_right(d0), .seg(seg), .anode_n(anode_n));

endmodule