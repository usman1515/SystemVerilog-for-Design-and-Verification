`timescale 1ns/100ps

import typedefs::*;

module alu (
    input logic     clk,
    input logic     [7:0] i_accum,
    input logic     [7:0] i_data,
    input opcode_t  i_opcode,
    output logic    [7:0] o_data,
    output logic    o_zero
);

    always_ff @(negedge clk) begin
        case (i_opcode)
            HLT, SKZ, STO, JMP: o_data <= i_accum;
            ADD: o_data <= i_data + i_accum;
            AND: o_data <= i_data & i_accum;
            XOR: o_data <= i_data ^ i_accum;
            LDA: o_data <= i_data;
        endcase
    end

    assign o_zero = ~(|i_accum);

endmodule

