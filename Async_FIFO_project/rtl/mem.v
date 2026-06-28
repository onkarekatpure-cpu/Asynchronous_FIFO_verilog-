module mem #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input wire wclk,
    input wire wr_en,
    input wire [ADDR_WIDTH-1:0] wr_addr,
    input wire [DATA_WIDTH-1:0] wr_data,
    input wire [ADDR_WIDTH-1:0] rd_addr,
    output wire [DATA_WIDTH-1:0] rd_data
);
integer i;
//memory
reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

initial begin
    for(i=0;i<FIFO_DEPTH;i++)begin
        mem[i]=0;
    end
end
always @(posedge wclk)begin
    if(wr_en)begin
    mem[wr_addr]<=wr_data;
    end
end

assign rd_data=mem[rd_addr];

endmodule
