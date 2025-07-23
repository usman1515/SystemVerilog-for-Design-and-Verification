`timescale 1ns/100ps

module register #(parameter DATA_WIDTH=8) (
    input logic     clk,
    input logic     rst_n,
    input logic     i_en,
    input logic     [DATA_WIDTH-1:0] i_data,
    output logic    [DATA_WIDTH-1:0] o_data
);

    always_ff @(posedge clk, negedge rst_n) begin
        if (rst_n) begin
            if(i_en)
                o_data <= i_data;
        end
        else begin
            o_data <= '0;
        end
    end

endmodule

