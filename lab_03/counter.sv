`timescale 1ns/100ps

module counter (
    input logic     clk,
    input logic     rst_n,
    input logic     i_en,
    input logic     i_load,
    input logic     [4:0] i_data,
    output logic    [4:0] o_count
);

    always_ff @(posedge clk, negedge rst_n) begin
        if (rst_n) begin
            if(i_load) begin
                o_count <= i_data;
            end
            else begin
                o_count <= (i_en)? o_count + 1'b1 : o_count;
            end
        end
        else begin
            o_count <= 'd0;
        end
    end

endmodule

