`timescale 1 ns/1 ns

/*
 * Testbench: synchronizer_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module synchronizer_tb();
  logic       clk;
  logic       reset_b;
  logic [3:0] d;
  logic [3:0] q;

  localparam int WIDTH = 4;

  synchronizer #(.WIDTH(WIDTH)) dut (
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
    // test 1: reset drives both flop stages, and q, to 0
    reset_b = 0;
    d       = 4'b0000;
    #22 reset_b = 1;
    #1;
    assert (q == 4'b0000 && dut.n1 == 4'b0000)
      $display("PASSED! The synchronizer resets both stages to 0 at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer fails to reset at time: %0t.", $time);

    // test 2: d asserted asynchronously, off the clock edge, still only
    // reaches n1 on the next rising edge
    #3 d = 4'b1010;
    @(posedge clk);
    #1;
    assert (dut.n1 == 4'b1010 && q == 4'b0000)
      $display("PASSED! The first stage captures d after one edge, q still lags at time: %0t.", $time);
    else
      $error("FAILED! The first stage fails to capture d correctly at time: %0t.", $time);

    // test 3: q reflects d only after a second rising edge (2-cycle latency)
    @(posedge clk);
    #1;
    assert (q == 4'b1010)
      $display("PASSED! q reflects d after two clock edges at time: %0t.", $time);
    else
      $error("FAILED! q fails to reflect d after two edges at time: %0t.", $time);

    // test 4: each bit of a multi-bit bus propagates independently with the
    // same 2-cycle latency
    #2 d = 4'b0101;
    @(posedge clk);
    #1;
    assert (dut.n1 == 4'b0101 && q == 4'b1010)
      $display("PASSED! Bits propagate independently through stage one at time: %0t.", $time);
    else
      $error("FAILED! Bits fail to propagate correctly through stage one at time: %0t.", $time);

    @(posedge clk);
    #1;
    assert (q == 4'b0101)
      $display("PASSED! Bits propagate independently through to q at time: %0t.", $time);
    else
      $error("FAILED! Bits fail to propagate correctly to q at time: %0t.", $time);

    // test 5: reset works mid-propagation, clearing both stages immediately
    #2 d = 4'b1111;
    @(posedge clk);
    reset_b = 0;
    #12;
    assert (q == 4'b0000 && dut.n1 == 4'b0000)
      $display("PASSED! The synchronizer resets mid-propagation at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer fails to reset mid-propagation at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
