/*
 * Module: sevenseg_decoder
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module sevenseg_decoder (
    input  logic [3:0] s,
    output logic [6:0] seg
);
    logic [6:0] seg_ah;

    always_comb begin
        case (s)
            4'h0:    seg_ah = 7'h3F;  // 0
            4'h1:    seg_ah = 7'h06;  // 1
            4'h2:    seg_ah = 7'h5B;  // 2
            4'h3:    seg_ah = 7'h4F;  // 3
            4'h4:    seg_ah = 7'h66;  // 4
            4'h5:    seg_ah = 7'h6D;  // 5
            4'h6:    seg_ah = 7'h7D;  // 6
            4'h7:    seg_ah = 7'h07;  // 7
            4'h8:    seg_ah = 7'h7F;  // 8
            4'h9:    seg_ah = 7'h6F;  // 9
            4'hA:    seg_ah = 7'h77;  // A
            4'hB:    seg_ah = 7'h7C;  // b
            4'hC:    seg_ah = 7'h39;  // C
            4'hD:    seg_ah = 7'h5E;  // d
            4'hE:    seg_ah = 7'h79;  // E
            4'hF:    seg_ah = 7'h71;  // F
            default: seg_ah = 7'h00;  // all off
        endcase
    end

    // invert so a 0 turns the segment on.
    assign seg = ~seg_ah;

endmodule