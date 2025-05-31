module MyMC14495(
  input D0, D1, D2, D3,
  input LE,
  input point,
  output reg p,
  output reg a, b, c, d, e, f, g
);

wire [3:0] num;
reg [6:0] led;

assign num = {D3, D2, D1, D0};
always @(*) begin
    if (LE)
        case (num)
            4'h0: led = 7'b000_0001;
            4'h1: led = 7'b100_1111;
            4'h2: led = 7'b001_0010;
            4'h3: led = 7'b000_0110;
            4'h4: led = 7'b100_1100;
            4'h5: led = 7'b010_0100;
            4'h6: led = 7'b010_0000;
            4'h7: led = 7'b000_1111;
            4'h8: led = 7'b000_0000;
            4'h9: led = 7'b000_0100;
            4'hA: led = 7'b000_1000;
            4'hB: led = 7'b110_0000;
            4'hC: led = 7'b011_0001;
            4'hD: led = 7'b100_0010;
            4'hE: led = 7'b011_0000;
            4'hF: led = 7'b110_1010; // n
        endcase
    else
        led = 7'b111_1111;
    p = ~point;
    a = led[6];
    b = led[5];
    c = led[4];
    d = led[3];
    e = led[2];
    f = led[1];
    g = led[0];
end

endmodule