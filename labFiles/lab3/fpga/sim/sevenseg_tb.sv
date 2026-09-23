// Self-checking testbench using immediate assertions.
// Immediate assertions (assert (...) else ...) run in every open-source simulator.
// Concurrent assertions (assert property (...)) are skipped with a warning by Icarus.
`timescale 1ns/1ps
module sevenseg_tb();
  logic [3:0] s;
  logic [6:0] seg;
  int errors = 0;

  logic [6:0] expected [16] = '{
    7'b1000000, 7'b1111001, 7'b0100100, 7'b0110000,
    7'b0011001, 7'b0010010, 7'b0000010, 7'b1111000,
    7'b0000000, 7'b0010000, 7'b0001000, 7'b0000011,
    7'b1000110, 7'b0100001, 7'b0000110, 7'b0001110
  };

  sevenseg dut(.s(s), .seg(seg));

  initial begin
    for (int i = 0; i < 16; i++) begin
      s = i[3:0];
      #10;
      assert (seg == expected[i])
        $display("PASSED: s=%h seg=%b", s, seg);
      else begin
        errors++;
        $error("FAILED: s=%h seg=%b expected=%b", s, seg, expected[i]);
      end
    end
    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TESTS FAILED", errors);
    $finish;
  end
endmodule
