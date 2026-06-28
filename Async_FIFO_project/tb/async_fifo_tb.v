`timescale 1ns/1ps

module async_fifo_tb;

parameter DATA_WIDTH = 32;
parameter FIFO_DEPTH = 8;
parameter ADDR_WIDTH = 3;

reg wclk;
reg wrst_n;
reg wr_en;
reg [DATA_WIDTH-1:0] wdata;

reg rclk;   
reg rrst_n;
reg rd_en;

wire [DATA_WIDTH-1:0]rdata;
wire full;
wire empty;
integer i=0;

async_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)

)dut(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wr_en(wr_en),
    .wdata(wdata),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .rd_en(rd_en),
    .rdata(rdata),
    .full(full),
    .empty(empty)
);


//clock generation 
initial begin
    wclk=0;
    forever #5 wclk=~wclk;
end

initial begin
    rclk=0;
    forever #7 rclk=~rclk;
end

reg [DATA_WIDTH-1:0] expected_mem [0:1023];
integer wr_count;
integer rd_count;

initial begin
    wr_count=0;
    rd_count=0;
end

//write 
task write_fifo;
input[DATA_WIDTH-1:0] data;
begin
    @(negedge wclk);
    if (!full)begin
        wr_en=1'b1;
        wdata=data;

        expected_mem[wr_count]=data;
        wr_count=wr_count+1;
        
        @(negedge  wclk);
        wr_en<=1'b0;
        $display("[%0t] write data= %0d",$time,data);
    end
    else begin
        $display("[%0t] fifo full",$time);
    end
end
endtask

//read
task read_fifo;
reg [DATA_WIDTH-1:0] expected;  
begin
    @(posedge rclk);
    if(!empty)begin
        expected=expected_mem[rd_count];
        rd_en =1'b1;

        @(posedge rclk);

        #1;

        if(rdata==expected)begin
            $display("[%0t] pass Read=%0d",$time,rdata);
        end
        else begin
            $display("[%0t] fail expected=%0d got=%0d",$time,expected,rdata);
        end
        rd_count=rd_count+1;
        rd_en =1'b0;


    end

    else begin
        $display("[%0t] fifo empty",$time);
    end
end
endtask

initial begin
    wrst_n = 0;
    rrst_n = 0;

    wr_en = 0;
    rd_en = 0;

    wdata = 0;

    #30;

    wrst_n = 1;
    rrst_n = 1;
end

initial begin

    $monitor(
    "T=%0t FULL=%b EMPTY=%b WDATA=%0d RDATA=%0d",
    $time,
    full,
    empty,
    wdata,
    rdata
    );

end

initial begin
     wait (wrst_n === 1 && rrst_n === 1);
    #20;



    write_fifo(11);
    write_fifo(22);
    write_fifo(33);
    write_fifo(44);
    write_fifo(55);
    write_fifo(66);
    write_fifo(77);
    write_fifo(88);

   

    #20;

    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    read_fifo();
    

    #80;
    
    for(i=0;i<=7;i++)begin
        write_fifo(i*12);
        read_fifo();
    end

    #80
    for(i=0;i<=7;i++)begin
        write_fifo(i*(3+i));
    end

    for(i=0;i<=7;i++)begin
        read_fifo();
    end


end



initial begin
    $dumpfile("async_fifo.vcd");
    $dumpvars(0,async_fifo_tb);
end

initial begin
    #2000;
    $display("Simulation Finished");
    $finish;
end

endmodule





