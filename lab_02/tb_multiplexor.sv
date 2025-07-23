///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : tb_multiplexor.sv
// Title       : MUX Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the mux testbench module
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

module tb_multiplexor;

    timeunit 1ns;
    timeprecision 100ps;
    localparam WIDTH=8;

    logic [WIDTH-1:0] out;     // mux output
    logic [WIDTH-1:0] in_a;    // mux_test data_a
    logic [WIDTH-1:0] in_b;    // mux_test data_b
    logic             sel_a;   // mux_test select a

    // Instantiate mux
    multiplexor #(
        .DATA_WIDTH(WIDTH)
    ) DUT_mux8 (
        .i_a(in_a),
        .i_b(in_b),
        .i_sel(sel_a),
        .o_data(out)
    );

    // Monitor Results
    initial begin
        $timeformat(-9, 0, "ns", 3);
        $monitor("%t in_a=%h in_b=%h sel_a=%h out=%h", $time, in_a, in_b, sel_a, out) ;
    end

    // Verify Results
    task expect_test (input [WIDTH-1:0] expects);
        if (out !== expects) begin
            $display("out is %b and should be %b", out, expects);
            $display("MUX TEST FAILED");
            $finish;
        end
    endtask

    // Apply Stimulus
    initial begin
        in_a='0; in_b='0; sel_a=0; #1ns expect_test('0);
        in_a='0; in_b='0; sel_a=1; #1ns expect_test('0);
        in_a='0; in_b='1; sel_a=0; #1ns expect_test('1);
        in_a='0; in_b='1; sel_a=1; #1ns expect_test('0);
        in_a='1; in_b='0; sel_a=0; #1ns expect_test('0);
        in_a='1; in_b='0; sel_a=1; #1ns expect_test('1);
        in_a='1; in_b='1; sel_a=0; #1ns expect_test('1);
        in_a='1; in_b='1; sel_a=1; #1ns expect_test('1);
        $display("MUX TEST PASSED");
        $finish(0);
    end

    initial begin
        $dumpfile("lab_02/lab_02.vcd");
        $dumpvars(0, tb_multiplexor);
    end

endmodule

