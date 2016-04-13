`include "iverilog-compat.inc.sv"

// Models a 62256 (a 32 KiB asynchronous SRAM).
module ic62256(
    input logic [14:0] addr,
    inout wire [7:0] data,
    input logic ce_n, // chip enable, active low
    input logic oe_n, // output enable, active low
    input logic we_n  // write enable, active low
);

    logic [7:0] memory [0:32767];
    
    logic ce, oe, we;
    assign ce = ~ce_n;
    assign oe = ~oe_n;
    assign we = ~we_n;
    
    assign data = (ce & oe) ? memory[addr] : 8'hzz;
    
    always @* begin
        if (ce & we) begin
            memory[addr] = data;
        end
    end
    
    logic [7:0] memory0, memory1, memory2, memory3;
    assign memory0 = memory[0];
    assign memory1 = memory[1];
    assign memory2 = memory[2];
    assign memory3 = memory[3];
endmodule
