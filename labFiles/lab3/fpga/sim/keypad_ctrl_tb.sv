`timescale 1 ns/1 ns

/*
 * Testbench: keypad_ctrl_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/23/26
 */

module keypad_ctrl_tb();
  logic       clk;
  logic       reset_b;
  logic       any_key;
  logic       one_key;
  logic       key_new;
  logic [3:0] rows;
  logic [3:0] rows_aligned;
  logic       capture;

  logic       held5, held8;   // which physical keys are currently down
  logic [3:0] key;
  logic [3:0] d0;             // stand-in for digit_reg's d0
  int         capture_count;

  localparam logic [3:0] ROW1 = 4'b1101;  // "5"'s row
  localparam logic [3:0] ROW2 = 4'b1011;  // "8"'s row

  localparam int SCAN_DIV   = 8;    // cycles per row, shrunk for simulation
  localparam int SCAN_DIV_W = 4;
  localparam int SWEEP      = 4 * SCAN_DIV;

  keypad_ctrl #(.SCAN_DIV(SCAN_DIV), .SCAN_DIV_W(SCAN_DIV_W)) dut (
      .clk(clk),
      .reset_b(reset_b),
      .any_key(any_key),
      .one_key(one_key),
      .key_new(key_new),
      .rows(rows),
      .rows_aligned(rows_aligned),
      .capture(capture)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // ---- stand-in for key_decoder: only the row currently being driven can
  // ever show a key down, exactly like the real column-pulled-low matrix ----
  always_comb begin
    any_key = (rows_aligned == ROW1 && held5) || (rows_aligned == ROW2 && held8);
    one_key = any_key;   // only one key is ever held per row in this test
    key     = (rows_aligned == ROW1 && held5) ? 4'h5 :
              (rows_aligned == ROW2 && held8) ? 4'h8 : 4'h0;
  end

  // ---- stand-in for digit_reg: latches key on capture ----
  always_ff @(posedge clk, negedge reset_b)
    if (!reset_b) d0 <= 4'h0;
    else if (capture) d0 <= key;

  assign key_new = (key != d0);

  // count every cycle capture is asserted (a single-cycle pulse each time)
  always @(posedge clk) if (capture) capture_count++;

  // apply stimuli and check outputs
  initial begin
    // test 1: reset holds capture low and clears the row bitmap
    reset_b = 0;
    held5   = 0;
    held8   = 0;
    #22 reset_b = 1;
    assert (capture == 0 && dut.seen == 4'b0000)
      $display("PASSED! keypad_ctrl resets with capture low and no rows seen at time: %0t.", $time);
    else
      $error("FAILED! keypad_ctrl fails to reset cleanly at time: %0t.", $time);

    // test 2: an ordinary single press ("8" alone) still works
    capture_count = 0;
    held8 = 1;
    repeat (6 * SWEEP) @(posedge clk);
    #1;
    assert (capture_count == 1 && d0 == 4'h8)
      $display("PASSED! A single key press ('8') captures exactly once at time: %0t.", $time);
    else
      $error("FAILED! Expected exactly one capture of '8', got %0d captures, d0=%h at time: %0t.",
             capture_count, d0, $time);

    // test 3: release '8', back to nothing held, before starting the real
    // multi-row scenario from a clean slate
    held8 = 0;
    repeat (2 * SWEEP) @(posedge clk);

    // test 4: '8' (row 2) and '5' (row 1) are pressed at the same time --
    // a scanner that freezes on whichever row it reaches first would
    // capture one of them almost immediately without ever noticing the
    // other. The display must NOT update at all while both are held,
    // however many sweeps go by.
    capture_count = 0;
    held5 = 1;
    held8 = 1;
    repeat (8 * SWEEP) @(posedge clk);
    #1;
    assert (capture_count == 0)
      $display("PASSED! Holding '8' and '5' on different rows together never captures, at time: %0t.", $time);
    else
      $error("FAILED! Holding '8' and '5' on different rows incorrectly captured %0d time(s) at time: %0t.",
             capture_count, $time);

    // test 5: '8' is released, leaving only '5' (row 1) held. The scan must
    // notice only one row is active now and register '5' as the valid
    // press -- exactly one capture, and it's the key that's still down.
    capture_count = 0;
    held8 = 0;
    repeat (8 * SWEEP) @(posedge clk);
    #1;
    assert (capture_count == 1 && d0 == 4'h5)
      $display("PASSED! Releasing '8' and leaving '5' held registers '5' as the valid press at time: %0t.", $time);
    else
      $error("FAILED! Releasing '8' down to '5' held captured %0d time(s), d0=%h (expected 1, 5) at time: %0t.",
             capture_count, d0, $time);

    // test 6: releasing '5' too settles back to nothing seen, no more
    // captures
    capture_count = 0;
    held5 = 0;
    repeat (4 * SWEEP) @(posedge clk);
    #1;
    assert (capture_count == 0 && dut.seen == 4'b0000)
      $display("PASSED! Releasing the last held key produces no further captures at time: %0t.", $time);
    else
      $error("FAILED! Releasing the last held key misbehaved: %0d captures, seen=%b at time: %0t.",
             capture_count, dut.seen, $time);

    #100 $stop;
  end
endmodule
