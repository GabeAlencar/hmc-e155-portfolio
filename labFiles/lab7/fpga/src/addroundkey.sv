/*
 * Module: addroundkey
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * AddRoundKey
 * Section 5.1.4, Figure 10
 */

module addroundkey (
    input  logic [127:0] a,
    input  logic [127:0] k,
    output logic [127:0] y
);

    assign y = a ^ k;

endmodule
