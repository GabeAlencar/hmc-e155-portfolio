`timescale 1 ns/1 ns

/*
 * Testbench: scanner_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 */

module scanner_tb();
  logic       clk;
  logic       reset_b; 
  logic       enable;
  logic [3:0] rows;
  logic [3:0] prev_rows;

  localparam int DIV   = 5;
  localparam int DIV_W = 3;

  scanner #(.DIV(DIV), .DIV_W(DIV_W)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .enable(enable),
      .rows(rows)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset drives rows to the first row
    reset_b = 0;
    enable = 0;
    #22 reset_b = 1;
    assert (rows == 4'b0001)
      $display("PASSED! The scanner resets to row 0 as desired at time: %0t.", $time);
    else
      $error("FAILED! The scanner resets incorrectly at time: %0t.", $time);

    // test 2: with enable low, the scanner holds on row 0
    repeat (15) @(posedge clk);
    #1;
    assert (rows == 4'b0001)
      $display("PASSED! The scanner holds while disabled at time: %0t.", $time);
    else
      $error("FAILED! The scanner scans while disabled at time: %0t.", $time);

    // test 3: with enable high, the scanner advances to row 1 after DIV cycles
    enable = 1;
    repeat (DIV) @(posedge clk);
    #1;
    assert (rows == 4'b0010)
      $display("PASSED! The scanner advances to row 1 at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to advance to row 1 at time: %0t.", $time);

    // test 4: the scanner advances to row 2 after another DIV cycles
    repeat (DIV) @(posedge clk);
    #1;
    assert (rows == 4'b0100)
      $display("PASSED! The scanner advances to row 2 at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to advance to row 2 at time: %0t.", $time);

    // test 5: the scanner advances to row 3 after another DIV cycles
    repeat (DIV) @(posedge clk);
    #1;
    assert (rows == 4'b1000)
      $display("PASSED! The scanner advances to row 3 at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to advance to row 3 at time: %0t.", $time);

    // test 6: the scanner wraps back to row 0 after another DIV cycles
    repeat (DIV) @(posedge clk);
    #1;
    assert (rows == 4'b0001)
      $display("PASSED! The scanner wraps back to row 0 at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to wrap at time: %0t.", $time);

    // test 7: disabling mid-scan holds the row steady
    prev_rows = rows;
    repeat (2) @(posedge clk);
    #1;
    enable = 0;
    repeat (DIV) @(posedge clk);
    #1;
    assert (rows == prev_rows)
      $display("PASSED! The scanner stops when disabled at time: %0t.", $time);
    else
      $error("FAILED! The scanner keeps scanning when disabled at time: %0t.", $time);

    // test 8: reset works even after the scanner has been running
    enable = 1;
    repeat (DIV + 2) @(posedge clk);
    reset_b = 0;
    #12;
    assert (rows == 4'b0001)
      $display("PASSED! The scanner resets while running at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to reset while running at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
