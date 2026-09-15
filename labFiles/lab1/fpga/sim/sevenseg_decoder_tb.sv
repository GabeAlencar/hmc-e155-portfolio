`timescale 1 ns/1 ns

/*
 * Testbench: sevenseg_decoder_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/8/26
 */

module sevenseg_decoder_tb();
  logic [3:0] s;    // 4-bit hex input
  logic [6:0] seg;  // active-low segment drive

  sevenseg_decoder dut (
      .s(s),
      .seg(seg)
  );

  // apply stimuli and check outputs
  initial begin
    // 0
    s = 4'h0;
    #10;
    assert (seg == 7'b1000000)
      $display("PASSED! The decoder displays 0 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 0 incorrectly at time: %0t.", $time);

    // 1
    s = 4'h1;
    #10;
    assert (seg == 7'b1111001)
      $display("PASSED! The decoder displays 1 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 1 incorrectly at time: %0t.", $time);

    // 2
    s = 4'h2;
    #10;
    assert (seg == 7'b0100100)
      $display("PASSED! The decoder displays 2 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 2 incorrectly at time: %0t.", $time);

    // 3
    s = 4'h3;
    #10;
    assert (seg == 7'b0110000)
      $display("PASSED! The decoder displays 3 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 3 incorrectly at time: %0t.", $time);

    // 4
    s = 4'h4;
    #10;
    assert (seg == 7'b0011001)
      $display("PASSED! The decoder displays 4 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 4 incorrectly at time: %0t.", $time);

    // 5
    s = 4'h5;
    #10;
    assert (seg == 7'b0010010)
      $display("PASSED! The decoder displays 5 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 5 incorrectly at time: %0t.", $time);

    // 6
    s = 4'h6;
    #10;
    assert (seg == 7'b0000010)
      $display("PASSED! The decoder displays 6 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 6 incorrectly at time: %0t.", $time);

    // 7
    s = 4'h7;
    #10;
    assert (seg == 7'b1111000)
      $display("PASSED! The decoder displays 7 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 7 incorrectly at time: %0t.", $time);

    // 8
    s = 4'h8;
    #10;
    assert (seg == 7'b0000000)
      $display("PASSED! The decoder displays 8 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 8 incorrectly at time: %0t.", $time);

    // 9
    s = 4'h9;
    #10;
    assert (seg == 7'b0010000)
      $display("PASSED! The decoder displays 9 as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays 9 incorrectly at time: %0t.", $time);

    // A
    s = 4'hA;
    #10;
    assert (seg == 7'b0001000)
      $display("PASSED! The decoder displays A as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays A incorrectly at time: %0t.", $time);

    // b
    s = 4'hB;
    #10;
    assert (seg == 7'b0000011)
      $display("PASSED! The decoder displays b as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays b incorrectly at time: %0t.", $time);

    // C
    s = 4'hC;
    #10;
    assert (seg == 7'b1000110)
      $display("PASSED! The decoder displays C as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays C incorrectly at time: %0t.", $time);

    // d
    s = 4'hD;
    #10;
    assert (seg == 7'b0100001)
      $display("PASSED! The decoder displays d as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays d incorrectly at time: %0t.", $time);

    // E
    s = 4'hE;
    #10;
    assert (seg == 7'b0000110)
      $display("PASSED! The decoder displays E as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays E incorrectly at time: %0t.", $time);

    // F
    s = 4'hF;
    #10;
    assert (seg == 7'b0001110)
      $display("PASSED! The decoder displays F as desired at time: %0t.", $time);
    else
      $error("FAILED! The decoder displays F incorrectly at time: %0t.", $time);

    #100 $stop;
  end
endmodule
