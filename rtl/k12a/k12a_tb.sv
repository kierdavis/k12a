`include "iverilog-compat.inc.sv"

module k12a_tb;

    parameter ROM_INIT_FILE = "programs/count.rmh.dat";

    logic clock;
    logic reset_n;

    logic [7:0] switches;
    logic [7:0] buttons;
    logic [7:0] leds;
    logic [7:0] sevenseg0;
    logic [7:0] sevenseg1;
    logic       lcd_rs;
    logic       lcd_rw;
    logic       lcd_en;
    logic [7:0] lcd_data;

    k12a #(
        .ROM_INIT_FILE(ROM_INIT_FILE)
    ) k12a(
        .sys_clock(clock),
        .reset_n(reset_n),
        .switches(switches),
        .buttons(buttons),
        .leds(leds),
        .sevenseg0(sevenseg0),
        .sevenseg1(sevenseg1),
        .lcd_rs(lcd_rs),
        .lcd_rw(lcd_rw),
        .lcd_en(lcd_en),
        .lcd_data(lcd_data)
    );

    // Clock and reset control
    always #5 clock = ~clock;
    initial begin
        clock = 1'h0;
        reset_n = 1'h1;
        #2 reset_n = 1'h0;
        #10 reset_n = 1'h1;
    end
    
    // IO
    initial $monitor("%b %b", sevenseg0, sevenseg1);
    
    // VCD dump and overall control
    initial begin
        $dumpfile("k12a_tb.vcd");
        $dumpvars;
        #40000
        $finish;
    end

endmodule
