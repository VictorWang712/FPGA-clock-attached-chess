module HexsTo8Seg(
    input [31:0] hexs,
    input [7:0] points,
    input [7:0] LEs,
    output [63:0] seg_data
);

    HexToSeg HTS0(.hex(hexs[31:28]), .LE(LEs[7]), .point(points[7]), .segment(seg_data[7:0]));  
    HexToSeg HTS1(.hex(hexs[27:24]), .LE(LEs[6]), .point(points[6]), .segment(seg_data[15:8])); 
    HexToSeg HTS2(.hex(hexs[23:20]), .LE(LEs[5]), .point(points[5]), .segment(seg_data[23:16]));  
    HexToSeg HTS3(.hex(hexs[19:16]), .LE(LEs[4]), .point(points[4]), .segment(seg_data[31:24]));

    HexToSeg HTS4(.hex(hexs[15:12]), .LE(LEs[3]), .point(points[3]), .segment(seg_data[39:32]));
    HexToSeg HTS5(.hex(hexs[11:8]),  .LE(LEs[2]), .point(points[2]), .segment(seg_data[47:40]));
    HexToSeg HTS6(.hex(hexs[7:4]),   .LE(LEs[1]), .point(points[1]), .segment(seg_data[55:48]));
    HexToSeg HTS7(.hex(hexs[3:0]),   .LE(LEs[0]), .point(points[0]), .segment(seg_data[63:56]));

endmodule