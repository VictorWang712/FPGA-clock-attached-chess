`timescale 1ns / 1ps

module buzzer_driver(
    input clk,
    input EN,
    input [4:0] note,
    output reg beep
);

reg [17:0] half_period;
always @(*) begin
    case(note)
        5'd0:  half_period = 18'd191110;  // C4 (261.63Hz)
        5'd1:  half_period = 18'd180386;  // C#4 (277.18Hz)
        5'd2:  half_period = 18'd170262;  // D4 (293.66Hz)
        5'd3:  half_period = 18'd160705;  // D#4 (311.13Hz)
        5'd4:  half_period = 18'd151685;  // E4 (329.63Hz)
        5'd5:  half_period = 18'd143172;  // F4 (349.23Hz)
        5'd6:  half_period = 18'd135138;  // F#4 (369.99Hz)
        5'd7:  half_period = 18'd127552;  // G4 (392.00Hz)
        5'd8:  half_period = 18'd120395;  // G#4 (415.30Hz)
        5'd9:  half_period = 18'd113636;  // A4 (440.00Hz)
        5'd10: half_period = 18'd107258;  // A#4 (466.16Hz)
        5'd11: half_period = 18'd101238;  // B4 (493.88Hz)
        5'd12: half_period = 18'd95555;   // C5 (523.25Hz)
        5'd13: half_period = 18'd90193;   // C#5 (554.37Hz)
        5'd14: half_period = 18'd85131;   // D5 (587.33Hz)
        5'd15: half_period = 18'd80352;   // D#5 (622.25Hz)
        5'd16: half_period = 18'd75842;   // E5 (659.25Hz)
        5'd17: half_period = 18'd71586;   // F5 (698.46Hz)
        5'd18: half_period = 18'd67569;   // F#5 (739.99Hz)
        5'd19: half_period = 18'd63776;   // G5 (783.99Hz)
        5'd20: half_period = 18'd60197;   // G#5 (830.61Hz)
        5'd21: half_period = 18'd56818;   // A5 (880.00Hz)
        5'd22: half_period = 18'd53629;   // A#5 (932.33Hz)
        5'd23: half_period = 18'd50619;   // B5 (987.77Hz)
        5'd24: half_period = 18'd47777;   // C6 (1046.50Hz)
        5'd25: half_period = 18'd45096;   // C#6 (1108.73Hz)
        5'd26: half_period = 18'd42565;   // D6 (1174.66Hz)
        5'd27: half_period = 18'd40176;   // D#6 (1244.51Hz)
        5'd28: half_period = 18'd37921;   // E6 (1318.51Hz)
        5'd29: half_period = 18'd35793;   // F6 (1396.91Hz)
        5'd30: half_period = 18'd33784;   // F#6 (1479.98Hz)
        5'd31: half_period = 18'd31888;   // G6 (1567.98Hz)
        default: half_period = 18'd191110; // default: C4
    endcase
end

reg [17:0] counter = 0;

always @(posedge clk) begin
    if (!EN) begin
        beep <= 1'b0;
        counter <= 0;
    end else if (counter >= half_period) begin
        beep <= ~beep;       
        counter <= 0;        
    end else begin
        counter <= counter + 1; 
    end
end

endmodule