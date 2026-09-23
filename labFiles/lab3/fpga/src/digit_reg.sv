/*
 * Module: digit_reg
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/17/26
 */

module digit_reg (
    input  logic       clk,
    input  logic       reset_b,
    input  logic       enable,
    input  logic [3:0] key,
    output logic [3:0] d0,
    output logic [3:0] d1
);

    always_ff @(posedge clk, negedge reset_b)
        if (!reset_b) begin
            d0 <= 4'h0;
            d1 <= 4'h0;
        end else if (enable) begin
            d1 <= d0;
            d0 <= key;
        end

endmodule