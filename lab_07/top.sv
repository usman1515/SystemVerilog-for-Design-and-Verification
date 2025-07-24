`timescale 1ns/100ps

module tb_top_mem;

    localparam PERIOD = 10;

    logic clk;

    // create clock
    always begin
        #(PERIOD/2) clk=1'b1;  #(PERIOD/2) clk=1'b0;
    end

    // instantiate interface object
    memory_if memif(.clk(clk));

    // instantiate DUT
    mem DUT_mem(.bus(memif.DUT));

    // instantiate TB
    tb_mem TB_mem(.bus(memif.TB));

    // generate waveform dump
    initial begin
        $dumpfile("lab_07/lab_07.vcd");
        $dumpvars(0, tb_top_mem);
    end

endmodule

