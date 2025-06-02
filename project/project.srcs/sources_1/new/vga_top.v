`timescale 1ns / 1ps

module vga_top(
    input clk,
    input rst,
    input [15:0] switch,
    input [5:0] crt,
    input [7:0] wp0, wp1, wp2, wp3, wp4, wp5, wp6, wp7,
    input [7:0] wr0, wr1, wn0, wn1, wb0, wb1, wq, wk,
    input [7:0] bp0, bp1, bp2, bp3, bp4, bp5, bp6, bp7,
    input [7:0] br0, br1, bn0, bn1, bb0, bb1, bq, bk,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_hs,
    output vga_vs
);

    wire vga_clock;
    wire [31:0] divres;

    clkdiv clkdiv_inst(
        .clk(clk),
        .rst(1'b0),
        .div_res(divres)
    );

    assign vga_clock = divres[1];

    wire [9:0] row_addr;
    wire [9:0] col_addr;
    wire [11:0] pixel_data;
    wire rdn;

    vga_ctrl vga_ctrl_inst(
        .clk(vga_clock),
        .rdn(rdn),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .crt(crt),
        .wp0(wp0), .wp1(wp1), .wp2(wp2), .wp3(wp3), .wp4(wp4), .wp5(wp5), .wp6(wp6), .wp7(wp7),
        .wr0(wr0), .wr1(wr1), .wn0(wn0), .wn1(wn1), .wb0(wb0), .wb1(wb1), .wq(wq), .wk(wk),
        .bp0(bp0), .bp1(bp1), .bp2(bp2), .bp3(bp3), .bp4(bp4), .bp5(bp5), .bp6(bp6), .bp7(bp7),
        .br0(br0), .br1(br1), .bn0(bn0), .bn1(bn1), .bb0(bb0), .bb1(bb1), .bq(bq), .bk(bk),
        .pixel_data(pixel_data)
    );

    vga_drv vga_drv_inst(
        .vga_clk(vga_clock),
        .clrn(switch[15]),
        .d_in(pixel_data),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .rdn(rdn),
        .r(vga_red),
        .g(vga_green),
        .b(vga_blue),
        .hs(vga_hs),
        .vs(vga_vs)
    );

endmodule