`timescale 1ns/100ps

module counter #(parameter DATA_WIDTH = 3)(
    input   logic                   clk ,
    input   logic                   rst_,
    input   logic                   enable,
    input   logic                   load,
    input   logic [DATA_WIDTH-1:0]  data,
    output  logic [DATA_WIDTH-1:0]  count
);

always_ff @(posedge clk, negedge rst_) begin
    if (rst_) begin
        if(load) begin
            count <= data;
        end
        else if (enable) begin
            count <= count + 1;
        end
    end
    else begin
        count <= 'd0;
    end
end

endmodule
