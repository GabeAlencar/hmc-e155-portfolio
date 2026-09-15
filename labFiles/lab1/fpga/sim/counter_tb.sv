`timescale 1 ns/1 ns

/*
 * Testbench: counter_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module counter_tb();
  logic       clk;      
  logic       reset_b;
  logic       enable; 
  logic [3:0] count;  

  counter #(.WIDTH(4), .MAX(9)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .enable(enable),
      .count(count)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset drives count to 0
    reset_b = 1;
    enable = 0;
    #22 reset_b = 0;
    assert (count == 4'd0)
      $display("PASSED! The counter resets as desired at time: %0t.", $time);
    else
      $error("FAILED! The counter resets incorrectly at time: %0t.", $time);

    // test 2: with enable low, the counter holds at 0
    repeat (15) @(posedge clk);
    #1;
    assert (count == 4'd0)
      $display("PASSED! The counter holds while disabled at time: %0t.", $time);
    else
      $error("FAILED! The counter counts while disabled at time: %0t.", $time);

    // test 3: with enable high, the counter counts up
    enable = 1;
    repeat (5) @(posedge clk);
    #1;
    assert (count == 4'd5)
      $display("PASSED! The counter counts up at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to count up at time: %0t.", $time);

    // test 4: the counter wraps to 0 after reaching MAX
    repeat (5) @(posedge clk);
    #1;
    assert (count == 4'd0)
      $display("PASSED! The counter wraps at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to wrap at time: %0t.", $time);

    // test 5: disabling mid-count holds the count steady
    repeat (3) @(posedge clk);
    #1;
    enable = 0;
    repeat (10) @(posedge clk);
    #1;
    assert (count == 4'd3)
      $display("PASSED! The counter stops when disabled at time: %0t.", $time);
    else
      $error("FAILED! The counter keeps counting when disabled at time: %0t.", $time);

    // test 6: reset works even after the counter has been running
    enable = 1;
    repeat (2) @(posedge clk);
    reset_b = 1;
    #12;
    assert (count == 4'd0)
      $display("PASSED! The counter resets while running at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to reset while running at time: %0t.", $time);
    reset_b = 0;

    #100 $stop;
  end
endmodule
