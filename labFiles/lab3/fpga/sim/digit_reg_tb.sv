`timescale 1 ns/1 ns

/*
 * Testbench: digit_reg_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
 */

module digit_reg_tb();
  logic       clk;
  logic       reset_b;
  logic       enable;
  logic [3:0] key;
  logic [3:0] d0;
  logic [3:0] d1;

  digit_reg dut (
      .clk(clk),
      .reset_b(reset_b),
      .enable(enable),
      .key(key),
      .d0(d0),
      .d1(d1)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // one-cycle enable pulse, like capture from the keypad controller
  task automatic enter_key(input logic [3:0] k);
    @(negedge clk);
    key = k;
    enable = 1;
    @(negedge clk);
    enable = 0;
  endtask

  // apply stimuli and check outputs
  initial begin
    // test 1: reset clears both digits
    reset_b = 0;
    enable = 0;
    key = 4'h7;
    #22 reset_b = 1;
    assert (d0 == 4'h0 && d1 == 4'h0)
      $display("PASSED! The digit register resets to 00 at time: %0t.", $time);
    else
      $error("FAILED! The digit register resets incorrectly at time: %0t.", $time);

    // test 2: with enable low, a changing key is ignored
    repeat (3) begin
      @(negedge clk);
      key = key + 4'h3;
    end
    #1;
    assert (d0 == 4'h0 && d1 == 4'h0)
      $display("PASSED! The digit register holds while enable is low at time: %0t.", $time);
    else
      $error("FAILED! The digit register loads while enable is low at time: %0t.", $time);

    // test 3: the first key loads into the most recent digit
    enter_key(4'h5);
    assert (d0 == 4'h5 && d1 == 4'h0)
      $display("PASSED! The first key loads into d0 at time: %0t.", $time);
    else
      $error("FAILED! The first key loads incorrectly at time: %0t.", $time);

    // test 4: the second key shifts the first into the older digit
    enter_key(4'hA);
    assert (d0 == 4'hA && d1 == 4'h5)
      $display("PASSED! The second key shifts d0 into d1 at time: %0t.", $time);
    else
      $error("FAILED! The second key shifts incorrectly at time: %0t.", $time);

    // test 5: a third key drops the oldest digit
    enter_key(4'hF);
    assert (d0 == 4'hF && d1 == 4'hA)
      $display("PASSED! The third key drops the oldest digit at time: %0t.", $time);
    else
      $error("FAILED! The third key shifts incorrectly at time: %0t.", $time);

    // test 6: the same key entered twice shows up in both digits
    enter_key(4'hF);
    assert (d0 == 4'hF && d1 == 4'hF)
      $display("PASSED! A repeated key fills both digits at time: %0t.", $time);
    else
      $error("FAILED! A repeated key shifts incorrectly at time: %0t.", $time);

    // test 7: the digits hold after enable drops
    key = 4'h1;
    repeat (5) @(posedge clk);
    #1;
    assert (d0 == 4'hF && d1 == 4'hF)
      $display("PASSED! The digits hold after the enable pulse at time: %0t.", $time);
    else
      $error("FAILED! The digits change after the enable pulse at time: %0t.", $time);

    // test 8: reset clears the digits while running
    reset_b = 0;
    #1;
    assert (d0 == 4'h0 && d1 == 4'h0)
      $display("PASSED! The digit register resets while running at time: %0t.", $time);
    else
      $error("FAILED! The digit register fails to reset while running at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
