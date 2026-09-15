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

    localparam int WIDTH     = 26;
    localparam int MAX_COUNT = 19_999_999;

    logic                   clk;
    logic                   reset_b;
    logic                   enable;
    logic [WIDTH-1:0]       count;

    assign reset_b = 1'b1;
    assign enable  = 1'b1;

    // clock
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    // seven-segment decoder
    sevenseg_decoder u_sevenseg (.s(s), .seg(seg));

    // counter
    counter #(.WIDTH(WIDTH), .MAX(MAX_COUNT)) u_counter (
        .clk(clk),
        .reset_b(reset_b),
        .enable(enable),
        .count(count)
    );

    // counter-LED logic: led[2] is high for the second half of each count
    // period, giving the same blink effect without a second FSM.
    assign led[2] = count >= MAX_COUNT / 2;

    // switch/LED CL
    assign led[0] = s[1] ^ s[0];
    assign led[1] = s[3] & s[2];

endmodule
