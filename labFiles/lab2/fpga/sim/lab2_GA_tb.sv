`timescale 1 ns/1 ns

/*
 * Testbench: lab2_GA_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/13/26
 */

module lab2_GA_tb();
  logic [3:0] s1;      
  logic [3:0] s2;     
  logic [3:0] cols;     
  logic       reset_b; 
  logic [6:0] seg;      
  logic [1:0] anode_n;  
  logic [3:0] rows;    
  logic [3:0] col_led;  
  logic [3:0] prev_rows;

  localparam int MUX_W      = 4;
  localparam int MUX_MAX    = 15;
  localparam int SCAN_DIV   = 5;
  localparam int SCAN_DIV_W = 3;

  lab2_GA #(
      .MUX_W(MUX_W),
      .MUX_MAX(MUX_MAX),
      .SCAN_DIV(SCAN_DIV),
      .SCAN_DIV_W(SCAN_DIV_W)
  ) dut (
      .s1(s1),
      .s2(s2),
      .cols(cols),
      .reset_b(reset_b),
      .seg(seg),
      .anode_n(anode_n),
      .rows(rows),
      .col_led(col_led)
  );

  // check that the HSOSC instantiated inside the DUT produces a clock
  initial begin
  @(posedge dut.clk);
  $display("PASSED! The HSOSC produces a clock at time: %0t.", $time);
  end

  // apply stimuli and check outputs
  initial begin
    // hold reset until stimuli begin
    reset_b = 0;
    s1 = 4'h0;
    s2 = 4'hC;
    cols = 4'b0000;
    #22 reset_b = 1;
    #10;

    // digit 1 is selected out of reset and the decoder is wired correctly
    assert (anode_n == 2'b10)
      $display("PASSED! The anode mux selects digit 1 at time: %0t.", $time);
    else
      $error("FAILED! The anode mux fails to select digit 1 at time: %0t.", $time);
    assert (seg == 7'b1000000)
      $display("PASSED! The decoder is wired correctly for digit 1 at time: %0t.", $time);
    else
      $error("FAILED! The decoder is wired incorrectly for digit 1 at time: %0t.", $time);

    // test 1: the columns are inverted onto the column LEDs
    cols = 4'b0000;
    #10;
    assert (col_led == 4'b1111)
      $display("PASSED! The column LED logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The column LED logic behaves incorrectly at time: %0t.", $time);

    // test 2: the columns are inverted onto the column LEDs
    cols = 4'b1010;
    #10;
    assert (col_led == 4'b0101)
      $display("PASSED! The column LED logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The column LED logic behaves incorrectly at time: %0t.", $time);

    // test 3: the digit mux switches to digit 2 after half the mux count
    repeat (8) @(posedge dut.clk);
    #1;
    assert (anode_n == 2'b01)
      $display("PASSED! The anode mux selects digit 2 at time: %0t.", $time);
    else
      $error("FAILED! The anode mux fails to select digit 2 at time: %0t.", $time);
    assert (seg == 7'b1000000)
      $display("PASSED! The decoder is wired correctly for digit 2 at time: %0t.", $time);
    else
      $error("FAILED! The decoder is wired incorrectly for digit 2 at time: %0t.", $time);

    // test 4: the digit mux wraps back to digit 1 after the mux count wraps
    repeat (8) @(posedge dut.clk);
    #1;
    assert (anode_n == 2'b10)
      $display("PASSED! The anode mux wraps back to digit 1 at time: %0t.", $time);
    else
      $error("FAILED! The anode mux fails to wrap back to digit 1 at time: %0t.", $time);

    // test 5: the row scanner advances by one row after SCAN_DIV cycles
    prev_rows = rows;
    repeat (SCAN_DIV) @(posedge dut.clk);
    #1;
    assert (rows == {prev_rows[2:0], prev_rows[3]})
      $display("PASSED! The scanner advances to the next row at time: %0t.", $time);
    else
      $error("FAILED! The scanner fails to advance to the next row at time: %0t.", $time);

    #100 $stop;
  end
endmodule
