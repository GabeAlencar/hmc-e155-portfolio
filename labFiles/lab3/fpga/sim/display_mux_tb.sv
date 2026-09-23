`timescale 1 ns/1 ns

/*
 * Testbench: display_mux_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
 */

module display_mux_tb();
  logic       clk;
  logic       reset_b;
  logic [3:0] digit_left;
  logic [3:0] digit_right;
  logic [6:0] seg;
  logic [1:0] anode_n;
  logic [6:0] seg_table [16];
  int         left_cycles;
  int         right_cycles;
  int         bad_anode;
  int         errors;

  localparam int MUX_W = 3;
  localparam int HALF  = 2**(MUX_W-1);   // clock cycles each digit is lit

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
    // active-low segment patterns {g,f,e,d,c,b,a}
    seg_table = '{7'b1000000, 7'b1111001, 7'b0100100, 7'b0110000,
                  7'b0011001, 7'b0010010, 7'b0000010, 7'b1111000,
                  7'b0000000, 7'b0010000, 7'b0001000, 7'b0000011,
                  7'b1000110, 7'b0100001, 7'b0000110, 7'b0001110};

    // test 1: the left digit is selected out of reset and decoded correctly
    reset_b = 0;
    digit_left = 4'h3;
    digit_right = 4'hC;
    #22;
    assert (anode_n == 2'b10 && seg == seg_table[4'h3])
      $display("PASSED! The left digit is lit and decoded out of reset at time: %0t.", $time);
    else
      $error("FAILED! The left digit is wrong out of reset at time: %0t.", $time);

    // test 2: the mux switches to the right digit after HALF cycles
    @(negedge clk);
    reset_b = 1;
    repeat (HALF) @(posedge clk);
    #1;
    assert (anode_n == 2'b01 && seg == seg_table[4'hC])
      $display("PASSED! The right digit is lit and decoded after HALF cycles at time: %0t.", $time);
    else
      $error("FAILED! The right digit is wrong after HALF cycles at time: %0t.", $time);

    // test 3: the mux wraps back to the left digit after a full period
    repeat (HALF) @(posedge clk);
    #1;
    assert (anode_n == 2'b10 && seg == seg_table[4'h3])
      $display("PASSED! The mux wraps back to the left digit at time: %0t.", $time);
    else
      $error("FAILED! The mux fails to wrap to the left digit at time: %0t.", $time);

    // test 4: every hex value on both digits reaches the segments through the right anode
    errors = 0;
    for (int h = 0; h < 16; h++) begin
      digit_left = h;
      digit_right = 15 - h;
      #1;
      if (seg !== seg_table[h]) errors++;
      repeat (HALF) @(posedge clk);
      #1;
      if (anode_n !== 2'b01 || seg !== seg_table[15 - h]) errors++;
      repeat (HALF) @(posedge clk);
      #1;
    end
    assert (errors == 0)
      $display("PASSED! All 16 hex values display on both digits at time: %0t.", $time);
    else
      $error("FAILED! %0d digit/value pairs displayed incorrectly at time: %0t.", errors, $time);

    // test 5: exactly one digit is lit every cycle, for equal time (equal brightness)
    left_cycles = 0;
    right_cycles = 0;
    bad_anode = 0;
    repeat (8 * 2 * HALF) begin
      @(posedge clk);
      #1;
      if (anode_n == 2'b10)      left_cycles++;
      else if (anode_n == 2'b01) right_cycles++;
      else                       bad_anode++;
    end
    assert (bad_anode == 0 && left_cycles == right_cycles)
      $display("PASSED! Both digits are lit for equal time, never together at time: %0t.", $time);
    else
      $error("FAILED! Duty cycle is %0d/%0d with %0d bad cycles at time: %0t.", left_cycles, right_cycles, bad_anode, $time);

    // test 6: changing a digit's value mid-slot updates the segments right away
    wait (anode_n == 2'b10);
    #2 digit_left = 4'hE;
    #1;
    assert (seg == seg_table[4'hE])
      $display("PASSED! A new value appears on the lit digit immediately at time: %0t.", $time);
    else
      $error("FAILED! A new value is not shown on the lit digit at time: %0t.", $time);

    // test 7: reset while running returns to the left digit
    wait (anode_n == 2'b01);
    #2 reset_b = 0;
    #1;
    assert (anode_n == 2'b10)
      $display("PASSED! The mux resets to the left digit while running at time: %0t.", $time);
    else
      $error("FAILED! The mux fails to reset while running at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
