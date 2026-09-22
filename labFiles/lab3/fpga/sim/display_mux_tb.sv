`timescale 1 ns/1 ns

/*
 * Testbench: display_mux_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Note: with MUX_W = 3, the internal mux counter wraps every 8 cycles and
 * its MSB (bit 2) flips halfway through, at count 4, so the display should
 * switch digits every 4 clock edges.
 */

module display_mux_tb();
  logic       clk;
  logic       reset_b;
  logic [3:0] digit_left;
  logic [3:0] digit_right;
  logic [6:0] seg;
  logic [1:0] anode_n;

  localparam int MUX_W = 3;

  // active-low seven-segment patterns for digit_left = 8'hA and
  // digit_right = 4'h1, matching sevenseg_decoder's table
  localparam logic [6:0] SEG_A = 7'b0001000;
  localparam logic [6:0] SEG_1 = 7'b1111001;
  localparam logic [6:0] SEG_2 = 7'b0100100;

  display_mux #(.MUX_W(MUX_W)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .digit_left(digit_left),
      .digit_right(digit_right),
      .seg(seg),
      .anode_n(anode_n)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: out of reset, the right digit is selected and correctly
    // decoded
    reset_b     = 0;
    digit_left  = 4'hA;
    digit_right = 4'h1;
    #22 reset_b = 1;
    #1;
    assert (anode_n == 2'b10 && seg == SEG_1)
      $display("PASSED! display_mux selects and decodes the right digit out of reset at time: %0t.", $time);
    else
      $error("FAILED! display_mux fails to select/decode the right digit at time: %0t.", $time);

    // test 2: after half the mux period, the mux switches to the left
    // digit and decodes it correctly
    repeat (4) @(posedge clk);
    #1;
    assert (anode_n == 2'b01 && seg == SEG_A)
      $display("PASSED! display_mux switches to and decodes the left digit at time: %0t.", $time);
    else
      $error("FAILED! display_mux fails to switch/decode the left digit at time: %0t.", $time);

    // test 3: after a full mux period, it wraps back to the right digit
    repeat (4) @(posedge clk);
    #1;
    assert (anode_n == 2'b10 && seg == SEG_1)
      $display("PASSED! display_mux wraps back to the right digit at time: %0t.", $time);
    else
      $error("FAILED! display_mux fails to wrap back to the right digit at time: %0t.", $time);

    // test 4: changing the displayed digit while it is selected updates seg
    // immediately (the decoder is purely combinational, wired correctly)
    digit_right = 4'h2;
    #1;
    assert (anode_n == 2'b10 && seg == SEG_2)
      $display("PASSED! display_mux reflects a changed right digit at time: %0t.", $time);
    else
      $error("FAILED! display_mux fails to reflect a changed right digit at time: %0t.", $time);

    #100 $stop;
  end
endmodule
