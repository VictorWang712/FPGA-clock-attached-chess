`timescale 1ns / 1ps

module PS2_drv (
    input wire clk, rst, ps2_clk, ps2_data,
    output reg [7:0] data,
    output reg state
);

    localparam KB_BREAK = 1'b1;
    localparam KB_RELEASE = 1'b0;
    localparam KB_PRESS = 1'b1;
    reg [2:0] clk_sync;
    reg [3:0] cnt; 
	reg [7:0] temp;
    reg f0;

    wire samp = clk_sync[2] & ~clk_sync[1];
    always @(posedge clk) begin
        clk_sync <= {clk_sync[1:0], ps2_clk};
    end

    always @(posedge clk) begin
        if(!rst) begin
            cnt <= 4'h0;
            temp  <= 8'h00;
        end else if (samp) begin
            if (cnt == 4'hA) cnt <= 4'h0;
            else cnt <= cnt + 4'h1;
            if (cnt >= 4'h1 && cnt <= 4'h8)
                temp[cnt - 1] <= ps2_data;
        end
    end

    always @(posedge clk) begin
        if (!rst) begin
            f0 <= ~KB_BREAK;
            state <= KB_RELEASE;
        end
        else if (cnt == 4'hA && samp) begin
            if (temp == 8'hF0) begin
                f0 <= KB_BREAK;
            end else begin
                state <= (f0 == KB_BREAK) ? KB_RELEASE : KB_PRESS;
                f0    <= (f0 == KB_BREAK) ? ~KB_BREAK : f0;
                data  <= temp;
            end
        end
    end

endmodule