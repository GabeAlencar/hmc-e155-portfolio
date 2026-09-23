`timescale 1 ns/1 ns

/*
 * Testbench: synchronizer_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
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
    // test 1: reset clears both flops even with the input high
    reset_b = 0;
    d = 4'b1111;
    #22;
    assert (q == 4'b0000)
      $display("PASSED! The synchronizer resets to 0 as desired at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer resets incorrectly at time: %0t.", $time);
    reset_b = 1;

    // test 2: an input change is not seen after only one clock edge
    @(negedge clk);
    d = 4'b1110;
    @(posedge clk);
    #1;
    assert (q == 4'b1111)
      $display("PASSED! The synchronizer has not passed the new value after 1 cycle at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer passed the new value too early at time: %0t.", $time);

    // test 3: the input reaches the output after the second clock edge
    @(posedge clk);
    #1;
    assert (q == 4'b1110)
      $display("PASSED! The synchronizer passes the input after 2 cycles at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer fails to pass the input after 2 cycles at time: %0t.", $time);

    // test 4: an input that changes asynchronously, just after a clock edge,
    // still shows up two edges later with every bit intact
    @(posedge clk);
    #3 d = 4'b0101;
    repeat (2) @(posedge clk);
    #1;
    assert (q == 4'b0101)
      $display("PASSED! The synchronizer passes an asynchronous change at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer drops an asynchronous change at time: %0t.", $time);

    // test 5: an asynchronous change just before a clock edge is also passed
    @(posedge clk);
    #8 d = 4'b1011;
    repeat (2) @(posedge clk);
    #1;
    assert (q == 4'b1011)
      $display("PASSED! The synchronizer passes a late asynchronous change at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer drops a late asynchronous change at time: %0t.", $time);

    // test 6: reset works while the synchronizer is running
    reset_b = 0;
    #1;
    assert (q == 4'b0000)
      $display("PASSED! The synchronizer resets while running at time: %0t.", $time);
    else
      $error("FAILED! The synchronizer fails to reset while running at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
