`timescale 1 ns/1 ns

/*
 * Testbench: counter_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module counter_tb();
  logic clk;    // system clock
  logic reset;  // active high reset
  logic en;     // count enable
  logic blink;  // toggles each time the counter wraps

  counter #(.WIDTH(4), .MAX(9)) dut (
      .clk(clk),
      .reset(reset),
      .en(en),
      .blink(blink)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset drives blink low
    reset = 1;
    en = 0;
    #22 reset = 0;
    assert (blink == 1'b0)
      $display("PASSED! The counter resets as desired at time: %0t.", $time);
    else
      $error("FAILED! The counter resets incorrectly at time: %0t.", $time);

    // test 2: with en low, the counter holds and blink never toggles
    repeat (15) @(posedge clk);
    #1;
    assert (blink == 1'b0)
      $display("PASSED! The counter holds while disabled at time: %0t.", $time);
    else
      $error("FAILED! The counter counts while disabled at time: %0t.", $time);

    // test 3: with en high, blink toggles after MAX+1 = 10 counts
    en = 1;
    repeat (10) @(posedge clk);
    #1;
    assert (blink == 1'b1)
      $display("PASSED! The counter wraps and toggles at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to wrap/toggle at time: %0t.", $time);

    // test 4: it wraps again on the next 10 counts, toggling back
    repeat (10) @(posedge clk);
    #1;
    assert (blink == 1'b0)
      $display("PASSED! The counter wraps a second time at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to wrap a second time at time: %0t.", $time);

    // test 5: disabling mid-count holds blink steady again
    en = 0;
    repeat (15) @(posedge clk);
    #1;
    assert (blink == 1'b0)
      $display("PASSED! The counter stops when disabled at time: %0t.", $time);
    else
      $error("FAILED! The counter keeps counting when disabled at time: %0t.", $time);

    // test 6: reset works even after the counter has been running
    en = 1;
    repeat (3) @(posedge clk);
    reset = 1;
    #12;
    assert (blink == 1'b0)
      $display("PASSED! The counter resets while running at time: %0t.", $time);
    else
      $error("FAILED! The counter fails to reset while running at time: %0t.", $time);
    reset = 0;

    #100 $stop;
  end
endmodule
