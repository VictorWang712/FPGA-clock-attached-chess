module vga_ctrl(
    input clk,
    input rdn,
    input [9:0] row_addr,
    input [9:0] col_addr,
    input [5:0] crt,
    input [7:0] wp0, wp1, wp2, wp3, wp4, wp5, wp6, wp7,
    input [7:0] wr0, wr1, wn0, wn1, wb0, wb1, wq, wk,
    input [7:0] bp0, bp1, bp2, bp3, bp4, bp5, bp6, bp7,
    input [7:0] br0, br1, bn0, bn1, bb0, bb1, bq, bk,
    output reg [11:0] pixel_data
);

    parameter SCR_W = 640;
    parameter SCR_H = 480;
    parameter BRD_W = 400;
    parameter BRD_H = 400;
    parameter GRD_W = 50;
    parameter GRD_H = 50;
    parameter PCE_W = 40;
    parameter PCE_H = 40;

    localparam SCR_MEMSIZE = SCR_W * SCR_H;
    localparam BRD_MEMSIZE = BRD_W * BRD_H;
    localparam GRD_MEMSIZE = GRD_W * GRD_H;
    localparam PCE_MEMSIZE = PCE_W * PCE_H;

    reg [11:0] board_rom_data [0 : BRD_MEMSIZE - 1];
    reg [11:0] slc_rom_data [0 : GRD_MEMSIZE - 1];
    reg [11:0] wp_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] wr_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] wn_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] wb_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] wq_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] wk_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] bp_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] br_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] bn_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] bb_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] bq_rom_data [0 : PCE_MEMSIZE - 1];
    reg [11:0] bk_rom_data [0 : PCE_MEMSIZE - 1];

    initial begin
        $readmemh("board.mem", board_rom_data); 
        $readmemh("slc.mem", slc_rom_data);
        $readmemh("wp.mem", wp_rom_data);
        $readmemh("wr.mem", wr_rom_data);
        $readmemh("wn.mem", wn_rom_data);
        $readmemh("wb.mem", wb_rom_data);
        $readmemh("wq.mem", wq_rom_data);
        $readmemh("wk.mem", wk_rom_data);
        $readmemh("bp.mem", bp_rom_data);
        $readmemh("br.mem", br_rom_data);
        $readmemh("bn.mem", bn_rom_data);
        $readmemh("bb.mem", bb_rom_data);
        $readmemh("bq.mem", bq_rom_data);
        $readmemh("bk.mem", bk_rom_data);
    end

    wire [9:0] board_u = 10'd41;
    wire [9:0] board_l = 10'd121;
    wire in_board = (row_addr >= board_u && row_addr < board_u + BRD_H && col_addr >= board_l && col_addr < board_l + BRD_W);
    wire [9:0] board_rlv_row = row_addr - board_u;
    wire [9:0] board_rlv_col = col_addr - board_l;
    wire [18:0] board_rlv_addr = board_rlv_row * BRD_W + board_rlv_col;

    wire [9:0] crt_u = 10'd391 - crt[2:0] * 10'd50;
    wire [9:0] crt_l = 10'd121 + crt[5:3] * 10'd50;
    wire in_crt = (row_addr >= crt_u && row_addr < crt_u + GRD_H && col_addr >= crt_l && col_addr < crt_l + GRD_W);
    wire [9:0] crt_rlv_row = row_addr - crt_u;
    wire [9:0] crt_rlv_col = col_addr - crt_l;
    wire [18:0] crt_rlv_addr = crt_rlv_row * GRD_W + crt_rlv_col;

    wire [9:0] wp0_u = 10'd396 - wp0[2:0] * 10'd50;
    wire [9:0] wp0_l = 10'd126 + wp0[5:3] * 10'd50;
    wire in_wp0 = (row_addr >= wp0_u && row_addr < wp0_u + PCE_H && col_addr >= wp0_l && col_addr < wp0_l + PCE_W);
    wire [9:0] wp0_rlv_row = row_addr - wp0_u;
    wire [9:0] wp0_rlv_col = col_addr - wp0_l;
    wire [18:0] wp0_rlv_addr = wp0_rlv_row * PCE_W + wp0_rlv_col;

    wire [9:0] wp1_u = 10'd396 - wp1[2:0] * 10'd50;
    wire [9:0] wp1_l = 10'd126 + wp1[5:3] * 10'd50;
    wire in_wp1 = (row_addr >= wp1_u && row_addr < wp1_u + PCE_H && col_addr >= wp1_l && col_addr < wp1_l + PCE_W);
    wire [9:0] wp1_rlv_row = row_addr - wp1_u;
    wire [9:0] wp1_rlv_col = col_addr - wp1_l;
    wire [18:0] wp1_rlv_addr = wp1_rlv_row * PCE_W + wp1_rlv_col;

    wire [9:0] wp2_u = 10'd396 - wp2[2:0] * 10'd50;
    wire [9:0] wp2_l = 10'd126 + wp2[5:3] * 10'd50;
    wire in_wp2 = (row_addr >= wp2_u && row_addr < wp2_u + PCE_H && col_addr >= wp2_l && col_addr < wp2_l + PCE_W);
    wire [9:0] wp2_rlv_row = row_addr - wp2_u;
    wire [9:0] wp2_rlv_col = col_addr - wp2_l;
    wire [18:0] wp2_rlv_addr = wp2_rlv_row * PCE_W + wp2_rlv_col;

    wire [9:0] wp3_u = 10'd396 - wp3[2:0] * 10'd50;
    wire [9:0] wp3_l = 10'd126 + wp3[5:3] * 10'd50;
    wire in_wp3 = (row_addr >= wp3_u && row_addr < wp3_u + PCE_H && col_addr >= wp3_l && col_addr < wp3_l + PCE_W);
    wire [9:0] wp3_rlv_row = row_addr - wp3_u;
    wire [9:0] wp3_rlv_col = col_addr - wp3_l;
    wire [18:0] wp3_rlv_addr = wp3_rlv_row * PCE_W + wp3_rlv_col;

    wire [9:0] wp4_u = 10'd396 - wp4[2:0] * 10'd50;
    wire [9:0] wp4_l = 10'd126 + wp4[5:3] * 10'd50;
    wire in_wp4 = (row_addr >= wp4_u && row_addr < wp4_u + PCE_H && col_addr >= wp4_l && col_addr < wp4_l + PCE_W);
    wire [9:0] wp4_rlv_row = row_addr - wp4_u;
    wire [9:0] wp4_rlv_col = col_addr - wp4_l;
    wire [18:0] wp4_rlv_addr = wp4_rlv_row * PCE_W + wp4_rlv_col;

    wire [9:0] wp5_u = 10'd396 - wp5[2:0] * 10'd50;
    wire [9:0] wp5_l = 10'd126 + wp5[5:3] * 10'd50;
    wire in_wp5 = (row_addr >= wp5_u && row_addr < wp5_u + PCE_H && col_addr >= wp5_l && col_addr < wp5_l + PCE_W);
    wire [9:0] wp5_rlv_row = row_addr - wp5_u;
    wire [9:0] wp5_rlv_col = col_addr - wp5_l;
    wire [18:0] wp5_rlv_addr = wp5_rlv_row * PCE_W + wp5_rlv_col;

    wire [9:0] wp6_u = 10'd396 - wp6[2:0] * 10'd50;
    wire [9:0] wp6_l = 10'd126 + wp6[5:3] * 10'd50;
    wire in_wp6 = (row_addr >= wp6_u && row_addr < wp6_u + PCE_H && col_addr >= wp6_l && col_addr < wp6_l + PCE_W);
    wire [9:0] wp6_rlv_row = row_addr - wp6_u;
    wire [9:0] wp6_rlv_col = col_addr - wp6_l;
    wire [18:0] wp6_rlv_addr = wp6_rlv_row * PCE_W + wp6_rlv_col;

    wire [9:0] wp7_u = 10'd396 - wp7[2:0] * 10'd50;
    wire [9:0] wp7_l = 10'd126 + wp7[5:3] * 10'd50;
    wire in_wp7 = (row_addr >= wp7_u && row_addr < wp7_u + PCE_H && col_addr >= wp7_l && col_addr < wp7_l + PCE_W);
    wire [9:0] wp7_rlv_row = row_addr - wp7_u;
    wire [9:0] wp7_rlv_col = col_addr - wp7_l;
    wire [18:0] wp7_rlv_addr = wp7_rlv_row * PCE_W + wp7_rlv_col;

    wire [9:0] wr0_u = 10'd396 - wr0[2:0] * 10'd50;
    wire [9:0] wr0_l = 10'd126 + wr0[5:3] * 10'd50;
    wire in_wr0 = (row_addr >= wr0_u && row_addr < wr0_u + PCE_H && col_addr >= wr0_l && col_addr < wr0_l + PCE_W);
    wire [9:0] wr0_rlv_row = row_addr - wr0_u;
    wire [9:0] wr0_rlv_col = col_addr - wr0_l;
    wire [18:0] wr0_rlv_addr = wr0_rlv_row * PCE_W + wr0_rlv_col;

    wire [9:0] wr1_u = 10'd396 - wr1[2:0] * 10'd50;
    wire [9:0] wr1_l = 10'd126 + wr1[5:3] * 10'd50;
    wire in_wr1 = (row_addr >= wr1_u && row_addr < wr1_u + PCE_H && col_addr >= wr1_l && col_addr < wr1_l + PCE_W);
    wire [9:0] wr1_rlv_row = row_addr - wr1_u;
    wire [9:0] wr1_rlv_col = col_addr - wr1_l;
    wire [18:0] wr1_rlv_addr = wr1_rlv_row * PCE_W + wr1_rlv_col;

    wire [9:0] wn0_u = 10'd396 - wn0[2:0] * 10'd50;
    wire [9:0] wn0_l = 10'd126 + wn0[5:3] * 10'd50;
    wire in_wn0 = (row_addr >= wn0_u && row_addr < wn0_u + PCE_H && col_addr >= wn0_l && col_addr < wn0_l + PCE_W);
    wire [9:0] wn0_rlv_row = row_addr - wn0_u;
    wire [9:0] wn0_rlv_col = col_addr - wn0_l;
    wire [18:0] wn0_rlv_addr = wn0_rlv_row * PCE_W + wn0_rlv_col;

    wire [9:0] wn1_u = 10'd396 - wn1[2:0] * 10'd50;
    wire [9:0] wn1_l = 10'd126 + wn1[5:3] * 10'd50;
    wire in_wn1 = (row_addr >= wn1_u && row_addr < wn1_u + PCE_H && col_addr >= wn1_l && col_addr < wn1_l + PCE_W);
    wire [9:0] wn1_rlv_row = row_addr - wn1_u;
    wire [9:0] wn1_rlv_col = col_addr - wn1_l;
    wire [18:0] wn1_rlv_addr = wn1_rlv_row * PCE_W + wn1_rlv_col;

    wire [9:0] wb0_u = 10'd396 - wb0[2:0] * 10'd50;
    wire [9:0] wb0_l = 10'd126 + wb0[5:3] * 10'd50;
    wire in_wb0 = (row_addr >= wb0_u && row_addr < wb0_u + PCE_H && col_addr >= wb0_l && col_addr < wb0_l + PCE_W);
    wire [9:0] wb0_rlv_row = row_addr - wb0_u;
    wire [9:0] wb0_rlv_col = col_addr - wb0_l;
    wire [18:0] wb0_rlv_addr = wb0_rlv_row * PCE_W + wb0_rlv_col;

    wire [9:0] wb1_u = 10'd396 - wb1[2:0] * 10'd50;
    wire [9:0] wb1_l = 10'd126 + wb1[5:3] * 10'd50;
    wire in_wb1 = (row_addr >= wb1_u && row_addr < wb1_u + PCE_H && col_addr >= wb1_l && col_addr < wb1_l + PCE_W);
    wire [9:0] wb1_rlv_row = row_addr - wb1_u;
    wire [9:0] wb1_rlv_col = col_addr - wb1_l;
    wire [18:0] wb1_rlv_addr = wb1_rlv_row * PCE_W + wb1_rlv_col;

    wire [9:0] wq_u = 10'd396 - wq[2:0] * 10'd50;
    wire [9:0] wq_l = 10'd126 + wq[5:3] * 10'd50;
    wire in_wq = (row_addr >= wq_u && row_addr < wq_u + PCE_H && col_addr >= wq_l && col_addr < wq_l + PCE_W);
    wire [9:0] wq_rlv_row = row_addr - wq_u;
    wire [9:0] wq_rlv_col = col_addr - wq_l;
    wire [18:0] wq_rlv_addr = wq_rlv_row * PCE_W + wq_rlv_col;

    wire [9:0] wk_u = 10'd396 - wk[2:0] * 10'd50;
    wire [9:0] wk_l = 10'd126 + wk[5:3] * 10'd50;
    wire in_wk = (row_addr >= wk_u && row_addr < wk_u + PCE_H && col_addr >= wk_l && col_addr < wk_l + PCE_W);
    wire [9:0] wk_rlv_row = row_addr - wk_u;
    wire [9:0] wk_rlv_col = col_addr - wk_l;
    wire [18:0] wk_rlv_addr = wk_rlv_row * PCE_W + wk_rlv_col;

    wire [9:0] bp0_u = 10'd396 - bp0[2:0] * 10'd50;
    wire [9:0] bp0_l = 10'd126 + bp0[5:3] * 10'd50;
    wire in_bp0 = (row_addr >= bp0_u && row_addr < bp0_u + PCE_H && col_addr >= bp0_l && col_addr < bp0_l + PCE_W);
    wire [9:0] bp0_rlv_row = row_addr - bp0_u;
    wire [9:0] bp0_rlv_col = col_addr - bp0_l;
    wire [18:0] bp0_rlv_addr = bp0_rlv_row * PCE_W + bp0_rlv_col;

    wire [9:0] bp1_u = 10'd396 - bp1[2:0] * 10'd50;
    wire [9:0] bp1_l = 10'd126 + bp1[5:3] * 10'd50;
    wire in_bp1 = (row_addr >= bp1_u && row_addr < bp1_u + PCE_H && col_addr >= bp1_l && col_addr < bp1_l + PCE_W);
    wire [9:0] bp1_rlv_row = row_addr - bp1_u;
    wire [9:0] bp1_rlv_col = col_addr - bp1_l;
    wire [18:0] bp1_rlv_addr = bp1_rlv_row * PCE_W + bp1_rlv_col;

    wire [9:0] bp2_u = 10'd396 - bp2[2:0] * 10'd50;
    wire [9:0] bp2_l = 10'd126 + bp2[5:3] * 10'd50;
    wire in_bp2 = (row_addr >= bp2_u && row_addr < bp2_u + PCE_H && col_addr >= bp2_l && col_addr < bp2_l + PCE_W);
    wire [9:0] bp2_rlv_row = row_addr - bp2_u;
    wire [9:0] bp2_rlv_col = col_addr - bp2_l;
    wire [18:0] bp2_rlv_addr = bp2_rlv_row * PCE_W + bp2_rlv_col;

    wire [9:0] bp3_u = 10'd396 - bp3[2:0] * 10'd50;
    wire [9:0] bp3_l = 10'd126 + bp3[5:3] * 10'd50;
    wire in_bp3 = (row_addr >= bp3_u && row_addr < bp3_u + PCE_H && col_addr >= bp3_l && col_addr < bp3_l + PCE_W);
    wire [9:0] bp3_rlv_row = row_addr - bp3_u;
    wire [9:0] bp3_rlv_col = col_addr - bp3_l;
    wire [18:0] bp3_rlv_addr = bp3_rlv_row * PCE_W + bp3_rlv_col;

    wire [9:0] bp4_u = 10'd396 - bp4[2:0] * 10'd50;
    wire [9:0] bp4_l = 10'd126 + bp4[5:3] * 10'd50;
    wire in_bp4 = (row_addr >= bp4_u && row_addr < bp4_u + PCE_H && col_addr >= bp4_l && col_addr < bp4_l + PCE_W);
    wire [9:0] bp4_rlv_row = row_addr - bp4_u;
    wire [9:0] bp4_rlv_col = col_addr - bp4_l;
    wire [18:0] bp4_rlv_addr = bp4_rlv_row * PCE_W + bp4_rlv_col;

    wire [9:0] bp5_u = 10'd396 - bp5[2:0] * 10'd50;
    wire [9:0] bp5_l = 10'd126 + bp5[5:3] * 10'd50;
    wire in_bp5 = (row_addr >= bp5_u && row_addr < bp5_u + PCE_H && col_addr >= bp5_l && col_addr < bp5_l + PCE_W);
    wire [9:0] bp5_rlv_row = row_addr - bp5_u;
    wire [9:0] bp5_rlv_col = col_addr - bp5_l;
    wire [18:0] bp5_rlv_addr = bp5_rlv_row * PCE_W + bp5_rlv_col;

    wire [9:0] bp6_u = 10'd396 - bp6[2:0] * 10'd50;
    wire [9:0] bp6_l = 10'd126 + bp6[5:3] * 10'd50;
    wire in_bp6 = (row_addr >= bp6_u && row_addr < bp6_u + PCE_H && col_addr >= bp6_l && col_addr < bp6_l + PCE_W);
    wire [9:0] bp6_rlv_row = row_addr - bp6_u;
    wire [9:0] bp6_rlv_col = col_addr - bp6_l;
    wire [18:0] bp6_rlv_addr = bp6_rlv_row * PCE_W + bp6_rlv_col;

    wire [9:0] bp7_u = 10'd396 - bp7[2:0] * 10'd50;
    wire [9:0] bp7_l = 10'd126 + bp7[5:3] * 10'd50;
    wire in_bp7 = (row_addr >= bp7_u && row_addr < bp7_u + PCE_H && col_addr >= bp7_l && col_addr < bp7_l + PCE_W);
    wire [9:0] bp7_rlv_row = row_addr - bp7_u;
    wire [9:0] bp7_rlv_col = col_addr - bp7_l;
    wire [18:0] bp7_rlv_addr = bp7_rlv_row * PCE_W + bp7_rlv_col;

    wire [9:0] br0_u = 10'd396 - br0[2:0] * 10'd50;
    wire [9:0] br0_l = 10'd126 + br0[5:3] * 10'd50;
    wire in_br0 = (row_addr >= br0_u && row_addr < br0_u + PCE_H && col_addr >= br0_l && col_addr < br0_l + PCE_W);
    wire [9:0] br0_rlv_row = row_addr - br0_u;
    wire [9:0] br0_rlv_col = col_addr - br0_l;
    wire [18:0] br0_rlv_addr = br0_rlv_row * PCE_W + br0_rlv_col;

    wire [9:0] br1_u = 10'd396 - br1[2:0] * 10'd50;
    wire [9:0] br1_l = 10'd126 + br1[5:3] * 10'd50;
    wire in_br1 = (row_addr >= br1_u && row_addr < br1_u + PCE_H && col_addr >= br1_l && col_addr < br1_l + PCE_W);
    wire [9:0] br1_rlv_row = row_addr - br1_u;
    wire [9:0] br1_rlv_col = col_addr - br1_l;
    wire [18:0] br1_rlv_addr = br1_rlv_row * PCE_W + br1_rlv_col;

    wire [9:0] bn0_u = 10'd396 - bn0[2:0] * 10'd50;
    wire [9:0] bn0_l = 10'd126 + bn0[5:3] * 10'd50;
    wire in_bn0 = (row_addr >= bn0_u && row_addr < bn0_u + PCE_H && col_addr >= bn0_l && col_addr < bn0_l + PCE_W);
    wire [9:0] bn0_rlv_row = row_addr - bn0_u;
    wire [9:0] bn0_rlv_col = col_addr - bn0_l;
    wire [18:0] bn0_rlv_addr = bn0_rlv_row * PCE_W + bn0_rlv_col;

    wire [9:0] bn1_u = 10'd396 - bn1[2:0] * 10'd50;
    wire [9:0] bn1_l = 10'd126 + bn1[5:3] * 10'd50;
    wire in_bn1 = (row_addr >= bn1_u && row_addr < bn1_u + PCE_H && col_addr >= bn1_l && col_addr < bn1_l + PCE_W);
    wire [9:0] bn1_rlv_row = row_addr - bn1_u;
    wire [9:0] bn1_rlv_col = col_addr - bn1_l;
    wire [18:0] bn1_rlv_addr = bn1_rlv_row * PCE_W + bn1_rlv_col;

    wire [9:0] bb0_u = 10'd396 - bb0[2:0] * 10'd50;
    wire [9:0] bb0_l = 10'd126 + bb0[5:3] * 10'd50;
    wire in_bb0 = (row_addr >= bb0_u && row_addr < bb0_u + PCE_H && col_addr >= bb0_l && col_addr < bb0_l + PCE_W);
    wire [9:0] bb0_rlv_row = row_addr - bb0_u;
    wire [9:0] bb0_rlv_col = col_addr - bb0_l;
    wire [18:0] bb0_rlv_addr = bb0_rlv_row * PCE_W + bb0_rlv_col;

    wire [9:0] bb1_u = 10'd396 - bb1[2:0] * 10'd50;
    wire [9:0] bb1_l = 10'd126 + bb1[5:3] * 10'd50;
    wire in_bb1 = (row_addr >= bb1_u && row_addr < bb1_u + PCE_H && col_addr >= bb1_l && col_addr < bb1_l + PCE_W);
    wire [9:0] bb1_rlv_row = row_addr - bb1_u;
    wire [9:0] bb1_rlv_col = col_addr - bb1_l;
    wire [18:0] bb1_rlv_addr = bb1_rlv_row * PCE_W + bb1_rlv_col;

    wire [9:0] bq_u = 10'd396 - bq[2:0] * 10'd50;
    wire [9:0] bq_l = 10'd126 + bq[5:3] * 10'd50;
    wire in_bq = (row_addr >= bq_u && row_addr < bq_u + PCE_H && col_addr >= bq_l && col_addr < bq_l + PCE_W);
    wire [9:0] bq_rlv_row = row_addr - bq_u;
    wire [9:0] bq_rlv_col = col_addr - bq_l;
    wire [18:0] bq_rlv_addr = bq_rlv_row * PCE_W + bq_rlv_col;

    wire [9:0] bk_u = 10'd396 - bk[2:0] * 10'd50;
    wire [9:0] bk_l = 10'd126 + bk[5:3] * 10'd50;
    wire in_bk = (row_addr >= bk_u && row_addr < bk_u + PCE_H && col_addr >= bk_l && col_addr < bk_l + PCE_W);
    wire [9:0] bk_rlv_row = row_addr - bk_u;
    wire [9:0] bk_rlv_col = col_addr - bk_l;
    wire [18:0] bk_rlv_addr = bk_rlv_row * PCE_W + bk_rlv_col;

    reg [9:0] slc_u;
    reg [9:0] slc_l;
    reg in_slc;
    reg [9:0] slc_rlv_row;
    reg [9:0] slc_rlv_col;
    reg [18:0] slc_rlv_addr;

    always @(*) begin
        if (wp0[6]) begin
            slc_u = 10'd391 - wp0[2:0] * 10'd50;
            slc_l = 10'd121 + wp0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp1[6]) begin
            slc_u = 10'd391 - wp1[2:0] * 10'd50;
            slc_l = 10'd121 + wp1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp2[6]) begin
            slc_u = 10'd391 - wp2[2:0] * 10'd50;
            slc_l = 10'd121 + wp2[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp3[6]) begin
            slc_u = 10'd391 - wp3[2:0] * 10'd50;
            slc_l = 10'd121 + wp3[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp4[6]) begin
            slc_u = 10'd391 - wp4[2:0] * 10'd50;
            slc_l = 10'd121 + wp4[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp5[6]) begin
            slc_u = 10'd391 - wp5[2:0] * 10'd50;
            slc_l = 10'd121 + wp5[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp6[6]) begin
            slc_u = 10'd391 - wp6[2:0] * 10'd50;
            slc_l = 10'd121 + wp6[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wp7[6]) begin
            slc_u = 10'd391 - wp7[2:0] * 10'd50;
            slc_l = 10'd121 + wp7[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wr0[6]) begin
            slc_u = 10'd391 - wr0[2:0] * 10'd50;
            slc_l = 10'd121 + wr0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wr1[6]) begin
            slc_u = 10'd391 - wr1[2:0] * 10'd50;
            slc_l = 10'd121 + wr1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wn0[6]) begin
            slc_u = 10'd391 - wn0[2:0] * 10'd50;
            slc_l = 10'd121 + wn0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wn1[6]) begin
            slc_u = 10'd391 - wn1[2:0] * 10'd50;
            slc_l = 10'd121 + wn1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wb0[6]) begin
            slc_u = 10'd391 - wb0[2:0] * 10'd50;
            slc_l = 10'd121 + wb0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wb1[6]) begin
            slc_u = 10'd391 - wb1[2:0] * 10'd50;
            slc_l = 10'd121 + wb1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wq[6]) begin
            slc_u = 10'd391 - wq[2:0] * 10'd50;
            slc_l = 10'd121 + wq[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (wk[6]) begin
            slc_u = 10'd391 - wk[2:0] * 10'd50;
            slc_l = 10'd121 + wk[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp0[6]) begin
            slc_u = 10'd391 - bp0[2:0] * 10'd50;
            slc_l = 10'd121 + bp0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp1[6]) begin
            slc_u = 10'd391 - bp1[2:0] * 10'd50;
            slc_l = 10'd121 + bp1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp2[6]) begin
            slc_u = 10'd391 - bp2[2:0] * 10'd50;
            slc_l = 10'd121 + bp2[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp3[6]) begin
            slc_u = 10'd391 - bp3[2:0] * 10'd50;
            slc_l = 10'd121 + bp3[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp4[6]) begin
            slc_u = 10'd391 - bp4[2:0] * 10'd50;
            slc_l = 10'd121 + bp4[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp5[6]) begin
            slc_u = 10'd391 - bp5[2:0] * 10'd50;
            slc_l = 10'd121 + bp5[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp6[6]) begin
            slc_u = 10'd391 - bp6[2:0] * 10'd50;
            slc_l = 10'd121 + bp6[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bp7[6]) begin
            slc_u = 10'd391 - bp7[2:0] * 10'd50;
            slc_l = 10'd121 + bp7[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (br0[6]) begin
            slc_u = 10'd391 - br0[2:0] * 10'd50;
            slc_l = 10'd121 + br0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (br1[6]) begin
            slc_u = 10'd391 - br1[2:0] * 10'd50;
            slc_l = 10'd121 + br1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bn0[6]) begin
            slc_u = 10'd391 - bn0[2:0] * 10'd50;
            slc_l = 10'd121 + bn0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bn1[6]) begin
            slc_u = 10'd391 - bn1[2:0] * 10'd50;
            slc_l = 10'd121 + bn1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bb0[6]) begin
            slc_u = 10'd391 - bb0[2:0] * 10'd50;
            slc_l = 10'd121 + bb0[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bb1[6]) begin
            slc_u = 10'd391 - bb1[2:0] * 10'd50;
            slc_l = 10'd121 + bb1[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bq[6]) begin
            slc_u = 10'd391 - bq[2:0] * 10'd50;
            slc_l = 10'd121 + bq[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else if (bk[6]) begin
            slc_u = 10'd391 - bk[2:0] * 10'd50;
            slc_l = 10'd121 + bk[5:3] * 10'd50;
            in_slc = (row_addr >= slc_u && row_addr < slc_u + GRD_H && col_addr >= slc_l && col_addr < slc_l + GRD_W);
            slc_rlv_row = row_addr - slc_u;
            slc_rlv_col = col_addr - slc_l;
            slc_rlv_addr = slc_rlv_row * GRD_W + slc_rlv_col;
        end
        else begin
            in_slc = 1'b0;
        end
    end

    always @(posedge clk) begin
        if (in_wp0 && wp_rom_data[wp0_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp0_rlv_addr];
        else if (in_wp1 && wp_rom_data[wp1_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp1_rlv_addr];
        else if (in_wp2 && wp_rom_data[wp2_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp2_rlv_addr];
        else if (in_wp3 && wp_rom_data[wp3_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp3_rlv_addr];
        else if (in_wp4 && wp_rom_data[wp4_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp4_rlv_addr];
        else if (in_wp5 && wp_rom_data[wp5_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp5_rlv_addr];
        else if (in_wp6 && wp_rom_data[wp6_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp6_rlv_addr];
        else if (in_wp7 && wp_rom_data[wp7_rlv_addr] != 12'h00F) pixel_data <= wp_rom_data[wp7_rlv_addr];
        else if (in_wr0 && wr_rom_data[wr0_rlv_addr] != 12'h00F) pixel_data <= wr_rom_data[wr0_rlv_addr];
        else if (in_wr1 && wr_rom_data[wr1_rlv_addr] != 12'h00F) pixel_data <= wr_rom_data[wr1_rlv_addr];
        else if (in_wn0 && wn_rom_data[wn0_rlv_addr] != 12'h00F) pixel_data <= wn_rom_data[wn0_rlv_addr];
        else if (in_wn1 && wn_rom_data[wn1_rlv_addr] != 12'h00F) pixel_data <= wn_rom_data[wn1_rlv_addr];
        else if (in_wb0 && wb_rom_data[wb0_rlv_addr] != 12'h00F) pixel_data <= wb_rom_data[wb0_rlv_addr];
        else if (in_wb1 && wb_rom_data[wb1_rlv_addr] != 12'h00F) pixel_data <= wb_rom_data[wb1_rlv_addr];
        else if (in_wq && wq_rom_data[wq_rlv_addr] != 12'h00F) pixel_data <= wq_rom_data[wq_rlv_addr];
        else if (in_wk && wk_rom_data[wk_rlv_addr] != 12'h00F) pixel_data <= wk_rom_data[wk_rlv_addr];
        else if (in_bp0 && bp_rom_data[bp0_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp0_rlv_addr];
        else if (in_bp1 && bp_rom_data[bp1_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp1_rlv_addr];
        else if (in_bp2 && bp_rom_data[bp2_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp2_rlv_addr];
        else if (in_bp3 && bp_rom_data[bp3_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp3_rlv_addr];
        else if (in_bp4 && bp_rom_data[bp4_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp4_rlv_addr];
        else if (in_bp5 && bp_rom_data[bp5_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp5_rlv_addr];
        else if (in_bp6 && bp_rom_data[bp6_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp6_rlv_addr];
        else if (in_bp7 && bp_rom_data[bp7_rlv_addr] != 12'h00F) pixel_data <= bp_rom_data[bp7_rlv_addr];
        else if (in_br0 && br_rom_data[br0_rlv_addr] != 12'h00F) pixel_data <= br_rom_data[br0_rlv_addr];
        else if (in_br1 && br_rom_data[br1_rlv_addr] != 12'h00F) pixel_data <= br_rom_data[br1_rlv_addr];
        else if (in_bn0 && bn_rom_data[bn0_rlv_addr] != 12'h00F) pixel_data <= bn_rom_data[bn0_rlv_addr];
        else if (in_bn1 && bn_rom_data[bn1_rlv_addr] != 12'h00F) pixel_data <= bn_rom_data[bn1_rlv_addr];
        else if (in_bb0 && bb_rom_data[bb0_rlv_addr] != 12'h00F) pixel_data <= bb_rom_data[bb0_rlv_addr];
        else if (in_bb1 && bb_rom_data[bb1_rlv_addr] != 12'h00F) pixel_data <= bb_rom_data[bb1_rlv_addr];
        else if (in_bq && bq_rom_data[bq_rlv_addr] != 12'h00F) pixel_data <= bq_rom_data[bq_rlv_addr];
        else if (in_bk && bk_rom_data[bk_rlv_addr] != 12'h00F) pixel_data <= bk_rom_data[bk_rlv_addr];
        else if (in_slc && slc_rom_data[slc_rlv_addr] != 12'h00F) pixel_data <= slc_rom_data[slc_rlv_addr];
        else if (in_crt) pixel_data <= 12'h57E;
        else if (in_board) pixel_data <= board_rom_data[board_rlv_addr];
        else pixel_data <= 12'h333;
    end

endmodule