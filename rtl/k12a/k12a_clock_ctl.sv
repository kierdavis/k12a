`include "iverilog-compat.inc.sv"
`include "k12a.inc.sv"

module k12a_clock_ctl(
    input   logic               sys_clock,
    input   logic               reset_n,
    output  logic               cpu_clock,
    output  logic               async_write
);

    `ALWAYS_FF @(posedge sys_clock or negedge reset_n) begin
        if (~reset_n) begin
            cpu_clock <= 1'h0;
        end
        else begin
            cpu_clock <= ~cpu_clock;
        end
    end
    
    assign async_write = sys_clock & ~cpu_clock;

endmodule
