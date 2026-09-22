`timescale 1 ns/1 ns

/*
 * Testbench: lab3_GA_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Note: cols is driven the way the real keypad wiring presents it: physical,
 * active-low (idle 4'b1111, a key's column bit pulled low while the scanner
 * is driving that key's row (dut.rows), all-1s otherwise). Once any column
 * bit goes low, the design holds the scan on that row until every key in it
 * releases, so press_key below only needs to track dut.rows, not model the
 * freeze itself. Small parameters are used throughout so debounce/scan/mux
 * timing settles in a reasonable number of simulated cycles; margins are
 * kept generous (as in lab2's top-level testbench) rather than cycle-exact,
 * since unit-level testbenches already pin down exact timing per module.
 */

module lab3_GA_tb();
  logic       reset_b;
  logic [3:0] cols;
  logic [3:0] rows;
  logic [6:0] seg;
  logic [1:0] anode_n;

  localparam int SCAN_DIV   = 5;
  localparam int SCAN_DIV_W = 3;
  localparam int WAIT_W     = 4;
  localparam int MUX_W      = 4;

  // one-hot row/col encodings, and the resulting key from key_decoder.sv's
  // map: (row1,col1)=5, (row0,col3)=A, (row2,col2)=9, (row2,col1)=8
  localparam logic [3:0] ROW0 = 4'b0001, ROW1 = 4'b0010, ROW2 = 4'b0100;
  localparam logic [3:0] COL0 = 4'b0001, COL1 = 4'b0010, COL2 = 4'b0100, COL3 = 4'b1000;

  lab3_GA #(
      .SCAN_DIV(SCAN_DIV),
      .SCAN_DIV_W(SCAN_DIV_W),
      .WAIT_W(WAIT_W),
      .MUX_W(MUX_W)
  ) dut (
      .reset_b(reset_b),
      .cols(cols),
      .rows(rows),
      .seg(seg),
      .anode_n(anode_n)
  );

  // drive cols as a physical key at (target_row, col_bit) would: pulled low
  // only while the scanner is on that row, all-1s (idle) otherwise
  task automatic press_key(input logic [3:0] target_row, input logic [3:0] col_bit, input int cycles);
    repeat (cycles) begin
      @(posedge dut.clk);
      #1 cols = (dut.rows == target_row) ? ~col_bit : 4'b1111;
    end
  endtask

  // same as press_key, but bounces the column asynchronously (off-edge,
  // sub-cycle timing) several times before settling on a clean closure --
  // exercises the spec's requirement to test switch bounce at async
  // positions relative to the system clock
  task automatic bounce_key(input logic [3:0] target_row, input logic [3:0] col_bit, input int settle_cycles);
    while (dut.rows !== target_row) @(posedge dut.clk);
    repeat (4) begin
      cols = ~col_bit; #3;
      cols = 4'b1111; #2;
    end
    cols = ~col_bit;
    repeat (settle_cycles) @(posedge dut.clk);
  endtask

  // check that the HSOSC instantiated inside the DUT produces a clock
  initial begin
    @(posedge dut.clk);
    $display("PASSED! The HSOSC produces a clock at time: %0t.", $time);
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset clears both digits immediately; rows is all-off for one
    // harmless cycle (matches every other register's all-zero reset value,
    // rather than depending on the FPGA's power-on state agreeing with a
    // nonzero init), then self-corrects to row 0 on the first clock edge
    reset_b = 0;
    cols    = 4'b1111;
    #22 reset_b = 1;
    #1;
    assert (rows == 4'b0000 && dut.digit_left == 4'h0 && dut.digit_right == 4'h0)
      $display("PASSED! lab3_GA resets cleanly, rows all-off for one cycle, digits clear at time: %0t.", $time);
    else
      $error("FAILED! lab3_GA fails to reset correctly at time: %0t.", $time);

    @(posedge dut.clk);
    #1;
    assert (rows == 4'b0001)
      $display("PASSED! rows self-corrects to row 0 on the first clock edge at time: %0t.", $time);
    else
      $error("FAILED! rows fails to reach row 0 after the first clock edge at time: %0t.", $time);

    // test 2: a single, clean key press registers into digit_right
    press_key(ROW1, COL1, 40);  // key '5'
    #1;
    assert (dut.digit_right == 4'h5 && dut.digit_left == 4'h0)
      $display("PASSED! A single key press registers key 5 at time: %0t.", $time);
    else
      $error("FAILED! A single key press fails to register key 5 at time: %0t.", $time);

    // test 3: releasing and pressing a different key shifts the digits,
    // demonstrating the display shows the last two hex digits pressed.
    // Release is now debounced symmetrically with press, so switching
    // directly to a new key takes roughly two debounce windows (one to
    // confirm the old key's release, one to confirm the new key) --
    // generous margin here accordingly
    cols = 4'b1111;
    repeat (30) @(posedge dut.clk);
    press_key(ROW0, COL3, 40);  // key 'A'
    #1;
    assert (dut.digit_right == 4'hA && dut.digit_left == 4'h5)
      $display("PASSED! A second key press shifts digits to show A then 5 at time: %0t.", $time);
    else
      $error("FAILED! A second key press fails to shift the digits correctly at time: %0t.", $time);

    // test 4: a bouncy key press (asynchronous, sub-cycle transitions
    // before settling) still registers exactly once, with no misfire
    cols = 4'b1111;
    repeat (30) @(posedge dut.clk);
    bounce_key(ROW2, COL2, 40);  // key '9', bounced before settling
    #1;
    assert (dut.digit_right == 4'h9 && dut.digit_left == 4'hA)
      $display("PASSED! A bouncy key press still registers cleanly as key 9 at time: %0t.", $time);
    else
      $error("FAILED! A bouncy key press fails to register correctly at time: %0t.", $time);

    // test 5: while key '9' (col2) is still held, a second key in the same
    // row (col1, key '8') is added -- only the first press may register,
    // so the display must not change
    repeat (2) begin
      @(posedge dut.clk);
      #1 cols = (dut.rows == ROW2) ? ~(COL1 | COL2) : 4'b1111;
    end
    repeat (30) begin
      @(posedge dut.clk);
      #1 cols = (dut.rows == ROW2) ? ~(COL1 | COL2) : cols;
    end
    assert (dut.digit_right == 4'h9 && dut.digit_left == 4'hA)
      $display("PASSED! Adding a second held key does not disturb the display at time: %0t.", $time);
    else
      $error("FAILED! Adding a second held key incorrectly changed the display at time: %0t.", $time);
    // also confirm the scan is frozen on the held row the whole time
    assert (rows == ROW2)
      $display("PASSED! The scan stays parked on the row with keys held at time: %0t.", $time);
    else
      $error("FAILED! The scan fails to stay parked while keys are held at time: %0t.", $time);

    // test 6: releasing key '9' but keeping key '8' held rolls off to the
    // last remaining key, updating the display to show it
    repeat (30) begin
      @(posedge dut.clk);
      #1 cols = (dut.rows == ROW2) ? ~COL1 : 4'b1111;
    end
    assert (dut.digit_right == 4'h8 && dut.digit_left == 4'h9)
      $display("PASSED! Releasing to one remaining key rolls the display over to key 8 at time: %0t.", $time);
    else
      $error("FAILED! Releasing to one remaining key fails to roll the display over at time: %0t.", $time);

    // test 7: releasing all keys resumes normal scanning (rows advances
    // through the keypad again instead of staying parked)
    cols = 4'b1111;
    repeat (5) @(posedge dut.clk);
    begin
      logic [3:0] rows_a, rows_b;
      rows_a = rows;
      repeat (SCAN_DIV * 4) @(posedge dut.clk);
      rows_b = rows;
      assert (rows_a != rows_b || rows_b != ROW2)
        $display("PASSED! The scan resumes advancing once all keys are released at time: %0t.", $time);
      else
        $error("FAILED! The scan fails to resume advancing after release at time: %0t.", $time);
    end

    #100 $stop;
  end
endmodule
