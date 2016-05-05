`include "iverilog-compat.inc.sv"

// Models a 7486 (a quad 2-input XOR gate).
module ic7486(
    input   logic [3:0]         a,
    input   logic [3:0]         b,
    output  logic [3:0]         out
);

    assign out = a ^ b;

endmodule
