`timescale 1 ns/1 ns

/*
 * Testbench: debouncer_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Note: with WAIT_W = 3, a candidate must hold steady for 2**(WAIT_W-1) = 4
 * counted cycles, which lands q at the accepted value exactly 6 clock edges
 * after a candidate is first latched out of IDLE (1 edge to enter WAIT and
 * latch the candidate, 4 edges to count up to the threshold, 1 edge to
 * transition into PRESSED). Release is debounced symmetrically now (via
 * RELEASING), so dropping q back to 0 takes the same 6-edge window after d
 * first deviates from the candidate, not just one edge.
 */

module debouncer_tb();
  logic       clk;
  logic       reset_b;
  logic [3:0] d;
  logic [3:0] q;

  localparam int WIDTH  = 4;
  localparam int WAIT_W = 3;
  localparam int SETTLE = 6;

  debouncer #(.WIDTH(WIDTH), .WAIT_W(WAIT_W)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .d(d),
      .q(q)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset drives q to 0
    reset_b = 0;
    d       = 4'b0000;
    #22 reset_b = 1;
    #1;
    assert (q == 4'b0000)
      $display("PASSED! The debouncer resets cleanly at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to reset at time: %0t.", $time);

    // test 2: a steady candidate is accepted after it holds for the full
    // debounce window
    d = 4'b0010;
    repeat (SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b0010)
      $display("PASSED! The debouncer accepts a steady candidate at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to accept a steady candidate at time: %0t.", $time);

    // test 3: releasing now takes the same debounce window as accepting --
    // q must still read the held candidate right up until the window
    // completes, then drop to 0
    d = 4'b0000;
    repeat (SETTLE - 1) @(posedge clk);
    #1;
    assert (q == 4'b0010)
      $display("PASSED! q still holds the candidate mid-release-confirmation at time: %0t.", $time);
    else
      $error("FAILED! q dropped before the release window completed at time: %0t.", $time);

    @(posedge clk);
    #1;
    assert (q == 4'b0000)
      $display("PASSED! q drops to 0 once release is fully confirmed at time: %0t.", $time);
    else
      $error("FAILED! q fails to drop once release is confirmed at time: %0t.", $time);

    // test 4: a press-side bounce (d changes mid-WAIT, before the
    // threshold) restarts debouncing instead of accepting the bounced value
    d = 4'b0100;
    repeat (2) @(posedge clk);
    d = 4'b0000;  // bounce back low before SETTLE cycles have elapsed
    repeat (SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b0000)
      $display("PASSED! A press-side bounce restarts debouncing instead of registering at time: %0t.", $time);
    else
      $error("FAILED! A press-side bounce is incorrectly accepted as a valid press at time: %0t.", $time);

    // test 5: after a press-side bounce, a genuinely steady candidate still
    // settles correctly
    d = 4'b0100;
    repeat (SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b0100)
      $display("PASSED! The debouncer recovers and accepts the next steady candidate at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to recover after a press-side bounce at time: %0t.", $time);

    // test 6: a release-side bounce that snaps back to the same candidate
    // before the release window completes must never drop q -- this is
    // exactly the case that used to look like a second press
    d = 4'b0000;
    repeat (2) @(posedge clk);
    d = 4'b0100;  // bounces back to the same candidate before SETTLE elapses
    repeat (SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b0100)
      $display("PASSED! A release-side bounce back to the same candidate never drops q at time: %0t.", $time);
    else
      $error("FAILED! A release-side bounce incorrectly dropped q at time: %0t.", $time);

    // test 7: a genuinely different candidate pressed while the first is
    // held eventually replaces it, after both a release and a new accept
    // window
    d = 4'b1000;
    repeat (2 * SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b1000)
      $display("PASSED! A genuinely different candidate replaces the held one at time: %0t.", $time);
    else
      $error("FAILED! A different candidate fails to replace the held one at time: %0t.", $time);

    // test 8: q never accepts a value that never settles (re-check across
    // the whole bounce window)
    d = 4'b0000;
    repeat (2 * SETTLE) @(posedge clk);
    #1;
    assert (q == 4'b0000)
      $display("PASSED! q never accepts a value that stays at 0 at time: %0t.", $time);
    else
      $error("FAILED! q incorrectly accepted a non-candidate at time: %0t.", $time);

    #100 $stop;
  end
endmodule
