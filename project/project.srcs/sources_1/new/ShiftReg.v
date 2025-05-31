module ShiftReg #(
    parameter BIT_WIDTH = 8
)(
    input clk,
    input shiftn_loadp,
    input shift_in,
    input [BIT_WIDTH-1:0] par_in,
    output [BIT_WIDTH-1:0] Q
);
    reg [BIT_WIDTH-1:0] Q_reg = 0;

    always @(posedge clk) begin
        if (shiftn_loadp)
            Q_reg <= par_in;
        else
            Q_reg <= {shift_in, Q[BIT_WIDTH-1:1]};
    end

    assign Q = Q_reg;
endmodule