`timescale 1ns/100ps

module tb_mem #(parameter ADDR_WIDTH=5, parameter DATA_WIDTH=8) (
    input   logic                   clk,
    output  logic                   read,
    output  logic                   write,
    output  logic [ADDR_WIDTH-1:0]  addr,
    output  logic [DATA_WIDTH-1:0]  data_in ,
    input   logic [DATA_WIDTH-1:0]  data_out
);

    // Monitor Results
    initial begin
        $timeformat ( -9, 0, " ns", 9 );
        #40000ns $display("MEMORY TEST TIMEOUT");
        $finish;
    end

    initial begin : memtest
        int error_status;

        $display("Clear Memory Test");
        // SYSTEMVERILOG: enhanced for loop
        for (int i=0; i<32; i++)
            write_mem(i, 0, debug);
        for (int i=0; i<32; i++) begin
            read_mem (i, out_data, debug);
            // check each memory location for data = 'h00
            error_status = checkit(i, out_data, 8'h00);
        end
        // SYSTEMVERILOG: void function
        printstatus(error_status);

        $display("Data = Address Test");
        // SYSTEMVERILOG: enhanced for loop
        for (int i=0; i<32; i++)
            write_mem (i, i, debug);
        for (int i=0; i<32; i++) begin
            read_mem (i, out_data, debug);
            // check each memory location for data = address
            error_status = checkit (i, out_data, i);
        end
        // SYSTEMVERILOG: void function
        printstatus(error_status);
        $finish;
    end : memtest

    task write_mem(input [DATA_WIDTH-1:0] in_addr, input [DATA_WIDTH-1:0] in_data, input debug=0);
        @(negedge clk);
        write <= 1'b1;
        read <= 1'b0;
        addr <= in_addr;
        data_in <= in_data;
        @(negedge clk);
        write <= 1'b0;
        if(debug)
            $display("Write Data | Address= %d  Data= %h", in_addr, in_data);
    endtask : write_mem

    task read_mem(input [DATA_WIDTH-1:0] in_addr, output [DATA_WIDTH-1:0] out_data, input debug=0);
        @(negedge clk);
        write <= 1'b0;
        read <= 1'b1;
        addr <= in_addr;
        @(negedge clk);
        read <= 1'b0;
        out_data <= data_out;
        if(debug)
            $display("Read Data | Address= %d  Data= %h", in_addr, out_data);
    endtask : read_mem

    function int checkit (input [4:0] address, input [7:0] actual, expected);
        static int error_status
        if (actual !== expected) begin
            $display("ERROR:  Address:%h  Data:%h  Expected:%h", address, actual, expected);
            error_status++;
        end
        return (error_status);
    endfunction : checkit

    function void printstatus(input int status);
        if (status == 0)
            $display("Test Passed - No Errors!");
        else
            $display("Test Failed with %d Errors", status);
    endfunction : printstatus

endmodule
