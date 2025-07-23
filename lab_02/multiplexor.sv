`timescale 1ns/100ps

module multiplexor #(parameter DATA_WIDTH = 4) (
    input logic     [DATA_WIDTH-1:0] i_a,
    input logic     [DATA_WIDTH-1:0] i_b,
    input logic     i_sel,
    output logic    [DATA_WIDTH-1:0] o_data
);

always_comb begin
    unique case (i_sel)
        'd0 : o_data = i_b;
        'd1 : o_data = i_a;
        default: o_data = '0;
    endcase
end

endmodule

