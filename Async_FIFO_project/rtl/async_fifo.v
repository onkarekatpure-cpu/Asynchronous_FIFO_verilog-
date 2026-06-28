module async_fifo #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
)(
    input wclk,
    input wrst_n,
    input wr_en,
    input [DATA_WIDTH-1:0] wdata,
    input rclk,
    input rrst_n,
    input rd_en,
    output [DATA_WIDTH-1:0] rdata,
    output full,
    output empty
);

wire [ADDR_WIDTH:0] wptr_bin;
wire [ADDR_WIDTH:0] rptr_bin;
wire [ADDR_WIDTH:0] wptr_gray;
wire [ADDR_WIDTH:0] rptr_gray;
wire [ADDR_WIDTH:0] wptr_gray_sync;
wire [ADDR_WIDTH:0] rptr_gray_sync;

mem #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) u_mem (
    .wclk (wclk),
    .wr_en (wr_en & ~full),
    .wr_addr (wptr_bin[ADDR_WIDTH-1:0]),
    .wr_data (wdata),

    .rd_addr (rptr_bin[ADDR_WIDTH-1:0]),
    .rd_data (rdata)
);

wrptr_fulllogic #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_wptr (
    .wclk (wclk),
    .wrst_n (wrst_n),
    .wr_en (wr_en),
    .rptr_gray_sync (rptr_gray_sync),

    .full (full),
    .wptr_bin (wptr_bin),
    .wptr_gray (wptr_gray)
);

rdptr_emptylogic #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_rptr (
    .rclk (rclk),
    .rrst_n (rrst_n),
    .rd_en (rd_en),
    .wptr_gray_sync (wptr_gray_sync),

    .empty (empty),
    .rptr_bin (rptr_bin),
    .rptr_gray (rptr_gray)
);

sync_wtr #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_sync_wtr (
    .rclk (rclk),
    .rrst_n (rrst_n),
    .wptr_gray (wptr_gray),
    .wptr_gray_sync (wptr_gray_sync)
);

sync_rtw #(
    .ADDR_WIDTH(ADDR_WIDTH)
) u_sync_rtw (
    .wclk (wclk),
    .wrst_n (wrst_n),
    .rptr_gray (rptr_gray),
    .rptr_gray_sync (rptr_gray_sync)
);
endmodule