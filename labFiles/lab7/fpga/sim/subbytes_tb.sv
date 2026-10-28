`timescale 10ns/1ns

/////////////////////////////////////////////
// subbytes_tb
//   Self-checking testbench for subbytes
//   FIPS-197 Appendix B, "Start of Round" -> "After SubBytes" for rounds 1 and 2.
//   The S-boxes are synchronous, so each output is checked one clock after its input.
/////////////////////////////////////////////

module subbytes_tb();
    logic         clk;
    logic [127:0] a, y;
    integer       tests, errors;

    // device under test
    subbytes dut(.clk(clk), .a(a), .y(y));

    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    // apply one test vector and compare against the expected output one clock later
    task check(input string name, input logic [127:0] in, input logic [127:0] expected);
        tests = tests + 1;
        a = in;
        @(posedge clk); #1;
        if (y === expected) $display("PASS  %s", name);
        else begin
            $error("%s\n  in       = %h\n  got      = %h\n  expected = %h", name, in, y, expected);
            errors = errors + 1;
        end
    endtask

    initial begin
        tests = 0; errors = 0;
        #1;
        check("Appendix B round 1", 128'h193de3bea0f4e22b9ac68d2ae9f84808, 128'hd42711aee0bf98f1b8b45de51e415230);
        check("Appendix B round 2", 128'ha49c7ff2689f352b6b5bea43026a5049, 128'h49ded28945db96f17f39871a7702533b);
        check("Appendix B round 3", 128'haa8f5f0361dde3ef82d24ad26832469a, 128'hac73cf7befc111df13b5d6b545235ab8);

        if (errors == 0) $display("PASSED: all %0d tests", tests);
        else             $display("FAILED: %0d of %0d tests", errors, tests);
        $finish;
    end
endmodule
