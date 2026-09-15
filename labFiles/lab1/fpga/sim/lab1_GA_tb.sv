`timescale 1 ns/1 ns

/*
 * Testbench: lab1_GA_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module lab1_GA_tb();
  logic [3:0] s;    // 4-bit input switches
  logic [2:0] led;  // 3 output leds
  logic [6:0] seg;  // seven-segment display, active low

  lab1_GA dut (
      .s(s),
      .led(led),
      .seg(seg)
  );

  // check that the HSOSC instantiated inside the DUT produces a clock
  initial begin
    fork
      begin
        @(posedge dut.clk);
        $display("PASSED! The HSOSC produces a clock at time: %0t.", $time);
      end
      begin
        #1000;
        $error("FAILED! The HSOSC produces no clock by time: %0t.", $time);
      end
    join_any
    disable fork;
  end

  // apply stimuli and check outputs
  initial begin
    #50;  // let the oscillator start up before the first check

    // test 1: s[1:0] = 00 -> led[0] = 0, s[3:2] = 00 -> led[1] = 0
    s = 4'b0000;
    #10;
    assert (led[1:0] == 2'b00)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // the decoder is wired up and shows 0 for s = 0000
    assert (seg == 7'b1000000)
      $display("PASSED! The decoder is wired correctly at time: %0t.", $time);
    else
      $error("FAILED! The decoder is wired incorrectly at time: %0t.", $time);

    // test 2: s[1:0] = 01 -> led[0] = 1
    s = 4'b0001;
    #10;
    assert (led[0] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // test 3: s[1:0] = 10 -> led[0] = 1
    s = 4'b0010;
    #10;
    assert (led[0] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // test 4: s[3:2] = 11 -> led[1] = 1, and the display shows C
    s = 4'b1100;
    #10;
    assert (led[1] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    assert (seg == 7'b1000110)
      $display("PASSED! The decoder is wired correctly at time: %0t.", $time);
    else
      $error("FAILED! The decoder is wired incorrectly at time: %0t.", $time);

    // test 5: s = 1111 -> led[0] = 0 (XOR), led[1] = 1 (AND)
    s = 4'b1111;
    #10;
    assert (led[1:0] == 2'b10)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    #100 $stop;
  end
endmodule
