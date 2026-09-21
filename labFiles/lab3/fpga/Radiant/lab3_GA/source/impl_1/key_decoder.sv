/*
 * Module: key_decoder
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module key_decoder (
    input  logic [3:0] rows,
    input  logic [3:0] cols,
    output logic [3:0] key,
    output logic       one_key,
    output logic       any_key
);

    logic [1:0] row_index, col_index;

    assign any_key = |cols;
    // exactly one bit set: cols is nonzero and cols & (cols-1) clears the lone bit
    assign one_key = any_key && ((cols & (cols - 4'b1)) == 4'b0000);

    always_comb
        case (rows)
            4'b0001: row_index = 2'd0;
            4'b0010: row_index = 2'd1;
            4'b0100: row_index = 2'd2;
            4'b1000: row_index = 2'd3;
            default: row_index = 2'd0;
        endcase

    always_comb
        case (cols)
            4'b0001: col_index = 2'd0;
            4'b0010: col_index = 2'd1;
            4'b0100: col_index = 2'd2;
            4'b1000: col_index = 2'd3;
            default: col_index = 2'd0;
        endcase

    always_comb
        case ({row_index, col_index})
            4'b00_00: key = 4'h1;
            4'b00_01: key = 4'h2;
            4'b00_10: key = 4'h3;
            4'b00_11: key = 4'hA;
            4'b01_00: key = 4'h4;
            4'b01_01: key = 4'h5;
            4'b01_10: key = 4'h6;
            4'b01_11: key = 4'hB;
            4'b10_00: key = 4'h7;
            4'b10_01: key = 4'h8;
            4'b10_10: key = 4'h9;
            4'b10_11: key = 4'hC;
            4'b11_00: key = 4'hE;  // '*'
            4'b11_01: key = 4'h0;
            4'b11_10: key = 4'hF;  // '#'
            4'b11_11: key = 4'hD;
            default:  key = 4'h0;
        endcase

endmodule
