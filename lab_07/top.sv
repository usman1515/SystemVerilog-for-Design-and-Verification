`timescale 1ns/100ps

module tb_top_mem_lab07;

    localparam PERIOD = 10;

    logic clk;

    // create clock
    always begin
        #(PERIOD/2) clk=1'b1;  #(PERIOD/2) clk=1'b0;
    end

    // instantiate interface object
    memory_if memif(.clk(clk));

    // instantiate DUT
    mem_lab07 DUT_mem(.bus(memif.DUT));

    // instantiate TB
    tb_mem_lab07 TB_mem(.bus(memif.TB));

    // generate waveform dump
    initial begin
        $dumpfile("lab_07.vcd");
        $dumpvars(0, tb_top_mem_lab07);
    end

endmodule

