`timescale 1ns / 1ps

module Top(
    input clk,
    input BTN_Y0,
    input BTN_Y1,
    input BTN_Y2,
    input BTN_Y3,
    input [15:0] switch,
    input PS2_clk, 
    input PS2_data,
    output ledclk,
    output ledclrn,
    output ledsout,
    output LEDEN,
    output seg_clk,
    output seg_sout,
    output seg_clrn,
    output seg_pen,
    output buzzer,
    output BTN_X4,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_hs,
    output vga_vs
);

    wire clk_500ms;
    wire clk_1s;
    wire start;
    wire buzzer_en;
    wire [31:0] divres;
    wire [3:0] btn_out;
    wire [31:0] hexs;
    wire [7:0] points;
    wire [7:0] LEs;
    wire [4:0] note;
    wire [2:0] state;

    wire [15:0] parin;

    wire [4:0] key;

    wire [5:0] crt;
    wire [7:0] wp0, wp1, wp2, wp3, wp4, wp5, wp6, wp7;
    wire [7:0] wr0, wr1, wn0, wn1, wb0, wb1, wq, wk;
    wire [7:0] bp0, bp1, bp2, bp3, bp4, bp5, bp6, bp7;
    wire [7:0] br0, br1, bn0, bn1, bb0, bb1, bq, bk;

    assign BTN_X4 = 1'b0;
    assign parin = {~btn_out[3:0], 2'b00, key[4:0], 2'b00, ~state[2:0]};

    clkdiv clkdiv_inst(.clk(clk), .rst(1'b0), .div_res(divres));
    assign start = divres[20];

    clk_500ms clk_500ms_inst(.clk(clk), .clk_500ms(clk_500ms));
    clk_1s clk_1s_inst(.clk(clk), .clk_1s(clk_1s));

    pbdebounce m1(.clk(divres[17]), .button(BTN_Y0), .pbreg(btn_out[0]));
    pbdebounce m2(.clk(divres[17]), .button(BTN_Y1), .pbreg(btn_out[1]));
    pbdebounce m3(.clk(divres[17]), .button(BTN_Y2), .pbreg(btn_out[2]));
    pbdebounce m4(.clk(divres[17]), .button(BTN_Y3), .pbreg(btn_out[3]));

    key_input key_input_inst(.clk(clk), .ps2_clk(PS2_clk), .ps2_data(PS2_data), .key(key));

    chess chess_inst(
        .clk(clk),
        .rst((state == 3'b100)),
        .start((state == 3'b101)),
        .key(key),
        .crt(crt),
        .wp0(wp0), .wp1(wp1), .wp2(wp2), .wp3(wp3), .wp4(wp4), .wp5(wp5), .wp6(wp6), .wp7(wp7),
        .wr0(wr0), .wr1(wr1), .wn0(wn0), .wn1(wn1), .wb0(wb0), .wb1(wb1), .wq(wq), .wk(wk),
        .bp0(bp0), .bp1(bp1), .bp2(bp2), .bp3(bp3), .bp4(bp4), .bp5(bp5), .bp6(bp6), .bp7(bp7),
        .br0(br0), .br1(br1), .bn0(bn0), .bn1(bn1), .bb0(bb0), .bb1(bb1), .bq(bq), .bk(bk)
    );

    chess_clock chess_clock_inst(
        .clk(clk),
        .power_switch(switch[15]),
        .toggle_switch(switch[0]),
        .btn1(btn_out[0]),
        .btn2(btn_out[1]),
        .btn3(btn_out[2]),
        .btn4(btn_out[3]),
        .clk_500ms(clk_500ms),
        .clk_1s(clk_1s),
        .hexs(hexs),
        .points(points),
        .LEs(LEs),
        .buzzer_en(buzzer_en),
        .state(state)
    );

    LEDP2S ledp2s_inst(
        .clk(clk),
        .start(start),
        .par_in(parin),
        .sclk(ledclk),
        .sclrn(ledclrn),
        .sout(ledsout),
        .EN(LEDEN)
    );

    Sseg_Dev sseg_dev_inst(
        .clk(clk),
        .start(start),
        .hexs(hexs),
        .points(points),
        .LEs(LEs),
        .sclk(seg_clk),
        .sclrn(seg_clrn),
        .sout(seg_sout),
        .EN(seg_pen)
    );

    buzzer_drv buzzer__drv_inst(
        .clk(clk),
        .EN(buzzer_en),
        .note(5'd12),
        .beep(buzzer)
    );

    vga_top vga_top_inst(
        .clk(clk),
        .rst(RSTN),
        .switch(switch),
        .crt(crt),
        .wp0(wp0), .wp1(wp1), .wp2(wp2), .wp3(wp3), .wp4(wp4), .wp5(wp5), .wp6(wp6), .wp7(wp7),
        .wr0(wr0), .wr1(wr1), .wn0(wn0), .wn1(wn1), .wb0(wb0), .wb1(wb1), .wq(wq), .wk(wk),
        .bp0(bp0), .bp1(bp1), .bp2(bp2), .bp3(bp3), .bp4(bp4), .bp5(bp5), .bp6(bp6), .bp7(bp7),
        .br0(br0), .br1(br1), .bn0(bn0), .bn1(bn1), .bb0(bb0), .bb1(bb1), .bq(bq), .bk(bk),
        .vga_red(vga_red), .vga_green(vga_green), .vga_blue(vga_blue),
        .vga_hs(vga_hs), .vga_vs(vga_vs)
    );

endmodule