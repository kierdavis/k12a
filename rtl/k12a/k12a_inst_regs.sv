`include "iverilog-compat.inc.sv"
`include "k12a.inc.sv"

module k12a_inst_regs(
    input   logic               cpu_clock,
    input   logic               reset_n,
    
    input   logic               inst_addr_load,
    input   logic               inst_high_store,
    input   logic               inst_low_store,
    
    inout   wire [15:0]         addr_bus,
    inout   wire [7:0]          data_bus,
    
    output  logic [15:0]        inst
);

    logic [7:0] inst_high;
    logic [7:0] inst_low;
    
    assign inst = {inst_high, inst_low};
    
    assign addr_bus = inst_addr_load ? {8'h80, inst_low} : 16'hzzzz;

    `ALWAYS_FF @(posedge cpu_clock or negedge reset_n) begin
        if (~reset_n) begin
            inst_high <= 8'h00;
            inst_low <= 8'h00;
        end
        else begin
            inst_high <= inst_high_store ? data_bus : inst_high;
            inst_low <= inst_low_store ? data_bus : inst_low;
        end
    end

endmodule
