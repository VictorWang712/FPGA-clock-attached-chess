`timescale 1ns / 1ps

module chess_tb;

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [4:0] key;

    // Outputs
    wire [5:0] crt;
    wire [7:0] wp0, wp1, wp2, wp3, wp4, wp5, wp6, wp7;
    wire [7:0] wr0, wr1, wn0, wn1, wb0, wb1, wq, wk;
    wire [7:0] bp0, bp1, bp2, bp3, bp4, bp5, bp6, bp7;
    wire [7:0] br0, br1, bn0, bn1, bb0, bb1, bq, bk;

    // Instantiate the chess module
    chess uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .key(key),
        .crt(crt),
        .wp0(wp0), .wp1(wp1), .wp2(wp2), .wp3(wp3), .wp4(wp4), .wp5(wp5), .wp6(wp6), .wp7(wp7),
        .wr0(wr0), .wr1(wr1), .wn0(wn0), .wn1(wn1), .wb0(wb0), .wb1(wb1), .wq(wq), .wk(wk),
        .bp0(bp0), .bp1(bp1), .bp2(bp2), .bp3(bp3), .bp4(bp4), .bp5(bp5), .bp6(bp6), .bp7(bp7),
        .br0(br0), .br1(br1), .bn0(bn0), .bn1(bn1), .bb0(bb0), .bb1(bb1), .bq(bq), .bk(bk)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize Inputs
        rst = 1;
        start = 0;
        key = 5'b00000;

        // Wait for global reset
        #10;
        rst = 0;
        start = 1;

        // Move the active square to the left
        #10 key = 5'b10000; // left
        #10 key = 5'b00000; // release

        // Move the active square up
        #10 key = 5'b00010; // down
        #10 key = 5'b00000; // release

        // Move the active square up
        #10 key = 5'b00010; // down
        #10 key = 5'b00000; // release

        // Select a piece (assuming wp3 at d2)
        #10 key = 5'b00001; // enter
        #10 key = 5'b00000; // release

        // Move the active square to a new position
        #10 key = 5'b01000; // right
        #10 key = 5'b00000; // release
        #10 key = 5'b00010; // down
        #10 key = 5'b00000; // release

        // Move the selected piece to the new position
        #10 key = 5'b00001; // enter
        #10 key = 5'b00000; // release

        // End simulation
        #50 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %0dns, crt: %b, wp3: %b", $time, crt, wp3);
    end

endmodule