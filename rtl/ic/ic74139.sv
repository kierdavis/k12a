`include "iverilog-compat.inc.sv"

// Models a 74139 (a dual 2-to-4 decoder).
module ic74139(
    input   logic               enable1_n,
    input   logic [1:0]         sel1,
    output  logic [0:3]         out1_n,
    
    input   logic               enable2_n,
    input   logic [1:0]         sel2,
    output  logic [0:3]         out2_n
);

    logic enable1, enable2;
    logic [0:3] decoded1, decoded2;
    
    assign enable1 = ~enable1_n;
    assign enable2 = ~enable2_n;

    assign decoded1 = {sel1 == 2'h0, sel1 == 2'h1, sel1 == 2'h2, sel1 == 2'h3};
    assign decoded2 = {sel2 == 2'h0, sel2 == 2'h1, sel2 == 2'h2, sel2 == 2'h3};

    assign out1_n = enable1 ? ~decoded1 : 4'b1111;
    assign out2_n = enable2 ? ~decoded2 : 4'b1111;

endmodule
