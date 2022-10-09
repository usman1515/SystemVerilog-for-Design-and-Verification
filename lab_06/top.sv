`timescale 1ns/100ps

module top;

    localparam ADDR_WIDTH = 5;
    localparam DATA_WIDTH = 8;

    logic clk;
    logic read;
    logic write;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    bit debug=1;
    logic [DATA_WIDTH-1:0] out_data;

    always begin
        #5 clk=1'b0; clk=1'b1;
    end

    mem #(.ADDR_WIDTH (ADDR_WIDTH), .DATA_WIDTH (DATA_WIDTH)) dut(
        .clk      (clk      ),
        .read     (read     ),
        .write    (write    ),
        .addr     (addr     ),
        .data_in  (data_in  ),
        .data_out (data_out )
    );

    tb_mem #(.ADDR_WIDTH (ADDR_WIDTH), .DATA_WIDTH (DATA_WIDTH)) tb(
        .clk      (clk      ),
        .read     (read     ),
        .write    (write    ),
        .addr     (addr     ),
        .data_in  (data_in  ),
        .data_out (data_out )
    );

    initial begin
        $dumpfile("lab_06/lab_06.vcd");
        $dumpvars(0, tb_mem);
    end

endmodule