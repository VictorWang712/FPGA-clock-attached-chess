module vga_ctrl (
    input     [11:0] d_in,    
    input            vga_clk, 
    input            clrn,
    output reg       rdn,     
    output reg [9:0] row_addr,
    output reg [9:0] col_addr,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b,
    output reg       hs,
    output reg       vs
);

    reg [9:0] h_count;
    always @ (posedge vga_clk) begin
        if (!clrn)
            h_count <= 10'h0;
        else if (h_count == 10'd799)
            h_count <= 10'h0;
        else
            h_count <= h_count + 10'h1;
    end

    reg [9:0] v_count;
    always @ (posedge vga_clk or negedge clrn) begin
        if (!clrn)
            v_count <= 10'h0;
        else if (h_count == 10'd799) begin
            if (v_count == 10'd524)
                v_count <= 10'h0;
            else
                v_count <= v_count + 10'h1;
        end
    end

    wire [9:0] row = v_count - 10'd35;
    wire [9:0] col = h_count - 10'd144;

    wire read = (h_count > 10'd143) && (h_count < 10'd783) &&
                (v_count > 10'd34)  && (v_count < 10'd515);

    wire h_sync = (h_count > 10'd95);
    wire v_sync = (v_count > 10'd1);

    always @ (posedge vga_clk) begin
        row_addr <= row;
        col_addr <= col;
        hs       <= h_sync;
        vs       <= v_sync;
        r        <= ~read ? 4'h0 : d_in[3:0];
        g        <= ~read ? 4'h0 : d_in[7:4];
        b        <= ~read ? 4'h0 : d_in[11:8];
    end

endmodule