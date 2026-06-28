module sync_wtr #(
    parameter ADDR_WIDTH = 3
)(
    input rclk,
    input rrst_n,
    input [ADDR_WIDTH:0] wptr_gray,
    output reg [ADDR_WIDTH:0] wptr_gray_sync
);

reg [ADDR_WIDTH:0] sync_ff1;

always@(posedge rclk or negedge rrst_n)begin

    if(!rrst_n)begin
        sync_ff1<=0;
        wptr_gray_sync<=0;
    end
    else begin
        sync_ff1<=wptr_gray;
        wptr_gray_sync<=sync_ff1;
    end
end
endmodule

