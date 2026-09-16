/*
 * Module: lab2_GA
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 * Parameters:
 *   MUX_W      - number of bits in the multiplexing count register.
 *   MUX_MAX    - multiplexing count value at which the counter wraps back to 0.
 *   SCAN_DIV   - clock cycles each keypad row stays active.
 *   SCAN_DIV_W - number of bits in the scanner prescaler.
 */

module lab2_GA #(
    parameter int MUX_W      = 17,
    parameter int MUX_MAX    = (2**MUX_W) - 1,
    parameter int SCAN_DIV   = 6_000_000,
    parameter int SCAN_DIV_W = 23
	)(
    input  logic [3:0] s1,
    input  logic [3:0] s2,
    input  logic [3:0] cols,
    input  logic       reset_b,
    output logic [6:0] seg,
    output logic [1:0] anode_n,
    output logic [3:0] rows,
    output logic [3:0] col_led
	);

    logic             clk;
    logic [MUX_W-1:0] mux_count;
    logic             digit_sel;
    logic [3:0]       nibble;
	
	assign scan_en = 1'b1;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // multiplexing counter
    counter #(.WIDTH(MUX_W), .MAX(MUX_MAX)) u_mux_counter (.clk(clk), .reset_b(reset_b), .enable(1'b1), .count(mux_count));

    // counter-digit logic
    assign digit_sel = mux_count[MUX_W-1];

    // digit mux for shared decoder
    assign nibble = digit_sel ? ~s2 : s1;

    // seven-segment decoder
    sevenseg_decoder u_sevenseg (.s(nibble), .seg(seg));

    // common-anode
    assign anode_n = {~digit_sel, digit_sel};

    // keypad row scanner
    scanner #(.DIV(SCAN_DIV), .DIV_W(SCAN_DIV_W)) u_scanner (.clk(clk), .reset_b(reset_b), .enable(scan_en), .rows(rows));

    // column/LED CL 
    assign col_led = ~cols;

endmodule
