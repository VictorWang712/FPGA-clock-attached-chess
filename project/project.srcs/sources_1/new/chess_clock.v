`timescale 1ns / 1ps

module chess_clock(
    input wire clk,              // Main clock
    input wire power_switch,     // Power switch
    input wire toggle_switch,    // Toggle switch
    input wire btn1,             // Button 1
    input wire btn2,             // Button 2
    input wire btn3,             // Button 3
    input wire btn4,             // Button 4
    input wire clk_1s,           // 1-second clock signal
    output reg [31:0] hexs,      // Output to seven-segment display
    output reg [7:0] points,     // Decimal points for seven-segment display
    output reg [7:0] LEs,        // Enable signals for seven-segment display
    output reg buzzer_en,        // Buzzer enable signal
    output reg [2:0] state
);

    // State definitions (using binary encoding)
    parameter STATE_OFF = 3'b000,
              STATE_RESET = 3'b001,
              STATE_SET_BASE_TIME = 3'b010,
              STATE_SET_ADD_TIME = 3'b011,
              STATE_READY = 3'b100,
              STATE_COUNTDOWN = 3'b101,
              STATE_PAUSE = 3'b110,
              STATE_TERMINATE = 3'b111;

    reg [15:0] base, add, p1, p2;

    reg [2:0] current_state, next_state;

    // Internal registers
    reg [3:0] base_minutes_high, base_minutes_low;
    reg [3:0] base_seconds_high, base_seconds_low;
    reg [3:0] add_minutes_high, add_minutes_low;
    reg [3:0] add_seconds_high, add_seconds_low;
    reg [3:0] player1_minutes_high, player1_minutes_low;
    reg [3:0] player1_seconds_high, player1_seconds_low;
    reg [3:0] player2_minutes_high, player2_minutes_low;
    reg [3:0] player2_seconds_high, player2_seconds_low;
    reg [2:0] edit_position;     // Current editing position
    reg is_player1_turn;         // Indicates whose turn it is
    reg countdown_paused;        // Pause flag for countdown
    reg flick;

    wire [31:0] clk_div;

    clkdiv m0(.clk(clk), .rst(0), .div_res(clk_div));

    // Default values
    initial begin
        current_state = STATE_OFF;
    end

    // State transition logic
    always @(posedge clk) begin
        state = current_state;
        if (power_switch == 1'b1) begin
            current_state = next_state;
        end else begin
            current_state = STATE_OFF;
        end
    end

    // Next state logic
    always @(posedge btn1) begin
        case (current_state)
            STATE_SET_BASE_TIME: begin
                if (edit_position == 3'd3) next_state = STATE_SET_ADD_TIME;
            end
            STATE_SET_ADD_TIME: begin
                if (edit_position == 3'd3) next_state = STATE_READY;
            end
            STATE_READY: begin
                next_state = STATE_SET_BASE_TIME;
            end
            STATE_PAUSE: begin
                next_state = STATE_READY;
            end
            STATE_TERMINATE: begin
                next_state = STATE_READY;
            end
        endcase
    end

    always @(posedge btn4) begin
        case (current_state)
            STATE_READY: begin
                next_state = STATE_COUNTDOWN;
            end
            STATE_COUNTDOWN: begin
                next_state = STATE_PAUSE;
            end
            STATE_PAUSE: begin
                next_state = STATE_COUNTDOWN;
            end
        endcase
    end

    always @(posedge clk) begin
        case (current_state)
            STATE_OFF: begin
                next_state = STATE_READY;
            end
            STATE_COUNTDOWN: begin
                if ((p1 == 16'b0) || (p2 == 16'b0)) begin
                    next_state = STATE_TERMINATE;
                end
            end
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        base_minutes_high = (base / 8'd60) / 4'd10;
        base_minutes_low = (base / 8'd60) % 4'd10;
        base_seconds_high = (base % 8'd60) / 4'd10;
        base_seconds_low = (base % 8'd60) % 4'd10;
        add_minutes_high = (add / 8'd60) / 4'd10;
        add_minutes_low = (add / 8'd60) % 4'd10;
        add_seconds_high = (add % 8'd60) / 4'd10;
        add_seconds_low = (add % 8'd60) % 4'd10;
        player1_minutes_high = (p1 / 8'd60) / 4'd10;
        player1_minutes_low = (p1 / 8'd60) % 4'd10;
        player1_seconds_high = (p1 % 8'd60) / 4'd10;
        player1_seconds_low = (p1 % 8'd60) % 4'd10;
        player2_minutes_high = (p2 / 8'd60) / 4'd10;
        player2_minutes_low = (p2 / 8'd60) % 4'd10;
        player2_seconds_high = (p2 % 8'd60) / 4'd10;
        player2_seconds_low = (p2 % 8'd60) % 4'd10;
    end

    always @(posedge clk_1s) begin
        if (current_state == STATE_COUNTDOWN && ~countdown_paused) begin
            if (is_player1_turn) p1 = p1 - 1;
            else p2 = p2 - 1;
        end        
    end

    always @(posedge clk_1s) begin
        flick = ~flick;
    end

    always @(negedge clk_1s) begin
        flick = ~flick;
    end

    always @(posedge btn1) begin
        case (current_state)
            STATE_SET_BASE_TIME: edit_position = (edit_position == 3'd3) ? 3'd0 : edit_position + 1;
            STATE_SET_ADD_TIME: edit_position = (edit_position == 3'd3) ? 3'd0 : edit_position + 1;
        endcase
    end

    always @(posedge btn2) begin
        case (current_state)
            STATE_SET_BASE_TIME: begin
                case (edit_position)
                    3'd0: base = base + 16'd600;
                    3'd1: base = base + 16'd60;
                    3'd2: base = base + 16'd10;
                    3'd3: base = base + 16'd1;
                endcase
            end
            STATE_SET_ADD_TIME: begin
                case (edit_position)
                    3'd0: add = add + 16'd600;
                    3'd1: add = add + 16'd60;
                    3'd2: add = add + 16'd10;
                    3'd3: add = add + 16'd1;
                endcase
            end
        endcase
    end

    always @(posedge btn3) begin
        case (current_state)
            STATE_SET_BASE_TIME: begin
                case (edit_position)
                    3'd0: base = base - 16'd600;
                    3'd1: base = base - 16'd60;
                    3'd2: base = base - 16'd10;
                    3'd3: base = base - 16'd1;
                endcase
            end
            STATE_SET_ADD_TIME: begin
                case (edit_position)
                    3'd0: add = add - 16'd600;
                    3'd1: add = add - 16'd60;
                    3'd2: add = add - 16'd10;
                    3'd3: add = add - 16'd1;
                endcase
            end
        endcase
    end

    always @(posedge toggle_switch) begin        
        if (is_player1_turn) begin
            p1 = p1 + add;
        end else begin
            p2 = p2 + add;
        end
        is_player1_turn = ~is_player1_turn;
    end

    always @(negedge toggle_switch) begin        
        if (is_player1_turn) begin
            p1 = p1 + add;
        end else begin
            p2 = p2 + add;
        end
        is_player1_turn = ~is_player1_turn;
    end

    always @(posedge clk) begin
        case (current_state)
            STATE_OFF: begin
                hexs = 32'h00000000;
                points = 8'b00000000;
                LEs = 8'b00000000;
                base = 16'b0000_0011_1000_0100; // 15min = 900s
                add = 16'b0000_0000_0000_1010; // 10s
                p1 = 16'b0000_0011_1000_0100;
                p2 = 16'b0000_0011_1000_0100;
                edit_position = 3'd0;
                is_player1_turn = 1'b1;
                countdown_paused = 1'b0;
                buzzer_en = 1'b0;
                flick = 1'b0;
            end
            STATE_SET_BASE_TIME: begin
                hexs = {4'hB, 4'hA, 4'h5, 4'h0, base_minutes_high, base_minutes_low, base_seconds_high, base_seconds_low};
                points = 8'b00000100;
                case (edit_position)
                    3'd0: LEs = {4'b1110, flick, 3'b111};
                    3'd1: LEs = {5'b11101, flick, 2'b11};
                    3'd2: LEs = {6'b111011, flick, 1'b1};
                    3'd3: LEs = {7'b1110111, flick};
                endcase
            end
            STATE_SET_ADD_TIME: begin
                hexs = {4'h1, 4'hF, 4'hC, 4'h0, add_minutes_high, add_minutes_low, add_seconds_high, add_seconds_low};
                points = 8'b00000100;
                case (edit_position)
                    3'd0: LEs = {4'b1110, flick, 3'b111};
                    3'd1: LEs = {5'b11101, flick, 2'b11};
                    3'd2: LEs = {6'b111011, flick, 1'b1};
                    3'd3: LEs = {7'b1110111, flick};
                endcase
            end
            STATE_READY: begin
                p1 = base;
                p2 = base;
                hexs = {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points = 8'b01010100;
                LEs = 8'b11111111;
                buzzer_en = 1'b0;
            end
            STATE_COUNTDOWN: begin
                countdown_paused = 1'b0;
                hexs = {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points = 8'b01010100;
                LEs = 8'b11111111;
            end
            STATE_PAUSE: begin
                countdown_paused = 1'b1;
                hexs = {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points = {1'b0, flick, 1'b0, flick, 1'b0, flick, 2'b0};
                LEs = {flick, flick, flick, flick, flick, flick, flick, flick};
            end
            STATE_TERMINATE: begin
                buzzer_en = flick;
                hexs = {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points = 8'b01010100;
                LEs = 8'b11111111;
            end
        endcase
    end

endmodule