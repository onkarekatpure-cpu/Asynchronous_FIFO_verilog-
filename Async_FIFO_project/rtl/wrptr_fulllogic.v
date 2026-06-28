module wrptr_fulllogic #(
    parameter ADDR_WIDTH = 3
)(
    input wclk,
    input wr_en,
    input wrst_n,
    input [ADDR_WIDTH:0]rptr_gray_sync,

    output reg full,
    output reg [ADDR_WIDTH:0]wptr_bin,
    output reg [ADDR_WIDTH:0]wptr_gray
);

wire [ADDR_WIDTH:0]wptr_bin_next;
wire [ADDR_WIDTH:0]wptr_gray_next;
wire full_next;

assign wptr_bin_next=wptr_bin+(wr_en & ~full);

assign wptr_gray_next=wptr_bin_next^(wptr_bin_next>>1);

assign full_next=(wptr_gray_next=={~rptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1],rptr_gray_sync[ADDR_WIDTH-2:0]});


always @(posedge wclk or negedge wrst_n)begin
    if(!wrst_n)begin
        wptr_bin<=0;
        wptr_gray<=0;
        full<=0;
    end
    else begin
        wptr_bin<=wptr_bin_next;
        wptr_gray<=wptr_gray_next;
        full<=full_next;
        

        // $display("[%0t] wr_en=%b full=%b wptr_bin=%b wptr_bin_next=%b",
        //  $time, wr_en, full, wptr_bin, wptr_bin_next);
    end
end

endmodule