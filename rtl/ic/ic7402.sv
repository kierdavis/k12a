`include "iverilog-compat.inc.sv"

// Models a 7402 (a quad 2-input NOR gate).
module ic7402(
    input   logic [3:0]         a,
    input   logic [3:0]         b,
    output  logic [3:0]         out
);

    assign out = ~(a | b);

endmodule
