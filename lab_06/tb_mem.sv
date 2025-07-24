
`define ADDR_WIDTH 5
`define DATA_WIDTH 8
`define PERIOD 10

module tb_mem;

    timeunit 1ns;
    timeprecision 100ps;

    logic clk;
    logic read;
    logic write;
    logic [`ADDR_WIDTH-1:0] addr;
    logic [`DATA_WIDTH-1:0] data_in;
    logic [`DATA_WIDTH-1:0] data_out;

    logic debug=0;
    int error_status = 0;
    logic [`DATA_WIDTH-1:0] rdata;
    logic [`ADDR_WIDTH-1:0] temp_addr;

    mem DUT_mem(
        .clk(clk),
        .i_read(read),
        .i_write(write),
        .i_addr(addr),
        .i_data(data_in),
        .o_data(data_out)
    );

    always begin
        #(`PERIOD/2) clk=1'b1;  #(`PERIOD/2) clk=1'b0;
    end

    initial begin
        $timeformat(-9, 0, " ns", 9);
        #40000ns $display("MEMORY TEST TIMEOUT");
        $finish;
    end

    initial begin
        $display("writing data");

        temp_addr = '0;
        repeat(5) @(posedge clk) begin
            read = 1'b0;
            write = 1'b1;
            addr = temp_addr;
            data_in = $urandom_range(8'h00, 8'hff);
            #1 $display("writing data | addr = %2d : %2d data_in = %2h : %2h", DUT_mem.i_addr, addr, DUT_mem.i_data, data_in);
            temp_addr = temp_addr + 1'b1;
        end

        temp_addr = '0;
        repeat(5) @(posedge clk) begin
            read = 1'b1;
            write = 1'b0;
            addr = temp_addr;
            #1 $display("reading data | addr = %2d : %2d data_out = %2h : %2h", DUT_mem.i_addr, addr, DUT_mem.o_data, data_out);
            temp_addr = temp_addr + 1'b1;
        end

        $display("\n\nclearing the memory");
        for (int i=0; i<2**`ADDR_WIDTH; i=i+1) begin
            write_mem(i, '0, 1);
        end

        $display("\n\nchecking if the memory is cleared");
        for (int i=0; i<2**`ADDR_WIDTH - 1; i=i+1) begin
            read_mem(i, rdata, 1);
            error_status = checkit(i, rdata, 8'h00);
        end
        printstatus(error_status);

        $display("\n\nwriting random data to memory");
        for (int i=0; i<2**`ADDR_WIDTH; i++) begin
            write_mem (i, i, 1);
        end

        $display("\n\nreading random data from memory");
        for (int i=0; i<2**`ADDR_WIDTH - 1; i++) begin
            read_mem (i, rdata, debug);
            error_status = checkit(i, rdata, i);
        end
        printstatus(error_status);

        $finish;
    end


    function automatic int checkit (
        input logic [4:0] address,
        input logic [7:0] actual,
        input logic [7:0] expected
    );
        static int error_status;
        if (actual !== expected) begin
            $display("ERROR:  Address:%h  Data:%h  Expected:%h", address, actual, expected);
            error_status++;
        end
        return (error_status);
    endfunction : checkit

    function automatic void printstatus(input int status);
        if (status == 0)
            $display("Test Passed - No Errors!");
        else
            $display("Test Failed with %d Errors", status);
    endfunction

    // SYSTEMVERILOG: default task input argument values
    task automatic write_mem (
        input logic [4:0] waddr,
        input logic [7:0] wdata,
        input logic debug = 0
    );
        @(negedge clk);
            write <= 1;
            read <= 0;
            addr <= waddr;
            data_in <= wdata;
        @(negedge clk);
            write <= 0;
        if (debug == 1)
            $display("Write - Address:%d  Data:%h", waddr, wdata);
    endtask

    // SYSTEMVERILOG: default task input argument values
    task automatic read_mem (
        input logic [4:0] raddr,
        output logic [7:0] rdata,
        input logic debug = 0
    );
        @(negedge clk);
            write <= 0;
            read  <= 1;
            addr  <= raddr;
        @(negedge clk);
            read <= 0;
            rdata = data_out;
        if (debug == 1)
            $display("Read  - Address:%d  Data:%h", raddr, rdata);
    endtask

    initial begin
        $dumpfile("lab_06/lab_06.vcd");
        $dumpvars(0, tb_mem);
    end

endmodule

