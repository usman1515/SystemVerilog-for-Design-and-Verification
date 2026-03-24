`timescale 1ns/100ps

module tb_top_mem_lab06;

    localparam ADDR_WIDTH = 5;
    localparam DATA_WIDTH = 8;
    localparam PERIOD = 10;

    logic clk;
    logic read;
    logic write;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    bit debug=1;
    logic [DATA_WIDTH-1:0] out_data;

    always begin
        #(PERIOD/2) clk=1'b1;  #(PERIOD/2) clk=1'b0;
    end

    mem_lab06 DUT_mem (
        .clk(clk),
        .i_read(read),
        .i_write(write),
        .i_addr(addr),
        .i_data(data_in),
        .o_data(data_out)
    );

    tb_mem_lab06 TB_mem (
        .clk(clk),
        .read(read),
        .write(write),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("lab_06.vcd");
        $dumpvars(0, tb_top_mem_lab06);
    end

endmodule
