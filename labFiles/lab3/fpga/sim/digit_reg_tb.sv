`timescale 1 ns/1 ns

/*
 * Testbench: digit_reg_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module digit_reg_tb();
  logic       clk;
  logic       reset_b;
  logic       enable;
  logic [3:0] key;
  logic [3:0] digit_left;
  logic [3:0] digit_right;

  digit_reg dut (
      .clk(clk),
      .reset_b(reset_b),
      .enable(enable),
      .key(key),
      .digit_left(digit_left),
      .digit_right(digit_right)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset drives both digits to 0
    reset_b = 0;
    enable  = 0;
    key     = 4'h0;
    #22 reset_b = 1;
    #1;
    assert (digit_left == 4'h0 && digit_right == 4'h0)
      $display("PASSED! digit_reg resets both digits to 0 at time: %0t.", $time);
    else
      $error("FAILED! digit_reg fails to reset at time: %0t.", $time);

    // test 2: with enable low, new keys are ignored
    key = 4'hA;
    repeat (3) @(posedge clk);
    #1;
    assert (digit_left == 4'h0 && digit_right == 4'h0)
      $display("PASSED! digit_reg holds while disabled at time: %0t.", $time);
    else
      $error("FAILED! digit_reg updates while disabled at time: %0t.", $time);

    // test 3: enabling for one cycle shifts key into digit_right, and the
    // old digit_right (0) into digit_left
    enable = 1;
    key    = 4'h5;
    @(posedge clk);
    #1;
    assert (digit_right == 4'h5 && digit_left == 4'h0)
      $display("PASSED! digit_reg shifts the first key into digit_right at time: %0t.", $time);
    else
      $error("FAILED! digit_reg fails to shift the first key correctly at time: %0t.", $time);
    enable = 0;

    // test 4: a second key press shifts the previous digit_right into
    // digit_left, and the new key into digit_right
    enable = 1;
    key    = 4'hC;
    @(posedge clk);
    #1;
    assert (digit_right == 4'hC && digit_left == 4'h5)
      $display("PASSED! digit_reg shifts the second key through both digits at time: %0t.", $time);
    else
      $error("FAILED! digit_reg fails to shift the second key correctly at time: %0t.", $time);
    enable = 0;

    // test 5: with enable low again, the digits hold despite key changing
    key = 4'h9;
    repeat (3) @(posedge clk);
    #1;
    assert (digit_right == 4'hC && digit_left == 4'h5)
      $display("PASSED! digit_reg holds the last two digits while disabled at time: %0t.", $time);
    else
      $error("FAILED! digit_reg fails to hold while disabled at time: %0t.", $time);

    // test 6: reset works even after digits have been loaded
    reset_b = 0;
    #12;
    assert (digit_left == 4'h0 && digit_right == 4'h0)
      $display("PASSED! digit_reg resets after holding values at time: %0t.", $time);
    else
      $error("FAILED! digit_reg fails to reset after holding values at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
