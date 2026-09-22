`timescale 1 ns/1 ns

/*
 * Testbench: key_decoder_tb
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   9/21/26
 */

module key_decoder_tb();
  logic [3:0] rows;
  logic [3:0] cols;
  logic [3:0] key;
  logic       one_key;
  logic       any_key;

  // full 4x4 key map, indexed by {row_index, col_index}
  logic [3:0] expected_key [0:15];

  key_decoder dut (
      .rows(rows),
      .cols(cols),
      .key(key),
      .one_key(one_key),
      .any_key(any_key)
  );

  initial begin
    expected_key[4'b00_00] = 4'h1;
    expected_key[4'b00_01] = 4'h2;
    expected_key[4'b00_10] = 4'h3;
    expected_key[4'b00_11] = 4'hA;
    expected_key[4'b01_00] = 4'h4;
    expected_key[4'b01_01] = 4'h5;
    expected_key[4'b01_10] = 4'h6;
    expected_key[4'b01_11] = 4'hB;
    expected_key[4'b10_00] = 4'h7;
    expected_key[4'b10_01] = 4'h8;
    expected_key[4'b10_10] = 4'h9;
    expected_key[4'b10_11] = 4'hC;
    expected_key[4'b11_00] = 4'hE;
    expected_key[4'b11_01] = 4'h0;
    expected_key[4'b11_10] = 4'hF;
    expected_key[4'b11_11] = 4'hD;
  end

  // apply stimuli and check outputs
  initial begin
    // test 1: no columns asserted -> no key, any_key and one_key both low
    rows = 4'b0001;
    cols = 4'b0000;
    #5;
    assert (any_key == 0 && one_key == 0)
      $display("PASSED! No column asserted yields any_key/one_key low at time: %0t.", $time);
    else
      $error("FAILED! any_key/one_key incorrect with no column asserted at time: %0t.", $time);

    // test 2: exhaustively check every one-hot row/col combination decodes
    // to the correct key, and that one_key/any_key are both asserted
    for (int r = 0; r < 4; r++) begin
      for (int c = 0; c < 4; c++) begin
        rows = 4'b0001 << r;
        cols = 4'b0001 << c;
        #5;
        assert (key == expected_key[{r[1:0], c[1:0]}] && any_key == 1 && one_key == 1)
          $display("PASSED! row %0d, col %0d decodes to key %h at time: %0t.", r, c, key, $time);
        else
          $error("FAILED! row %0d, col %0d decodes to %h, expected %h at time: %0t.",
                 r, c, key, expected_key[{r[1:0], c[1:0]}], $time);
      end
    end

    // test 3: multiple columns asserted at once (simulating two keys held
    // in the same row) -> any_key high, but one_key must go low
    rows = 4'b0010;
    cols = 4'b0011;
    #5;
    assert (any_key == 1 && one_key == 0)
      $display("PASSED! Multiple columns asserted correctly deassert one_key at time: %0t.", $time);
    else
      $error("FAILED! one_key fails to deassert with multiple columns asserted at time: %0t.", $time);

    // test 4: all four columns asserted at once behaves the same way
    cols = 4'b1111;
    #5;
    assert (any_key == 1 && one_key == 0)
      $display("PASSED! All columns asserted correctly deassert one_key at time: %0t.", $time);
    else
      $error("FAILED! one_key fails to deassert with all columns asserted at time: %0t.", $time);

    #100 $stop;
  end
endmodule
