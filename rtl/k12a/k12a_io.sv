`include "iverilog-compat.inc.sv"
`include "k12a.inc.sv"

module k12a_io(
    input   logic               cpu_clock,
    input   logic               reset_n,
    input   logic               async_write,
    
    input   logic               io_load,
    input   logic               io_store,
    input   logic [2:0]         io_addr,
    
    inout   wire [7:0]          data_bus,
    
    input   logic [7:0]         switches,
    input   logic [7:0]         buttons,
    output  logic [7:0]         leds,
    output  logic [7:0]         sevenseg0, // dot, a, b, c, d, e, f, g
    output  logic [7:0]         sevenseg1,
    output  logic               lcd_rs, // 0: instruction, 1: data
    output  logic               lcd_rw, // 0: write, 1: read
    output  logic               lcd_en,
    output  logic [7:0]         lcd_data
);

    logic [7:0] sevenseg0_buffer, sevenseg0_decoded;
    logic [7:0] sevenseg1_buffer, sevenseg1_decoded;
    logic [4:0] control;
    logic [7:0] lcd_buffer;
    
    logic sevenseg0_mode;
    logic sevenseg1_mode;
    logic lcd_xfer;
    
    assign sevenseg0 = sevenseg0_mode ? sevenseg0_decoded : sevenseg0_buffer;
    assign sevenseg1 = sevenseg1_mode ? sevenseg1_decoded : sevenseg1_buffer;
    
    assign lcd_rw = 1'h0;
    assign lcd_en = lcd_xfer & async_write;
    
    assign sevenseg0_mode = control[0];
    assign sevenseg1_mode = control[1];
    assign lcd_rs = control[4];
    assign lcd_xfer = io_store & (io_addr == 3'h4) & data_bus[5];
    
    assign data_bus = (io_load & (io_addr == 3'h0)) ? switches : 8'hzz;
    assign data_bus = (io_load & (io_addr == 3'h1)) ? buttons : 8'hzz;
    assign data_bus = (io_load & (io_addr == 3'h2)) ? leds : 8'hzz;
    assign data_bus = (io_load & (io_addr == 3'h4)) ? {3'h0, control} : 8'hzz;
    assign data_bus = (io_load & (io_addr == 3'h5)) ? lcd_buffer : 8'hzz;
    
    `ALWAYS_FF @(posedge cpu_clock or negedge reset_n) begin
        if (~reset_n) begin
            sevenseg0_buffer <= 8'h00;
            sevenseg1_buffer <= 8'h00;
            leds <= 8'h00;
            control <= 5'h00;
            lcd_buffer <= 8'h00;
        end
        else begin
            sevenseg0_buffer <= (io_store & (io_addr == 3'h0)) ? data_bus : sevenseg0_buffer;
            sevenseg1_buffer <= (io_store & (io_addr == 3'h1)) ? data_bus : sevenseg1_buffer;
            leds             <= (io_store & (io_addr == 3'h2)) ? data_bus : leds;
            control          <= (io_store & (io_addr == 3'h4)) ? data_bus[4:0] : control;
            lcd_buffer       <= (io_store & (io_addr == 3'h5)) ? data_bus : lcd_buffer;
        end
    end
    
    `ALWAYS_COMB begin
        sevenseg0_decoded = 8'hxx;
        case (sevenseg0_buffer[3:0])
            4'h0: sevenseg0_decoded = 8'b0_1111110;
            4'h1: sevenseg0_decoded = 8'b0_0110000;
            4'h2: sevenseg0_decoded = 8'b0_1101101;
            4'h3: sevenseg0_decoded = 8'b0_1111001;
            4'h4: sevenseg0_decoded = 8'b0_0110011;
            4'h5: sevenseg0_decoded = 8'b0_1011011;
            4'h6: sevenseg0_decoded = 8'b0_1011111;
            4'h7: sevenseg0_decoded = 8'b0_1110000;
            4'h8: sevenseg0_decoded = 8'b0_1111111;
            4'h9: sevenseg0_decoded = 8'b0_1111011;
            4'hA: sevenseg0_decoded = 8'b0_1110111;
            4'hB: sevenseg0_decoded = 8'b0_0011111;
            4'hC: sevenseg0_decoded = 8'b0_1001110;
            4'hD: sevenseg0_decoded = 8'b0_0111101;
            4'hE: sevenseg0_decoded = 8'b0_1001111;
            4'hF: sevenseg0_decoded = 8'b0_1000111;
        endcase
    end
    
    `ALWAYS_COMB begin
        sevenseg1_decoded = 8'hxx;
        case (sevenseg1_buffer[3:0])
            4'h0: sevenseg1_decoded = 8'b0_1111110;
            4'h1: sevenseg1_decoded = 8'b0_0110000;
            4'h2: sevenseg1_decoded = 8'b0_1101101;
            4'h3: sevenseg1_decoded = 8'b0_1111001;
            4'h4: sevenseg1_decoded = 8'b0_0110011;
            4'h5: sevenseg1_decoded = 8'b0_1011011;
            4'h6: sevenseg1_decoded = 8'b0_1011111;
            4'h7: sevenseg1_decoded = 8'b0_1110000;
            4'h8: sevenseg1_decoded = 8'b0_1111111;
            4'h9: sevenseg1_decoded = 8'b0_1111011;
            4'hA: sevenseg1_decoded = 8'b0_1110111;
            4'hB: sevenseg1_decoded = 8'b0_0011111;
            4'hC: sevenseg1_decoded = 8'b0_1001110;
            4'hD: sevenseg1_decoded = 8'b0_0111101;
            4'hE: sevenseg1_decoded = 8'b0_1001111;
            4'hF: sevenseg1_decoded = 8'b0_1000111;
        endcase
    end

endmodule
