`define ADDR_WIDTH 5
`define DATA_WIDTH 8

interface memory_if (input logic clk);

    // module IOs
    logic i_read;
    logic i_write;
    logic [`ADDR_WIDTH-1:0] i_addr;
    logic [`DATA_WIDTH-1:0] i_data;
    logic [`DATA_WIDTH-1:0] o_data;

    // modport for DUT
    modport DUT (
        input   clk,
        input   i_read,
        input   i_write,
        input   i_addr,
        input   i_data,
        output  o_data
    );

    // modport for TB
    modport TB (
        input   clk,
        output  i_read,
        output  i_write,
        output  i_addr,
        output  i_data,
        input   o_data,
        import write_mem,
        import read_mem
    );

    task write_mem (
        input logic [4:0] waddr,
        input logic [7:0] wdata,
        input logic debug = 0
    );
        @(negedge clk);
            i_write <= 1;
            i_read <= 0;
            i_addr <= waddr;
            i_data <= wdata;
        @(negedge clk);
            i_write <= 0;
        if (debug == 1)
            $display("Memory Write | Address:%2d Data:%2h", waddr, wdata);
    endtask

    task read_mem (
        input logic [4:0] raddr,
        output logic [7:0] rdata,
        input logic debug = 0
    );
        @(negedge clk);
            i_write <= 0;
            i_read <= 1;
            i_addr <= raddr;
            rdata <= o_data;
        @(negedge clk);
            i_read <= 0;
            // rdata <= o_data;
        if (debug == 1)
            $display("Memory Read | Address:%2d Data:%2h", raddr, rdata);
    endtask


endinterface

