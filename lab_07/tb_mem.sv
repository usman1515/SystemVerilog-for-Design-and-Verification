
`define ADDR_WIDTH 5
`define DATA_WIDTH 8
`define PERIOD 10

module tb_mem(memory_if.TB bus);

    timeunit 1ns;
    timeprecision 100ps;

    logic debug=0;
    int error_status = 0;
    logic [`DATA_WIDTH-1:0] rdata;
    logic [`ADDR_WIDTH-1:0] temp_addr;

    initial begin
        $timeformat(-9, 0, " ns", 9);
        #40000ns $display("MEMORY TEST TIMEOUT");
        $finish;
    end

    initial begin
        $display("writing data");

        temp_addr = '0;
        repeat(5)  begin
            @(negedge bus.clk);
                bus.i_read = 0;
                bus.i_write = 1;
                bus.i_addr = temp_addr;
                bus.i_data = $urandom_range(8'h00, 8'hff);
            @(negedge bus.clk);
                bus.i_write = 0;
                $display("writing data | Addr = %2d Data = %2h", bus.i_addr, bus.i_data);
            temp_addr = temp_addr + 1'b1;
        end

        temp_addr = '0;
        repeat(5) begin
            @(negedge bus.clk);
                bus.i_read = 1;
                bus.i_write = 0;
                bus.i_addr = temp_addr;
            @(negedge bus.clk);
                bus.i_read = 0;
                $display("reading data | Addr = %2d Data = %2h", bus.i_addr, bus.o_data);
            temp_addr = temp_addr + 1'b1;
        end

        $display("\n\nclearing the memory");
        for (int i=0; i<2**`ADDR_WIDTH; i=i+1) begin
            bus.write_mem(i, '0, 1);
        end

        $display("\n\nchecking if the memory is cleared");
        for (int i=0; i<2**`ADDR_WIDTH - 1; i=i+1) begin
            bus.read_mem(i, rdata, 1);
            error_status = checkit(i, rdata, 8'h00);
        end
        printstatus(error_status);

        $display("\n\nwriting random data to memory");
        for (int i=0; i<2**`ADDR_WIDTH; i=i+1) begin
            bus.write_mem(i, i, 1);
        end

        $display("\n\nreading random data from memory");
        for (int i=0; i<2**`ADDR_WIDTH; i=i+1) begin
            bus.read_mem(i, rdata, 1);
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
            $display("ERROR: Address:%2d Data:%2h Expected:%2h", address, actual, expected);
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

endmodule

