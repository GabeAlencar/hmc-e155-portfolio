`timescale 1 ns/1 ns

/*
 * Testbench: tick_gen_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
 */

module tick_gen_tb();
  logic clk;
  logic reset_b;
  logic tick;
  int   ticks;
  int   high_cycles;

  localparam int TICK_W = 4;
  localparam int PERIOD = 2**TICK_W;

  tick_gen #(.TICK_W(TICK_W)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .tick(tick)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset holds tick low
    reset_b = 0;
    #22;
    assert (tick == 1'b0)
      $display("PASSED! The tick is low in reset at time: %0t.", $time);
    else
      $error("FAILED! The tick is high in reset at time: %0t.", $time);

    // test 2: the first tick arrives on the last count, PERIOD-1 edges out of reset
    @(negedge clk);
    reset_b = 1;
    repeat (PERIOD - 2) @(posedge clk);
    #1;
    assert (tick == 1'b0)
      $display("PASSED! The tick stays low before the period ends at time: %0t.", $time);
    else
      $error("FAILED! The tick fires early at time: %0t.", $time);
    @(posedge clk);
    #1;
    assert (tick == 1'b1)
      $display("PASSED! The tick fires at the end of the period at time: %0t.", $time);
    else
      $error("FAILED! The tick fails to fire at the end of the period at time: %0t.", $time);

    // test 3: the tick is exactly one clock cycle wide
    @(posedge clk);
    #1;
    assert (tick == 1'b0)
      $display("PASSED! The tick is one cycle wide at time: %0t.", $time);
    else
      $error("FAILED! The tick is wider than one cycle at time: %0t.", $time);

    // test 4: over 4 more periods there is exactly 1 tick per period
    ticks = 0;
    high_cycles = 0;
    repeat (4 * PERIOD) begin
      @(posedge clk);
      #1;
      if (tick) ticks++;
    end
    assert (ticks == 4)
      $display("PASSED! The tick fires once every 2**TICK_W cycles at time: %0t.", $time);
    else
      $error("FAILED! The tick fired %0d times in 4 periods at time: %0t.", ticks, $time);

    // test 5: reset while running restarts the period
    reset_b = 0;
    #12;
    reset_b = 1;
    ticks = 0;
    repeat (PERIOD - 2) begin
      @(posedge clk);
      #1;
      if (tick) ticks++;
    end
    assert (ticks == 0)
      $display("PASSED! Reset restarts the tick period at time: %0t.", $time);
    else
      $error("FAILED! Reset fails to restart the tick period at time: %0t.", $time);

    #100 $stop;
  end
endmodule
