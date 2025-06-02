`timescale 1ns / 1ps
module key_top(
    input clk,
    input PS2_clk, 
    input PS2_data,
    output ledclk,
    output ledclrn,
    output ledsout,
    output LEDEN
);

    wire start;
    wire [4:0] key;
    wire [31:0] divres;
    wire [15:0] parin;

    key_input key_input_inst(.clk(clk), .ps2_clk(PS2_clk), .ps2_data(PS2_data), .key(key));

    clkdiv clkdiv_inst(.clk(clk), .rst(1'b0), .div_res(divres));
    assign start = divres[20];

    assign parin = {key[4:0], 11'b00000000000};

    LEDP2S ledp2s_inst(
        .clk(clk),
        .start(start),
        .par_in(parin),
        .sclk(ledclk),
        .sclrn(ledclrn),
        .sout(ledsout),
        .EN(LEDEN)
    );



endmodule
