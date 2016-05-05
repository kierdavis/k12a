`include "iverilog-compat.inc.sv"

// Models a 74151 (an 8-to-1 multiplexer).
module ic74151(
    input   logic [0:7]         inputs,
    input   logic [2:0]         sel,
    input   logic               enable_n,
    output  logic               out,
    output  logic               out_n
);

    logic enable;
    
    assign enable = ~enable_n;
    assign out = enable ? inputs[sel] : 1'b0;
    assign out_n = ~out;

endmodule
