module sync_rtw #(
    parameter ADDR_WIDTH = 3
)(
    input wclk,
    input wrst_n,
    input [ADDR_WIDTH:0] rptr_gray,
    output reg [ADDR_WIDTH:0] rptr_gray_sync
);

reg [ADDR_WIDTH:0] sync_ff1;

always@(posedge wclk or negedge wrst_n)begin

    if(!wrst_n)begin
        sync_ff1<=0;
        rptr_gray_sync<=0;
    end
    else begin
        sync_ff1<=rptr_gray;
        rptr_gray_sync<=sync_ff1;
    end
end
endmodule

