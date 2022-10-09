`timescale 1ns/100ps

module mem #(parameter ADDR_WIDTH=5, parameter DATA_WIDTH=8) (
    input   logic                   clk,
    input   logic                   read,
    input   logic                   write,
    input   logic [ADDR_WIDTH-1:0]  addr,
    input   logic [DATA_WIDTH-1:0]  data_in ,
    output  logic [DATA_WIDTH-1:0]  data_out
);

    logic [0:DATA_WIDTH-1] [(2**ADDR_WIDTH)-1:0] mem_block ;

    always_ff @(posedge clk) begin
        if(write && !read)
            mem_block[addr] <= data_in;
        if(read && !write)
            data_out <= mem_block[addr];
    end

endmodule