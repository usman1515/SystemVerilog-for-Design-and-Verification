`timescale 1ns/100ps
import typedefs::*;

module controller (
    input   logic       clk,
    input   logic       rst_,
    input   logic       zero,
    input   opcode_t    opcode,
    output  logic       mem_rd,
    output  logic       load_ir,
    output  logic       halt,
    output  logic       inc_pc,
    output  logic       load_ac,
    output  logic       load_pc,
    output  logic       mem_wr
);

state_t state;
// wire [6:0] outputs = {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr};
// assign outputs = 7'b000_0000;
logic aluop;
assign aluop = (opcode inside {ADD, AND, XOR, LDA});

always_ff @(posedge clk or negedge rst_) begin
    if (!rst_)
        state <= INST_ADDR; 
    else
        state <= state.next();
end

always_comb begin
    // outputs = 7'b000_0000;
    {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = 7'b000_0000;
    unique case(state)
        INST_ADDR: ;
        INST_FETCH:
            mem_rd = 1;
        INST_LOAD: begin
            mem_rd = 1;
            load_ir = 1;
        end
        IDLE: begin
            mem_rd = 1;
            load_ir = 1;
        end
        OP_ADDR: begin
            halt = (opcode == HLT);
            inc_pc = 1;
        end 
        OP_FETCH:
            mem_rd = aluop;
        ALU_OP: begin          
            load_ac = aluop;
            mem_rd  = aluop;
            inc_pc  = ((opcode == SKZ) && zero);
            load_pc = (opcode == JMP);
        end
        STORE: begin
            load_ac = aluop;
            mem_rd  = aluop;
            inc_pc  = (opcode == JMP);
            load_pc = (opcode == JMP);
            mem_wr  = (opcode == STO);
        end
    endcase
end

endmodule
