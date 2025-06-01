`timescale 1ns / 1ps

module chess_clock(
    input wire clk, // Main clock
    input wire power_switch, // Power switch
    input wire toggle_switch, // Toggle switch
    input wire btn1, // Button 1
    input wire btn2, // Button 2
    input wire btn3, // Button 3
    input wire btn4, // Button 4
    input wire clk_500ms, // 0.5-second clock signal
    input wire clk_1s, // 1-second clock signal
    output reg [31:0] hexs, // Output to seven-segment display
    output reg [7:0] points, // Decimal points for seven-segment display
    output reg [7:0] LEs, // Enable signals for seven-segment display
    output reg buzzer_en, // Buzzer enable signal
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

    // Button edge detection registers
    reg btn1_del, btn2_del, btn3_del, btn4_del, tsw_del, clk_1s_del;
    wire btn1_rise, btn2_rise, btn3_rise, btn4_rise, tsw_rise, tsw_fall, clk_1s_rise;

    assign btn1_rise = btn1 & ~btn1_del;
    assign btn2_rise = btn2 & ~btn2_del;
    assign btn3_rise = btn3 & ~btn3_del;
    assign btn4_rise = btn4 & ~btn4_del;
    assign tsw_rise = toggle_switch & ~tsw_del;
    assign tsw_fall = ~toggle_switch & tsw_del;
    assign clk_1s_rise = clk_1s & ~clk_1s_del;

    // Default values
    initial begin
        current_state = STATE_OFF;
        next_state = STATE_OFF;
        base = 16'd900; // 15min = 900s
        add = 16'd10;   // 10s
        p1 = 16'd900;
        p2 = 16'd900;
        edit_position = 3'd0;
        is_player1_turn = 1'b1;
        countdown_paused = 1'b0;
        buzzer_en = 1'b0;
        flick = 1'b0;
        btn1_del = 0;
        btn2_del = 0;
        btn3_del = 0;
        btn4_del = 0;
        tsw_del = 0;
        clk_1s_del = 0;
    end

    // Button edge detection
    always @(posedge clk) begin
        btn1_del <= btn1;
        btn2_del <= btn2;
        btn3_del <= btn3;
        btn4_del <= btn4;
        tsw_del <= toggle_switch;
        clk_1s_del <= clk_1s;
    end

    // State register
    always @(posedge clk) begin
        if (!power_switch) begin
            current_state <= STATE_OFF;
        end else begin
            current_state <= next_state;
        end
        state <= current_state;  // Output state
    end

    // Next state logic
    always @(*) begin
        next_state = current_state;  // Default stay in current state
        
        case (current_state)
            STATE_OFF: 
                if (power_switch) 
                    next_state = STATE_READY;
            
            STATE_READY: begin
                if (btn1_rise) 
                    next_state = STATE_SET_BASE_TIME;
                else if (btn4_rise) 
                    next_state = STATE_COUNTDOWN;
            end
            
            STATE_SET_BASE_TIME: begin
                if (btn1_rise && (edit_position == 3'd3))
                    next_state = STATE_SET_ADD_TIME;
            end
            
            STATE_SET_ADD_TIME: begin
                if (btn1_rise && (edit_position == 3'd3))
                    next_state = STATE_READY;
            end
            
            STATE_COUNTDOWN: begin
                if (btn4_rise) 
                    next_state = STATE_PAUSE;
                else if ((p1 == 0) || (p2 == 0)) 
                    next_state = STATE_TERMINATE;
            end
            
            STATE_PAUSE: begin
                if (btn4_rise) 
                    next_state = STATE_COUNTDOWN;
                else if (btn1_rise) 
                    next_state = STATE_READY;
            end
            
            STATE_TERMINATE: begin
                if (btn1_rise) 
                    next_state = STATE_READY;
            end
        endcase
    end

    // Edit position logic
    always @(posedge clk) begin
        if (current_state == STATE_SET_BASE_TIME || current_state == STATE_SET_ADD_TIME) begin
            if (btn1_rise) begin
                edit_position <= (edit_position == 3'd3) ? 3'd0 : edit_position + 1;
            end
        end else begin
            edit_position <= 3'd0;
        end
    end

    // Time adjustment logic
    always @(posedge clk) begin
        if (current_state == STATE_SET_BASE_TIME) begin
            if (btn2_rise) begin
                case (edit_position)
                    0: base <= base + 16'd600;
                    1: base <= base + 16'd60;
                    2: base <= base + 16'd10;
                    3: base <= base + 16'd1;
                endcase
            end
            else if (btn3_rise) begin
                case (edit_position)
                    0: base <= (base >= 600) ? base - 16'd600 : 0;
                    1: base <= (base >= 60) ? base - 16'd60 : 0;
                    2: base <= (base >= 10) ? base - 16'd10 : 0;
                    3: base <= (base >= 1) ? base - 16'd1 : 0;
                endcase
            end
        end
        else if (current_state == STATE_SET_ADD_TIME) begin
            if (btn2_rise) begin
                case (edit_position)
                    0: add <= add + 16'd600;
                    1: add <= add + 16'd60;
                    2: add <= add + 16'd10;
                    3: add <= add + 16'd1;
                endcase
            end
            else if (btn3_rise) begin
                case (edit_position)
                    0: add <= (add >= 600) ? add - 16'd600 : 0;
                    1: add <= (add >= 60) ? add - 16'd60 : 0;
                    2: add <= (add >= 10) ? add - 16'd10 : 0;
                    3: add <= (add >= 1) ? add - 16'd1 : 0;
                endcase
            end
        end
    end

    // Player time logic
    always @(posedge clk) begin
        if (current_state == STATE_READY) begin
            p1 <= base;
            p2 <= base;
        end
        else if (current_state == STATE_COUNTDOWN) begin
            if (clk_1s_rise) begin
                if (is_player1_turn) 
                    p1 <= (p1 > 0) ? p1 - 1 : 0;
                else 
                    p2 <= (p2 > 0) ? p2 - 1 : 0;
            end
            if (tsw_rise) begin
                if (is_player1_turn) 
                    p1 <= p1 + add;
                else 
                    p2 <= p2 + add;
                is_player1_turn <= ~is_player1_turn;
            end
            else if (tsw_fall) begin
                if (is_player1_turn) 
                    p1 <= p1 + add;
                else 
                    p2 <= p2 + add;
                is_player1_turn <= ~is_player1_turn;
            end
        end
    end

    // Time display calculations
    always @(*) begin
        base_minutes_high = (base / 16'd60) / 4'd10;
        base_minutes_low = (base / 16'd60) % 4'd10;
        base_seconds_high = (base % 16'd60) / 4'd10;
        base_seconds_low = (base % 16'd60) % 4'd10;
        
        add_minutes_high = (add / 16'd60) / 4'd10;
        add_minutes_low = (add / 16'd60) % 4'd10;
        add_seconds_high = (add % 16'd60) / 4'd10;
        add_seconds_low = (add % 16'd60) % 4'd10;
        
        player1_minutes_high = (p1 / 16'd60) / 4'd10;
        player1_minutes_low = (p1 / 16'd60) % 4'd10;
        player1_seconds_high = (p1 % 16'd60) / 4'd10;
        player1_seconds_low = (p1 % 16'd60) % 4'd10;
        
        player2_minutes_high = (p2 / 16'd60) / 4'd10;
        player2_minutes_low = (p2 / 16'd60) % 4'd10;
        player2_seconds_high = (p2 % 16'd60) / 4'd10;
        player2_seconds_low = (p2 % 16'd60) % 4'd10;
    end

    // Flicker control for editing
    always @(posedge clk_500ms) begin
        flick <= ~flick;
    end

    // Output generation
    always @(posedge clk) begin
        case (current_state)
            STATE_OFF: begin
                hexs <= 32'h00000000;
                points <= 8'b00000000;
                LEs <= 8'b00000000;
                buzzer_en <= 1'b0;
            end
            
            STATE_SET_BASE_TIME: begin
                hexs <= {4'hB, 4'hA, 4'h5, 4'h0, base_minutes_high, base_minutes_low, base_seconds_high, base_seconds_low};
                points <= 8'b00000100;
                case (edit_position)
                    0: LEs <= {4'b1110, flick, 3'b111};
                    1: LEs <= {5'b11101, flick, 2'b11};
                    2: LEs <= {6'b111011, flick, 1'b1};
                    3: LEs <= {7'b1110111, flick};
                    default: LEs <= 8'b11111111;
                endcase
                buzzer_en <= 1'b0;
            end
            
            STATE_SET_ADD_TIME: begin
                hexs <= {4'h1, 4'hF, 4'hC, 4'h0, add_minutes_high, add_minutes_low, add_seconds_high, add_seconds_low};
                points <= 8'b00000100;
                case (edit_position)
                    0: LEs <= {4'b1110, flick, 3'b111};
                    1: LEs <= {5'b11101, flick, 2'b11};
                    2: LEs <= {6'b111011, flick, 1'b1};
                    3: LEs <= {7'b1110111, flick};
                    default: LEs <= 8'b11111111;
                endcase
                buzzer_en <= 1'b0;
            end
            
            STATE_READY: begin
                hexs <= {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, 
                        player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points <= 8'b01010100;
                LEs <= 8'b11111111;
                buzzer_en <= 1'b0;
            end
            
            STATE_COUNTDOWN: begin
                countdown_paused <= 1'b0;
                hexs <= {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, 
                        player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points <= 8'b01010100;
                LEs <= 8'b11111111;
                buzzer_en <= 1'b0;
            end
            
            STATE_PAUSE: begin
                countdown_paused <= 1'b1;
                hexs <= {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, 
                        player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points <= {1'b0, flick, 1'b0, flick, 1'b0, flick, 2'b00};
                LEs <= {8{flick}};
                buzzer_en <= 1'b0;
            end
            
            STATE_TERMINATE: begin
                hexs <= {player1_minutes_high, player1_minutes_low, player1_seconds_high, player1_seconds_low, 
                        player2_minutes_high, player2_minutes_low, player2_seconds_high, player2_seconds_low};
                points <= 8'b01010100;
                LEs <= 8'b11111111;
                buzzer_en <= flick;
            end
            
            default: begin
                hexs <= 32'h00000000;
                points <= 8'b00000000;
                LEs <= 8'b00000000;
                buzzer_en <= 1'b0;
            end
        endcase
    end

endmodule