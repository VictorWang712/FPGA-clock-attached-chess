`timescale 1ns / 1ps

module vga_top(
    input clk,
    input RSTN,
    input [15:0] switch,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_hs,
    output vga_vs
);

    wire vga_clock;
    wire [31:0] divres;

    clkdiv clkdiv_inst(.clk(clk), .rst(1'b0), .div_res(divres));
    assign vga_clock = divres[1];

    wire [8:0] row_addr;
	wire [9:0] col_addr;
	wire [11:0] vga_data;

    assign vga_data = 12'b0000_0000_1111;

    vgac v0 (
		.vga_clk(vga_clock),
		.clrn(switch[1]),
		.d_in(vga_data),
		.row_addr(row_addr),
		.col_addr(col_addr),
		.r(vga_red), .g(vga_green), .b(vga_blue),
		.hs(vga_hs), .vs(vga_vs),
        .rdn()
	);

endmodule
