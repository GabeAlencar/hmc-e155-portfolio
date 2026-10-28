`timescale 10ns/1ns

/////////////////////////////////////////////
// keyexpand_tb
//   Self-checking testbench for keyexpand
//   Steps through all ten round keys of FIPS-197 Appendix A.1.
//   keyexpand uses synchronous S-boxes, so each output is checked one clock
//   after its inputs are applied.
/////////////////////////////////////////////

module keyexpand_tb();
    logic         clk;
    logic [127:0] key, y;
    logic [7:0]   rcon;
    integer       tests, errors, i;

    // round_key[0] to round_key[10], FIPS-197 Appendix A.1 and B
    logic [127:0] round_key [0:10];
    logic [7:0]   rcon_value [0:9];

    // device under test
    keyexpand dut(.clk(clk), .key(key), .rcon(rcon), .y(y));

    always begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end

    initial begin
        round_key[ 0] = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        round_key[ 1] = 128'ha0fafe1788542cb123a339392a6c7605;
        round_key[ 2] = 128'hf2c295f27a96b9435935807a7359f67f;
        round_key[ 3] = 128'h3d80477d4716fe3e1e237e446d7a883b;
        round_key[ 4] = 128'hef44a541a8525b7fb671253bdb0bad00;
        round_key[ 5] = 128'hd4d1c6f87c839d87caf2b8bc11f915bc;
        round_key[ 6] = 128'h6d88a37a110b3efddbf98641ca0093fd;
        round_key[ 7] = 128'h4e54f70e5f5fc9f384a64fb24ea6dc4f;
        round_key[ 8] = 128'head27321b58dbad2312bf5607f8d292f;
        round_key[ 9] = 128'hac7766f319fadc2128d12941575c006e;
        round_key[10] = 128'hd014f9a8c9ee2589e13f0cc8b6630ca6;

        rcon_value[0] = 8'h01; rcon_value[1] = 8'h02; rcon_value[2] = 8'h04; rcon_value[3] = 8'h08;
        rcon_value[4] = 8'h10; rcon_value[5] = 8'h20; rcon_value[6] = 8'h40; rcon_value[7] = 8'h80;
        rcon_value[8] = 8'h1b; rcon_value[9] = 8'h36;
    end

    initial begin
        tests = 0; errors = 0;
        #1;
        for (i = 0; i < 10; i = i + 1) begin
            key  = round_key[i];
            rcon = rcon_value[i];
            @(posedge clk); #1;             // S-box output is valid after the next edge
            tests = tests + 1;
            if (y === round_key[i + 1]) $display("PASS  round_key[%0d] -> round_key[%0d]", i, i + 1);
            else begin
                $error("round_key[%0d] -> round_key[%0d]\n  got      = %h\n  expected = %h", i, i + 1, y, round_key[i + 1]);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("PASSED: all %0d tests", tests);
        else             $display("FAILED: %0d of %0d tests", errors, tests);
        $finish;
    end
endmodule
