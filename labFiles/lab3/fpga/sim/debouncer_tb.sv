`timescale 1 ns/1 ns

/*
 * Testbench: debouncer_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
 */

module debouncer_tb();
  logic clk;
  logic reset_b;
  logic tick;
  logic sw;
  logic debounced_sw;
  logic prev_debounced_sw;
  int   rises;
  int   tick_count;

  localparam int TICK_PERIOD = 8;   // clock cycles between ticks

  // debouncer one-hot state encodings
  localparam logic [2:0] IDLE    = 3'b001;
  localparam logic [2:0] WAIT    = 3'b010;
  localparam logic [2:0] PRESSED = 3'b100;

  debouncer dut (
      .clk(clk),
      .reset_b(reset_b),
      .tick(tick),
      .sw(sw),
      .debounced_sw(debounced_sw)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // stand-in for tick_gen: a one-cycle strobe every TICK_PERIOD cycles
  always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) begin
      tick_count <= 0;
      tick       <= 1'b0;
    end else begin
      tick_count <= (tick_count == TICK_PERIOD - 1) ? 0 : tick_count + 1;
      tick       <= (tick_count == TICK_PERIOD - 2);
    end

  // count every rising edge of the debounced output
  always @(posedge clk) begin
    prev_debounced_sw <= debounced_sw;
    if (debounced_sw && !prev_debounced_sw) rises++;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset holds the output low
    reset_b = 0;
    sw = 0;
    rises = 0;
    #22 reset_b = 1;
    assert (debounced_sw == 1'b0)
      $display("PASSED! The debouncer resets to IDLE at time: %0t.", $time);
    else
      $error("FAILED! The debouncer resets incorrectly at time: %0t.", $time);

    // test 2: a short glitch between ticks never leaves IDLE
    @(posedge tick);
    @(posedge clk);
    #3 sw = 1;
    #20 sw = 0;
    repeat (2 * TICK_PERIOD) @(posedge clk);
    #1;
    assert (debounced_sw == 1'b0 && dut.state == IDLE)
      $display("PASSED! The debouncer ignores a glitch between ticks at time: %0t.", $time);
    else
      $error("FAILED! The debouncer reacts to a glitch between ticks at time: %0t.", $time);

    // test 3: high across one tick moves to WAIT, dropping before the next tick is a bounce
    @(negedge tick);
    #7 sw = 1;
    @(posedge tick);
    @(posedge clk);
    #1;
    assert (dut.state == WAIT && debounced_sw == 1'b0)
      $display("PASSED! The debouncer moves to WAIT on a tick with the input high at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to move to WAIT at time: %0t.", $time);
    #13 sw = 0;
    @(posedge clk);
    #1;
    assert (dut.state == IDLE && debounced_sw == 1'b0)
      $display("PASSED! The debouncer returns to IDLE on a bounce in WAIT at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to reject a bounce in WAIT at time: %0t.", $time);

    // test 4: holding the input high across two ticks gives a debounced press
    repeat (3) @(posedge clk);
    #4 sw = 1;
    repeat (2 * TICK_PERIOD + 1) @(posedge clk);
    #1;
    assert (debounced_sw == 1'b1)
      $display("PASSED! The debouncer reports a press held across two ticks at time: %0t.", $time);
    else
      $error("FAILED! The debouncer misses a press held across two ticks at time: %0t.", $time);

    // test 5: the output stays high for as long as the input is held
    repeat (5 * TICK_PERIOD) @(posedge clk);
    #1;
    assert (debounced_sw == 1'b1)
      $display("PASSED! The debouncer holds while the input is held at time: %0t.", $time);
    else
      $error("FAILED! The debouncer drops while the input is held at time: %0t.", $time);

    // test 6: releasing the input clears the output on the next edge
    #2 sw = 0;
    @(posedge clk);
    #1;
    assert (debounced_sw == 1'b0)
      $display("PASSED! The debouncer releases immediately at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to release at time: %0t.", $time);

    // test 7: a bouncy press at asynchronous times still gives exactly one press
    repeat (3 * TICK_PERIOD) @(posedge clk);
    rises = 0;
    repeat (12) begin
      #($urandom_range(3, 17)) sw = ~sw;
    end
    sw = 1;
    repeat (4 * TICK_PERIOD) @(posedge clk);
    // then a bouncy release
    repeat (11) begin
      #($urandom_range(3, 17)) sw = ~sw;
    end
    sw = 0;
    repeat (4 * TICK_PERIOD) @(posedge clk);
    #1;
    assert (rises == 1 && debounced_sw == 1'b0)
      $display("PASSED! A bouncy press registers exactly once at time: %0t.", $time);
    else
      $error("FAILED! A bouncy press registered %0d times at time: %0t.", rises, $time);

    // test 8: reset works while the output is high
    sw = 1;
    repeat (3 * TICK_PERIOD) @(posedge clk);
    reset_b = 0;
    #1;
    assert (debounced_sw == 1'b0)
      $display("PASSED! The debouncer resets while pressed at time: %0t.", $time);
    else
      $error("FAILED! The debouncer fails to reset while pressed at time: %0t.", $time);
    reset_b = 1;

    #100 $stop;
  end
endmodule
