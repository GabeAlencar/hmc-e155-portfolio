/*
 * Module: digit_reg
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module digit_reg (
    input  logic       clk,
    input  logic       reset_b,
    input  logic       enable,
    input  logic [3:0] key,
    output logic [3:0] digit_left,
    output logic [3:0] digit_right
);

    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            digit_left  <= 4'h0;
            digit_right <= 4'h0;
        end else if (enable) begin
            digit_left  <= digit_right;
            digit_right <= key;
        end

endmodule
