module HexToSeg(
    input [3:0] hex,
    input LE,
    input point,
    output [7:0] segment
);

    MyMC14495 MSEG(.D3(hex[3]), .D2(hex[2]), .D1(hex[1]), .D0(hex[0]), .LE(LE), .point(point),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .p(p));

    assign segment = {a, b, c, d, e, f, g, p};

endmodule