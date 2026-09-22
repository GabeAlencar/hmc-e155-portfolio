`timescale 1 ns/1 ns

/*
 * Testbench: key_control_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 * Note: key_control has no state register -- it's just an edge detector on
 * any_key (fresh) gated by one_key. any_key/one_key are driven directly
 * here exactly as the real debouncer/key_decoder pipeline would present
 * them: any_key has to drop to 0 for at least one cycle between two
 * distinct confirmed readings, the same way the real debouncer's q does (q
 * is 0 whenever it isn't currently PRESSED). key_valid is combinational, so
 * it is checked right after inputs settle.
 */

module key_control_tb();
  logic clk;
  logic reset_b;
  logic one_key;
  logic any_key;
  logic key_valid;

  key_control dut (
      .clk(clk),
      .reset_b(reset_b),
      .one_key(one_key),
      .any_key(any_key),
      .key_valid(key_valid)
  );

  // generate clock
  always begin
      clk = 0; #5;
      clk = 1; #5;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: reset holds key_valid low
    reset_b = 0;
    one_key = 0;
    any_key = 0;
    #22 reset_b = 1;
    #1;
    assert (key_valid == 0)
      $display("PASSED! key_control resets with key_valid low at time: %0t.", $time);
    else
      $error("FAILED! key_control fails to reset key_valid low at time: %0t.", $time);

    // test 2: a fresh single-key reading registers immediately (combinational)
    one_key = 1;
    any_key = 1;
    #1;
    assert (key_valid == 1)
      $display("PASSED! A fresh single press registers at time: %0t.", $time);
    else
      $error("FAILED! A fresh single press fails to register at time: %0t.", $time);
    @(posedge clk);

    // test 3: holding the same key steady (no edge on any_key) does not
    // re-register -- fresh only pulses once per confirmed reading
    #1;
    assert (key_valid == 0)
      $display("PASSED! key_valid deasserts while a key is simply held at time: %0t.", $time);
    else
      $error("FAILED! key_valid incorrectly stays high while a key is held at time: %0t.", $time);

    // test 4: releasing returns key_valid low
    any_key = 0;
    one_key = 0;
    @(posedge clk);
    #1;
    assert (key_valid == 0)
      $display("PASSED! Releasing the key deasserts key_valid at time: %0t.", $time);
    else
      $error("FAILED! Releasing the key incorrectly asserts key_valid at time: %0t.", $time);

    // test 5: a fresh multi-key reading (one_key low) does not register
    any_key = 1;
    #1;
    assert (key_valid == 0)
      $display("PASSED! A multi-key reading does not register at time: %0t.", $time);
    else
      $error("FAILED! A multi-key reading incorrectly registers at time: %0t.", $time);
    @(posedge clk);

    // test 6: holding multiple keys steady still does not register
    #1;
    assert (key_valid == 0)
      $display("PASSED! A held multi-key reading does not register at time: %0t.", $time);
    else
      $error("FAILED! A held multi-key reading incorrectly registers at time: %0t.", $time);

    // test 7: rolling off to a single key -- any_key drops first (the real
    // debounce gap), then a fresh single-key reading registers
    any_key = 0;
    @(posedge clk);
    #1;
    one_key = 1;
    any_key = 1;
    #1;
    assert (key_valid == 1)
      $display("PASSED! A single key rolling off from a multi-key hold registers at time: %0t.", $time);
    else
      $error("FAILED! Rolling off to a single key fails to register at time: %0t.", $time);

    #100 $stop;
  end
endmodule
