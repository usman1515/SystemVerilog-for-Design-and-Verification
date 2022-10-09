`timescale 1ns/100ps
import typedefs::*;

module tb_alu;

    logic           clk;
    logic   [7:0]   accum;
    logic   [7:0]   data;
    opcode_t        opcode=HLT;
    logic   [7:0]   out;
    logic           zero;

    `define PERIOD 10
    always #(`PERIOD/2) clk = ~clk;

    alu dut_alu(
        .clk        (clk        ),
        .accum      (accum      ),
        .data       (data       ),
        .opcode     (opcode     ),
        .out        (out        ),
        .zero       (zero       )
    );

    // Verify Response
    task checkit (input [8:0] expects ); begin
        $display("Time=%t | opcode= %s data= %h accum= %h | zero= %b out= %h", $time, opcode.name(), data, accum, zero, out);
        if ({zero, out} !== expects) begin
            $display("zero: %b  out: %b  | s/b: %b_%b", zero, out, expects[8], expects[7:0]);
            $display("ALU TEST FAILED");
            $finish;
        end
    end
    endtask

    // Apply Stimulus
    initial begin
        @(posedge clk)
        { opcode, data, accum } = 19'h0_37_DA; @(posedge clk) checkit('h0_da);
        { opcode, data, accum } = 19'h1_37_DA; @(posedge clk) checkit('h0_da);
        { opcode, data, accum } = 19'h2_37_DA; @(posedge clk) checkit('h0_11);
        { opcode, data, accum } = 19'h3_37_DA; @(posedge clk) checkit('h0_12);
        { opcode, data, accum } = 19'h4_37_DA; @(posedge clk) checkit('h0_ed);
        { opcode, data, accum } = 19'h5_37_DA; @(posedge clk) checkit('h0_37);
        { opcode, data, accum } = 19'h6_37_DA; @(posedge clk) checkit('h0_da);
        { opcode, data, accum } = 19'h7_37_00; @(posedge clk) checkit('h1_00);
        { opcode, data, accum } = 19'h2_07_12; @(posedge clk) checkit('h0_19);
        { opcode, data, accum } = 19'h3_1F_35; @(posedge clk) checkit('h0_15);
        { opcode, data, accum } = 19'h4_1E_1D; @(posedge clk) checkit('h0_03);
        { opcode, data, accum } = 19'h5_72_00; @(posedge clk) checkit('h1_72);
        { opcode, data, accum } = 19'h6_00_10; @(posedge clk) checkit('h0_10);
        $display("ALU TEST PASSED");
        $finish;
    end

    initial begin
        $timeformat(-9, 1, " ns", 9);
        // SystemVerilog: enhanced literal notation
        #2000ns 
        $display("ALU TEST TIMEOUT");
        $finish;
    end

    initial begin
        $dumpfile("lab_05/lab_05.vcd");
        $dumpvars(0, tb_alu);
    end

endmodule