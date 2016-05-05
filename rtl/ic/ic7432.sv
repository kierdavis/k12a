`include "iverilog-compat.inc.sv"

// Models a 7432 (a quad 2-input OR gate).
module ic7432(
    input   logic [3:0]         a,
    input   logic [3:0]         b,
    output  logic [3:0]         out
);

    assign out = a | b;

endmodule
