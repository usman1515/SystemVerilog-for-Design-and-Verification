`timescale 1ns/100ps
`include "./mem_interface.sv"

`define ADDR_WIDTH 5
`define DATA_WIDTH 8

module mem (memory_if.DUT bus);

    // logic [`DATA_WIDTH-1 : 0] mem_block [0 : (2**ADDR_WIDTH)-1];
    logic [`DATA_WIDTH-1 : 0] mem_block [(2**`ADDR_WIDTH)-1];

    always_ff @(posedge bus.clk) begin
        if(bus.i_write && !bus.i_read)
            mem_block[bus.i_addr] <= bus.i_data;
    end

    always_ff @(posedge bus.clk) begin
        if(!bus.i_write && bus.i_read)
            bus.o_data <= mem_block[bus.i_addr];
    end

endmodule

