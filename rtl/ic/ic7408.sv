`include "iverilog-compat.inc.sv"

// Models a 7408 (a quad 2-input AND gate).
module ic7408(
    input   logic [3:0]         a,
    input   logic [3:0]         b,
    output  logic [3:0]         out
);

    assign out = a & b;

endmodule
