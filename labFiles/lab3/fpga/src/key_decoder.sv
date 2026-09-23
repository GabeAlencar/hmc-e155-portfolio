/*
 * Module: key_decoder
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/17/26
 */

module key_decoder (
    input  logic [3:0] rows,
    input  logic [3:0] cols,
    output logic [3:0] key,
    output logic       one_key,
    output logic       any_key
);

    logic [1:0] row_index, col_index;

    // any column pulled low means a key in this row is down
    assign any_key = ~&cols;

    // which row is being driven low
    always_comb
        case (rows)
            4'b1110: row_index = 2'd0;
            4'b1101: row_index = 2'd1;
            4'b1011: row_index = 2'd2;
            4'b0111: row_index = 2'd3;
            default: row_index = 2'd0;
        endcase

    // which single column is pulled low, if exactly one is
    always_comb
        case (cols)
            4'b1110: begin col_index = 2'd0; one_key = 1'b1; end
            4'b1101: begin col_index = 2'd1; one_key = 1'b1; end
            4'b1011: begin col_index = 2'd2; one_key = 1'b1; end
            4'b0111: begin col_index = 2'd3; one_key = 1'b1; end
            default: begin col_index = 2'd0; one_key = 1'b0; end
        endcase

    // row and column to hex value
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
            4'b11_00: key = 4'hE;
            4'b11_01: key = 4'h0;
            4'b11_10: key = 4'hF;
            4'b11_11: key = 4'hD;
            default:  key = 4'h0;
        endcase

endmodule