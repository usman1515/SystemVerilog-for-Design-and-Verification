`timescale 1ns/100ps

`define ADDR_WIDTH 5
`define DATA_WIDTH 8

module mem (
    input logic     clk,
    input logic     i_read,
    input logic     i_write,
    input logic     [`ADDR_WIDTH-1:0] i_addr,
    input logic     [`DATA_WIDTH-1:0] i_data,
    output logic    [`DATA_WIDTH-1:0] o_data
);

    // logic [`DATA_WIDTH-1 : 0] mem_block [0 : (2**ADDR_WIDTH)-1];
    logic [`DATA_WIDTH-1 : 0] mem_block [(2**`ADDR_WIDTH)-1];

    always_ff @(posedge clk) begin
        if(i_write && !i_read)
            mem_block[i_addr] <= i_data;
        if(i_read && !i_write)
            o_data <= mem_block[i_addr];
    end

endmodule

