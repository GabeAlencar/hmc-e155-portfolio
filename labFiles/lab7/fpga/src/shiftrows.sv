/*
 * Module: shiftrows
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * ShiftRows
 * Cyclically shift row r of the state left by r bytes
 * Section 5.1.2, Figure 8
 * Purely combinational
 */

module shiftrows (
    input  logic [127:0] a,
    output logic [127:0] y
);

    logic [0:3][0:3][7:0] s, t;

    input_to_state u_in (.a(a), .y(s));

    always_comb
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                t[r][c] = s[r][(c + r) % 4];

    state_to_output u_out (.a(t), .y(y));

endmodule
