/*
 * Module: aes_ctrl
 * Author: Gabe Alencar gmenendezdealencar@g.hmc.edu
 * Date:   10/25/26
 *
 * Control FSM for aes_core
 */

module aes_ctrl (
    input  logic clk,
    input  logic load,
    output logic init_en,
    output logic round_en,
    output logic last_round,
    output logic done
);

    typedef enum logic [4:0] {LOADING = 5'b00001, INIT = 5'b00010, SUB = 5'b00100, ROUND = 5'b01000, DONE = 5'b10000} statetype;
    statetype state, nextstate;

    logic [3:0] round;     

    // ---- state register ----
    always_ff @(posedge clk)
        if (load) state <= LOADING;
        else      state <= nextstate;

    // ---- round counter ----
    always_ff @(posedge clk)
        if      (init_en)  round <= 4'd1;
        else if (round_en) round <= round + 4'd1;

    assign last_round = (round == 4'd10);

    // ---- next state logic ----
    always_comb
        case (state)
            LOADING: nextstate = INIT;
            INIT:    nextstate = SUB;
            SUB:     nextstate = ROUND;
            ROUND:   nextstate = last_round ? DONE : SUB;
            DONE:    nextstate = DONE;
            default: nextstate = LOADING;
        endcase

    // ---- output logic ----
    assign init_en  = (state == INIT);
    assign round_en = (state == ROUND);
    assign done     = (state == DONE);

endmodule
