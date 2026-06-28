module rdptr_emptylogic #(
    parameter ADDR_WIDTH = 3
)(
    input rclk,
    input rd_en,
    input rrst_n,
    input [ADDR_WIDTH:0]wptr_gray_sync,

    output reg empty,
    output reg [ADDR_WIDTH:0]rptr_bin,
    output reg [ADDR_WIDTH:0]rptr_gray
);

wire [ADDR_WIDTH:0]rptr_bin_next;
wire [ADDR_WIDTH:0]rptr_gray_next;
wire empty_next;

assign rptr_bin_next=rptr_bin+(rd_en & ~empty);

assign rptr_gray_next=rptr_bin_next^(rptr_bin_next>>1);

assign empty_next=(rptr_gray_next==wptr_gray_sync);


always @(posedge rclk or negedge rrst_n)begin
    if(!rrst_n)begin
        rptr_bin<=0;
        rptr_gray<=0;
        empty<=1'b1;
    end
    else begin
        rptr_bin<=rptr_bin_next;
        rptr_gray<=rptr_gray_next;
        empty<=empty_next;
    end
end
endmodule