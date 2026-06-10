///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : register_test.sv
// Title       : Register Testbench Module
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Defines the register testbench module
// Notes       :
//
///////////////////////////////////////////////////////////////////////////

`define PERIOD 10

module tb_register;

    timeunit 1ns;
    timeprecision 100ps;
    localparam DATA_WIDTH=8;

    logic [DATA_WIDTH-1 : 0] out;
    logic [DATA_WIDTH-1 : 0] data;
    logic enable;
    logic rst_ = 1'b1;
    logic clk;

    always begin
        #(`PERIOD/2) clk=1'b1;  #(`PERIOD/2) clk=1'b0;
    end

    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT_register (
        .clk(clk),
        .rst_n(rst_),
        .i_en(enable),
        .i_data(data),
        .o_data(out)
    );

    // Monitor Results
    initial begin
        $timeformat(-9, 1, " ns", 9);
        #(`PERIOD * 99)
        $display("REGISTER TEST TIMEOUT");
        $finish;
    end

    // Verify Results
    task expect_test (input [7:0] expects);
        $display("time=%t enable=%b rst_=%b data=%h out=%h", $time, enable, rst_, data, out);
        if (out !== expects) begin
            $display("time=%t, out=%b, should be %b", $time, out, expects);
            $display("REGISTER TEST FAILED");
            $finish;
        end
    endtask

    initial begin
        @(negedge clk)
        { rst_, enable, data } = 10'b1_X_XXXXXXXX; @(negedge clk) expect_test ( 8'hXX );
        { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_1_10101010; @(negedge clk) expect_test ( 8'hAA );
        { rst_, enable, data } = 10'b1_0_01010101; @(negedge clk) expect_test ( 8'hAA );
        { rst_, enable, data } = 10'b0_X_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_0_XXXXXXXX; @(negedge clk) expect_test ( 8'h00 );
        { rst_, enable, data } = 10'b1_1_01010101; @(negedge clk) expect_test ( 8'h55 );
        { rst_, enable, data } = 10'b1_0_10101010; @(negedge clk) expect_test ( 8'h55 );
        $display("REGISTER TEST PASSED");
        $finish;
    end

    `ifdef WAVE_DUMP
    initial begin
        $dumpfile("./bin/lab_01.vcd");
        $dumpvars(0, tb_register);
    end
    `endif

endmodule
