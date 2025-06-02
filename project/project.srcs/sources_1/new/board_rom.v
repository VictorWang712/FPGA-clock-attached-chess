module board_rom (
    input clk,
    input [9:0] row_addr,
    input [9:0] col_addr,
    input rdn,
    output reg [11:0] pixel_data
);

parameter IMG_WIDTH = 400;
parameter IMG_HEIGHT = 400;

localparam MEM_SIZE = IMG_WIDTH * IMG_HEIGHT;

reg [11:0] rom_data [0 : MEM_SIZE - 1];

initial begin
    $readmemh("board.mem", rom_data); 
end

wire [9:0] rel_row = row_addr - 9'd41;
wire [9:0] rel_col = col_addr - 10'd121;

wire in_display_area = (row_addr >= 9'd41 && row_addr < 9'd441 &&
                        col_addr >= 10'd121 && col_addr < 10'd521);

wire [18:0] linear_addr = rel_row * IMG_WIDTH + rel_col;

always @(posedge clk) begin
    if (in_display_area)
        pixel_data <= rom_data[linear_addr];
    else
        pixel_data <= 12'h000; 
end

endmodule