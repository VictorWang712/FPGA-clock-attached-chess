`timescale 1ns / 1ps

module chess_clock_tb;

    // Inputs
    reg clk;
    reg power_switch;
    reg toggle_switch;
    reg btn1;
    reg btn2;
    reg btn3;
    reg btn4;
    reg clk_1s;

    // Outputs
    wire [31:0] hexs;
    wire [7:0] points;
    wire [7:0] LEs;
    wire buzzer_en;
    wire [4:0] note;
    wire [2:0] state;

    // Instantiate the Unit Under Test (UUT)
    chess_clock uut (
        .clk(clk),
        .power_switch(power_switch),
        .toggle_switch(toggle_switch),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .btn4(btn4),
        .clk_1s(clk_1s),
        .hexs(hexs),
        .points(points),
        .LEs(LEs),
        .buzzer_en(buzzer_en),
        .state(state)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 100 MHz clock (5 ns period)
    end

    // 1-second clock generation
    initial begin
        clk_1s = 1;
        forever #50000000 clk_1s = ~clk_1s; // 1 Hz clock (50,000,000 ns period)
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        power_switch = 1'b1;
        toggle_switch = 1'b0;
        btn1 = 1'b0;
        btn2 = 1'b0;
        btn3 = 1'b0;
        btn4 = 1'b0;

        // Wait for system to stabilize
        #100;

        // Press BTN_Y4 to start countdown
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn2 = 1'b1;
        #40;
        btn2 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn3 = 1'b1;
        #40;
        btn3 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn1 = 1'b1;
        #40;
        btn1 = 1'b0;

        #20;
        btn4 = 1'b1;
        #40;
        btn4 = 1'b0;

        #100;
        toggle_switch = ~toggle_switch;

        #100;
        toggle_switch = ~toggle_switch;

        #100;
        toggle_switch = ~toggle_switch;

        #20;
        btn4 = 1'b1;
        #10;
        btn4 = 1'b0;

        #100;
        btn1 = 1'b1;
        #10;
        btn1 = 1'b0;

        // Observe countdown behavior
        #100000000; // Run simulation for 1 second

        // End simulation
        $stop;
    end

endmodule