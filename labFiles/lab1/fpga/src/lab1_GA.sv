/*
 * Module: lab1_GA
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module lab1_GA (
    input  logic [3:0] s,
    output logic [2:0] led,
    output logic [6:0] seg
);

    logic clk;
    logic reset;
    logic en;

    assign reset = 1'b0;
    assign en = 1'b1;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // seven-segment decoder
    sevenseg_decoder u_sevenseg (.s(s), .seg(seg));

    // counter
    counter u_counter (.clk(clk), .reset(reset), .en(en), .blink(led[2]));

    // switch/LED CL
    assign led[0] = s[1] ^ s[0];
    assign led[1] = s[3] & s[2];

endmodule
