/*
 * Module: state_to_output
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 */

module state_to_output (
    input  logic [0:3][0:3][7:0] a,
    output logic [127:0]         y
);

    always_comb
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                y[127 - 8*(r + 4*c) -: 8] = a[r][c];

endmodule
