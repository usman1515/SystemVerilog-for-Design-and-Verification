timeunit 1ns;
timeprecision 100ps;

module multiplexor #(parameter DATA_WIDTH = 1) (
    input   logic [DATA_WIDTH-1:0]  in_a,
    input   logic [DATA_WIDTH-1:0]  in_b,
    input   logic                   sel,
    output  logic [DATA_WIDTH-1:0]  out
);

always_comb begin
    unique case (sel)
        'd0 : out = in_b;
        'd1 : out = in_a; 
        default: out = '0;
    endcase
end

endmodule
