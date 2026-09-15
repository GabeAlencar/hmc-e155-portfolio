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
  @(posedge dut.clk);
  $display("PASSED! The HSOSC produces a clock at time: %0t.", $time);
  end

  // apply stimuli and check outputs
  initial begin
    #50; 

    // the decoder is wired up and shows 0 for s = 0000
    assert (seg == 7'b1000000)
      $display("PASSED! The decoder is wired correctly at time: %0t.", $time);
    else
      $error("FAILED! The decoder is wired incorrectly at time: %0t.", $time);

    // test 1: 0000 -> led[1] & led [0] = 0
    s = 4'b0000;
    #10;
    assert (led[1:0] == 2'b00)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);
    
    // test 2: 0001 -> led[0] = 1
    s = 4'b0001;
    #10;
    assert (led[0] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // test 3: 0010 -> led[0] = 1
    s = 4'b0010;
    #10;
    assert (led[0] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // test 4: 1100 -> led[1] = 1
    s = 4'b1100;
    #10;
    assert (led[1] == 1'b1)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    // test 5: 1111 -> led[0] = 0 led[1] = 1
    s = 4'b1111;
    #10;
    assert (led[1:0] == 2'b10)
      $display("PASSED! The led logic behaves as desired at time: %0t.", $time);
    else
      $error("FAILED! The led logic behaves incorrectly at time: %0t.", $time);

    #100 $stop;
  end
endmodule
