`timescale 1ns/100ps

import typedefs::*;

module controller (
    input logic     clk,
    input logic     rst_n,
    input logic     i_zero,
    input opcode_t  i_opcode,
    output logic    o_mem_rd,
    output logic    o_load_ir,
    output logic    o_halt,
    output logic    o_inc_pc,
    output logic    o_load_ac,
    output logic    o_load_pc,
    output logic    o_mem_wr
);

    state_t state;
    // wire [6:0] outputs = {o_mem_rd, o_load_ir, o_halt, o_inc_pc, o_load_ac, o_load_pc, o_mem_wr};
    // assign outputs = 7'b000_0000;
    logic aluop;
    assign aluop = (i_opcode inside {ADD, AND, XOR, LDA});

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= INST_ADDR;
        else
            state <= state.next();
    end

    always_comb begin
        // outputs = 7'b000_0000;
        {o_mem_rd, o_load_ir, o_halt, o_inc_pc, o_load_ac, o_load_pc, o_mem_wr} = 7'b000_0000;
        case(state)
            INST_ADDR: ;
            INST_FETCH:
                o_mem_rd = 1;
            INST_LOAD: begin
                o_mem_rd = 1;
                o_load_ir = 1;
            end
            IDLE: begin
                o_mem_rd = 1;
                o_load_ir = 1;
            end
            OP_ADDR: begin
                o_halt = (i_opcode == HLT);
                o_inc_pc = 1;
            end
            OP_FETCH:
                o_mem_rd = aluop;
            ALU_OP: begin
                o_load_ac = aluop;
                o_mem_rd  = aluop;
                o_inc_pc  = ((i_opcode == SKZ) && i_zero);
                o_load_pc = (i_opcode == JMP);
            end
            STORE: begin
                o_load_ac = aluop;
                o_mem_rd = aluop;
                o_inc_pc = (i_opcode == JMP);
                o_load_pc = (i_opcode == JMP);
                o_mem_wr = (i_opcode == STO);
            end
        endcase
    end

endmodule

