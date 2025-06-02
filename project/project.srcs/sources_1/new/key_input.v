`timescale 1ns / 1ps
module key_input (
    input wire clk, ps2_clk, ps2_data,
    output wire [4:0] key
);

    wire [7:0] kb_key;
    wire kb_state;
    reg left, right, up, down, enter;
    assign key = {left, right, up, down, enter};

    PS2_drv keyboard (.clk(clk),.rst(1'b1),.ps2_clk(ps2_clk),.ps2_data(ps2_data),
        .data(kb_key),.state(kb_state));

    always @(posedge clk) begin
        case (kb_key)
            8'h5A: enter = kb_state;
            8'h75: up = kb_state;
            8'h72: down = kb_state;
            8'h6b: left = kb_state;
            8'h74: right = kb_state;
        endcase
    end

endmodule