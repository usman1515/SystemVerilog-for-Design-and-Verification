`timescale 1ns/100ps
import typedefs::*;

module alu (
    input   logic       clk,
    input   logic [7:0] accum,
    input   logic [7:0] data,
    input   opcode_t    opcode,
    output  logic [7:0] out,
    output  logic       zero
);

always_ff @(negedge clk) begin
    unique case (opcode)
        HLT: out = accum;
        SKZ: out = accum;
        ADD: out = data + accum;
        AND: out = data & accum;
        XOR: out = data ^ accum;
        LDA: out = data;
        STO: out = accum;
        JMP: out = accum; 
    endcase
end

assign zero = (!accum)? 1 : 0;

// always_comb 
    // zero = ~(|accum);
    // zero = (!accum)? 1 : 0;

endmodule
