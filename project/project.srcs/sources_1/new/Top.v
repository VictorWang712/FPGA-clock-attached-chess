`timescale 1ns / 1ps

module Top(
    input wire clk,
    input wire BTN_Y0,
    input wire BTN_Y1,
    input wire BTN_Y2,
    input wire BTN_Y3,
    input wire [15:0] switch,
    output wire ledclk,
    output wire ledclrn,
    output wire ledsout,
    output wire LEDEN,
    output wire seg_clk,
    output wire seg_sout,
    output wire seg_clrn,
    output wire seg_pen,
    output wire buzzer,
    output wire BTN_X4
);

    // Internal signals
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

    assign BTN_X4 = 1'b0;
    assign parin = {btn_out[3:0], 9'b000000000, state[2:0]};

    // Instantiate modules
    clkdiv clkdiv_inst(.clk(clk), .rst(1'b0), .div_res(divres));
    assign start = divres[20];

    clk_500ms clk_500ms_inst(.clk(clk), .clk_500ms(clk_500ms));
    clk_1s clk_1s_inst(.clk(clk), .clk_1s(clk_1s));

    pbdebounce m1(.clk(divres[17]), .button(BTN_Y0), .pbreg(btn_out[0]));
    pbdebounce m2(.clk(divres[17]), .button(BTN_Y1), .pbreg(btn_out[1]));
    pbdebounce m3(.clk(divres[17]), .button(BTN_Y2), .pbreg(btn_out[2]));
    pbdebounce m4(.clk(divres[17]), .button(BTN_Y3), .pbreg(btn_out[3]));

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

    buzzer_driver buzzer_inst(
        .clk(clk),
        .EN(buzzer_en),
        .note(5'd12),
        .beep(buzzer)
    );

endmodule