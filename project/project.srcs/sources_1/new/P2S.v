module P2S #(
    parameter BIT_WIDTH = 8
)(
    input clk,
    input start,
    input [BIT_WIDTH-1:0] par_in,
    output sclk,
    output sclrn,
    output sout,
    output EN
);
    wire [BIT_WIDTH:0] Q;
    wire finish;
    wire latch_q;

    // SR Latch instance
    SR_Latch latch(
        .S(start & finish),
        .R(~finish),
        .Q(latch_q),
        .Qn()
    );

    // Shift Register instance
    ShiftReg #(.BIT_WIDTH(BIT_WIDTH+1)) shifter(
        .clk(clk),
        .shiftn_loadp(latch_q),
        .shift_in(1'b1),
        .par_in({1'b0, par_in}),
        .Q(Q)
    );

    assign finish = &Q[BIT_WIDTH:1];

    assign EN = !start & finish;
    assign sclk = finish | ~clk;
    assign sclrn = 1'b1;
    assign sout = Q[0];
endmodule