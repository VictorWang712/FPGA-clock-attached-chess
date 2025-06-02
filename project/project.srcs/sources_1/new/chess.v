`timescale 1ns / 1ps

module chess(
    input clk,
    input rst,
    input start,
    input wire [4:0] key,
    output reg [5:0] crt,
    output reg [7:0] wp0, wp1, wp2, wp3, wp4, wp5, wp6, wp7,
    output reg [7:0] wr0, wr1, wn0, wn1, wb0, wb1, wq, wk,
    output reg [7:0] bp0, bp1, bp2, bp3, bp4, bp5, bp6, bp7,
    output reg [7:0] br0, br1, bn0, bn1, bb0, bb1, bq, bk
);

    // Internal registers for key state tracking
    reg [4:0] prev_key;
    reg selected; // Flag to indicate if a piece is currently selected
    reg [7:0] selected_piece; // Store the currently selected piece
    reg [5:0] left, prev_left;

    // Reset and initialize positions
    always @(posedge clk) begin
        if (rst) begin
            // Reset all pieces to their initial positions
            crt <= 6'b011011;
            wp0 <= 8'b10000001; wp1 <= 8'b10001001; wp2 <= 8'b10010001; wp3 <= 8'b10011001;
            wp4 <= 8'b10100001; wp5 <= 8'b10101001; wp6 <= 8'b10110001; wp7 <= 8'b10111001;
            wr0 <= 8'b10000000; wr1 <= 8'b10111000;
            wn0 <= 8'b10001000; wn1 <= 8'b10110000;
            wb0 <= 8'b10010000; wb1 <= 8'b10101000;
            wq  <= 8'b10011000; wk  <= 8'b10100000;
            bp0 <= 8'b10000110; bp1 <= 8'b10001110; bp2 <= 8'b10010110; bp3 <= 8'b10011110;
            bp4 <= 8'b10100110; bp5 <= 8'b10101110; bp6 <= 8'b10110110; bp7 <= 8'b10111110;
            br0 <= 8'b10000111; br1 <= 8'b10111111;
            bn0 <= 8'b10001111; bn1 <= 8'b10110111;
            bb0 <= 8'b10010111; bb1 <= 8'b10101111;
            bq  <= 8'b10011111; bk  <= 8'b10100111;
            selected <= 0;
            selected_piece <= 8'b0;
            left <= 6'd31;
        end else if (start) begin
            // Handle movement keys
            if (key[4] && !prev_key[4]) begin
                // Move left
                if (crt[5:3] > 3'b000) begin
                    crt[5:3] <= crt[5:3] - 1;
                end
            end
            if (key[3] && !prev_key[3]) begin
                // Move right
                if (crt[5:3] < 3'b111) begin
                    crt[5:3] <= crt[5:3] + 1;
                end
            end
            if (key[2] && !prev_key[2]) begin
                // Move up
                if (crt[2:0] < 3'b111) begin
                    crt[2:0] <= crt[2:0] + 1;
                end
            end
            if (key[1] && !prev_key[1]) begin
                // Move down
                if (crt[2:0] > 3'b000) begin
                    crt[2:0] <= crt[2:0] - 1;
                end
            end
            // Handle enter key
            if (key[0] && !prev_key[0]) begin
                if (!selected) begin
                    // Select a piece if not already selected
                    selected_piece = select_piece(crt);
                    if (selected_piece[7]) begin
                        selected <= 1;
                    end
                end else begin
                    // Move the selected piece
                    remove_piece(crt);
                    if (left ^ prev_left) begin
                        move_piece(selected_piece, crt);
                    end
                    selected <= 0;
                end
            end
        end
        prev_key <= key;
        prev_left <= left;
    end

    // Function to select a piece based on current position
    function [7:0] select_piece(input [5:0] position);
        begin
            // Check each piece to see if it matches the current position
            // Return the first matching piece
            if (wp0[5:0] == position) begin
                wp0[6] = 1;
                select_piece = wp0;
                
            end
            else if (wp1[5:0] == position) begin
                wp1[6] = 1;
                select_piece = wp1;
            end
            else if (wp2[5:0] == position) begin
                wp2[6] = 1;
                select_piece = wp2;
            end
            else if (wp3[5:0] == position) begin
                wp3[6] = 1;
                select_piece = wp3;
            end
            else if (wp4[5:0] == position) begin
                wp4[6] = 1;
                select_piece = wp4;
            end
            else if (wp5[5:0] == position) begin
                wp5[6] = 1;
                select_piece = wp5;
            end
            else if (wp6[5:0] == position) begin
                wp6[6] = 1;
                select_piece = wp6;
            end
            else if (wp7[5:0] == position) begin
                wp7[6] = 1;
                select_piece = wp7;
            end
            else if (wr0[5:0] == position) begin
                wr0[6] = 1;
                select_piece = wr0;
            end
            else if (wr1[5:0] == position) begin
                wr1[6] = 1;
                select_piece = wr1;
            end
            else if (wn0[5:0] == position) begin
                wn0[6] = 1;
                select_piece = wn0;
            end
            else if (wn1[5:0] == position) begin
                wn1[6] = 1;
                select_piece = wn1;
            end
            else if (wb0[5:0] == position) begin
                wb0[6] = 1;
                select_piece = wb0;
            end
            else if (wb1[5:0] == position) begin
                wb1[6] = 1;
                select_piece = wb1;
            end
            else if (wq[5:0] == position) begin
                wq[6] = 1;
                select_piece = wq;
            end
            else if (wk[5:0] == position) begin
                wk[6] = 1;
                select_piece = wk;
            end
            else if (bp0[5:0] == position) begin
                bp0[6] = 1;
                select_piece = bp0;
            end
            else if (bp1[5:0] == position) begin
                bp1[6] = 1;
                select_piece = bp1;
            end
            else if (bp2[5:0] == position) begin
                bp2[6] = 1;
                select_piece = bp2;
            end
            else if (bp3[5:0] == position) begin
                bp3[6] = 1;
                select_piece = bp3;
            end
            else if (bp4[5:0] == position) begin
                bp4[6] = 1;
                select_piece = bp4;
            end
            else if (bp5[5:0] == position) begin
                bp5[6] = 1;
                select_piece = bp5;
            end
            else if (bp6[5:0] == position) begin
                bp6[6] = 1;
                select_piece = bp6;
            end
            else if (bp7[5:0] == position) begin
                bp7[6] = 1;
                select_piece = bp7;
            end
            else if (br0[5:0] == position) begin
                br0[6] = 1;
                select_piece = br0;
            end
            else if (br1[5:0] == position) begin
                br1[6] = 1;
                select_piece = br1;
            end
            else if (bn0[5:0] == position) begin
                bn0[6] = 1;
                select_piece = bn0;
            end
            else if (bn1[5:0] == position) begin
                bn1[6] = 1;
                select_piece = bn1;
            end
            else if (bb0[5:0] == position) begin
                bb0[6] = 1;
                select_piece = bb0;
            end
            else if (bb1[5:0] == position) begin
                bb1[6] = 1;
                select_piece = bb1;
            end
            else if (bq[5:0] == position) begin
                bq[6] = 1;
                select_piece = bq;
            end
            else if (bk[5:0] == position) begin
                bk[6] = 1;
                select_piece = bk;
            end
            else select_piece = 8'b0; // No piece found
        end
    endfunction

    // Procedure to move a piece to a new position
    task move_piece(input [7:0] piece, input [5:0] new_position);
        begin
            // Update the position of the selected piece
            case (piece)
                wp0: begin
                    wp0 = {piece[7:6], new_position};
                    wp0[6] = 0;
                end
                wp1: begin
                    wp1 = {piece[7:6], new_position};
                    wp1[6] = 0;
                end
                wp2: begin
                    wp2 = {piece[7:6], new_position};
                    wp2[6] = 0;
                end
                wp3: begin
                    wp3 = {piece[7:6], new_position};
                    wp3[6] = 0;
                end
                wp4: begin
                    wp4 = {piece[7:6], new_position};
                    wp4[6] = 0;
                end
                wp5: begin
                    wp5 = {piece[7:6], new_position};
                    wp5[6] = 0;
                end
                wp6: begin
                    wp6 = {piece[7:6], new_position};
                    wp6[6] = 0;
                end
                wp7: begin
                    wp7 = {piece[7:6], new_position};
                    wp7[6] = 0;
                end
                wr0: begin
                    wr0 = {piece[7:6], new_position};
                    wr0[6] = 0;
                end
                wr1: begin
                    wr1 = {piece[7:6], new_position};
                    wr1[6] = 0;
                end
                wn0: begin
                    wn0 = {piece[7:6], new_position};
                    wn0[6] = 0;
                end
                wn1: begin
                    wn1 = {piece[7:6], new_position};
                    wn1[6] = 0;
                end
                wb0: begin
                    wb0 = {piece[7:6], new_position};
                    wb0[6] = 0;
                end
                wb1: begin
                    wb1 = {piece[7:6], new_position};
                    wb1[6] = 0;
                end
                wq:  begin
                    wq  = {piece[7:6], new_position};
                    wq[6] = 0;
                end
                wk:  begin
                    wk  = {piece[7:6], new_position};
                    wk[6] = 0;
                end
                bp0: begin
                    bp0 = {piece[7:6], new_position};
                    bp0[6] = 0;
                end
                bp1: begin
                    bp1 = {piece[7:6], new_position};
                    bp1[6] = 0;
                end
                bp2: begin
                    bp2 = {piece[7:6], new_position};
                    bp2[6] = 0;
                end
                bp3: begin
                    bp3 = {piece[7:6], new_position};
                    bp3[6] = 0;
                end
                bp4: begin
                    bp4 = {piece[7:6], new_position};
                    bp4[6] = 0;
                end
                bp5: begin
                    bp5 = {piece[7:6], new_position};
                    bp5[6] = 0;
                end
                bp6: begin
                    bp6 = {piece[7:6], new_position};
                    bp6[6] = 0;
                end
                bp7: begin
                    bp7 = {piece[7:6], new_position};
                    bp7[6] = 0;
                end
                br0: begin
                    br0 = {piece[7:6], new_position};
                    br0[6] = 0;
                end
                br1: begin
                    br1 = {piece[7:6], new_position};
                    br1[6] = 0;
                end
                bn0: begin
                    bn0 = {piece[7:6], new_position};
                    bn0[6] = 0;
                end
                bn1: begin
                    bn1 = {piece[7:6], new_position};
                    bn1[6] = 0;
                end
                bb0: begin
                    bb0 = {piece[7:6], new_position};
                    bb0[6] = 0;
                end
                bb1: begin
                    bb1 = {piece[7:6], new_position};
                    bb1[6] = 0;
                end
                bq:  begin
                    bq  = {piece[7:6], new_position};
                    bq[6] = 0;
                end
                bk:  begin
                    bk  = {piece[7:6], new_position};
                    bk[6] = 0;
                end
            endcase
        end
    endtask

    // Procedure to remove a piece from a specific position
    task remove_piece(input [5:0] position);
        begin
            // Check each piece and set its presence bit to 0 if it matches the position
            if (wp0[5:0] == position) begin
                wp0[7] = 0;
                left = left - 1'b1;
            end
            else if (wp1[5:0] == position) begin
                wp1[7] = 0;
                left = left - 1'b1;
            end
            else if (wp2[5:0] == position) begin
                wp2[7] = 0;
                left = left - 1'b1;
            end
            else if (wp3[5:0] == position) begin
                wp3[7] = 0;
                left = left - 1'b1;
            end
            else if (wp4[5:0] == position) begin
                wp4[7] = 0;
                left = left - 1'b1;
            end
            else if (wp5[5:0] == position) begin
                wp5[7] = 0;
                left = left - 1'b1;
            end
            else if (wp6[5:0] == position) begin
                wp6[7] = 0;
                left = left - 1'b1;
            end
            else if (wp7[5:0] == position) begin
                wp7[7] = 0;
                left = left - 1'b1;
            end
            else if (wr0[5:0] == position) begin
                wr0[7] = 0;
                left = left - 1'b1;
            end
            else if (wr1[5:0] == position) begin
                wr1[7] = 0;
                left = left - 1'b1;
            end
            else if (wn0[5:0] == position) begin
                wn0[7] = 0;
                left = left - 1'b1;
            end
            else if (wn1[5:0] == position) begin
                wn1[7] = 0;
                left = left - 1'b1;
            end
            else if (wb0[5:0] == position) begin
                wb0[7] = 0;
                left = left - 1'b1;
            end
            else if (wb1[5:0] == position) begin
                wb1[7] = 0;
                left = left - 1'b1;
            end
            else if (wq[5:0] == position) begin
                wq[7] = 0;
                left = left - 1'b1;
            end
            else if (wk[5:0] == position) begin
                wk[7] = 0;
                left = left - 1'b1;
            end
            else if (bp0[5:0] == position) begin
                bp0[7] = 0;
                left = left - 1'b1;
            end
            else if (bp1[5:0] == position) begin
                bp1[7] = 0;
                left = left - 1'b1;
            end
            else if (bp2[5:0] == position) begin
                bp2[7] = 0;
                left = left - 1'b1;
            end
            else if (bp3[5:0] == position) begin
                bp3[7] = 0;
                left = left - 1'b1;
            end
            else if (bp4[5:0] == position) begin
                bp4[7] = 0;
                left = left - 1'b1;
            end
            else if (bp5[5:0] == position) begin
                bp5[7] = 0;
                left = left - 1'b1;
            end
            else if (bp6[5:0] == position) begin
                bp6[7] = 0;
                left = left - 1'b1;
            end
            else if (bp7[5:0] == position) begin
                bp7[7] = 0;
                left = left - 1'b1;
            end
            else if (br0[5:0] == position) begin
                br0[7] = 0;
                left = left - 1'b1;
            end
            else if (br1[5:0] == position) begin
                br1[7] = 0;
                left = left - 1'b1;
            end
            else if (bn0[5:0] == position) begin
                bn0[7] = 0;
                left = left - 1'b1;
            end
            else if (bn1[5:0] == position) begin
                bn1[7] = 0;
                left = left - 1'b1;
            end
            else if (bb0[5:0] == position) begin
                bb0[7] = 0;
                left = left - 1'b1;
            end
            else if (bb1[5:0] == position) begin
                bb1[7] = 0;
                left = left - 1'b1;
            end
            else if (bq[5:0] == position) begin
                bq[7] = 0;
                left = left - 1'b1;
            end
            else if (bk[5:0] == position) begin
                bk[7] = 0;
                left = left - 1'b1;
            end
        end
    endtask

endmodule