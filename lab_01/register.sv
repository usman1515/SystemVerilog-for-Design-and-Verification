`timescale 1ns/100ps

module register #(parameter DATA_WIDTH=8) (
    input   logic   clk,
    input   logic   rst_,
    input   logic   en,
    input   logic   [DATA_WIDTH-1:0]  data,
    output  logic   [DATA_WIDTH-1:0]  out
);

always_ff @(posedge clk, negedge rst_) begin
    if (rst_) begin
        if(en)
			out = data;
    end
    else
        out = 'b0;
end

endmodule
