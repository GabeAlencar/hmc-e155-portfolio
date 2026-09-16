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

    // single counter spans all 4 rows so no second counter is needed
    localparam int TOTAL_W = DIV_W + 2;

    logic [TOTAL_W-1:0] count;

    // scan counter
    counter #(.WIDTH(TOTAL_W), .MAX(4 * DIV - 1)) u_scan_ctr (.clk(clk), .reset_b(reset_b), .enable(enable), .count(count));

    // row decoder: pick the active row straight from the raw count
    assign rows = (count < DIV)     ? 4'b0001 :
                  (count < 2 * DIV) ? 4'b0010 :
                  (count < 3 * DIV) ? 4'b0100 :
                                      4'b1000;

endmodule