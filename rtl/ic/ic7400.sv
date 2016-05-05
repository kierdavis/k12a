`include "iverilog-compat.inc.sv"

// Models a 7400 (a quad 2-input NAND gate).
module ic7400(
    input   logic [3:0]         a,
    input   logic [3:0]         b,
    output  logic [3:0]         out
);

    assign out = ~(a & b);

endmodule
