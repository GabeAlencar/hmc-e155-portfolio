/*
 * Module: scanner
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 * Parameters:
 *   DIV   - clock cycles each row stays active.
 *   DIV_W - number of bits needed to count to DIV.
 */

module scanner #(
    parameter int DIV   = 6_000_000,
    parameter int DIV_W = 23
) (
    input  logic       clk,
    input  logic       reset_b,
    input  logic       enable,
    output logic [3:0] rows
);
    localparam int TOTAL_W = DIV_W + 2;

    logic [TOTAL_W-1:0] count;
    logic [3:0]         rows_raw;

    // counter
    counter #(.WIDTH(TOTAL_W), .MAX(4 * DIV - 1)) u_scan_ctr (.clk(clk), .reset_b(reset_b), .enable(enable), .count(count));

    // row decoder
    assign rows_raw = (count < DIV)     ? 4'b0001 :
                       (count < 2 * DIV) ? 4'b0010 :
                       (count < 3 * DIV) ? 4'b0100 :
                                           4'b1000;

    // register the decode here so rows is glitch-free -- Lecture 05's
    // keypad-scanner requirement "all outputs are registered". Reset to
    // all-zero (not 4'b0001) so this matches every other register's reset
    // value in the design and doesn't depend on the FPGA's power-on state
    // agreeing with a nonzero init value -- count is already 0 out of
    // reset, so rows self-corrects to 4'b0001 on the very next cycle
    // regardless, at the cost of one harmless all-off startup cycle.
    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) rows <= 4'b0000;
        else          rows <= rows_raw;

endmodule
