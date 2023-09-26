`define WIDTH 8
module top();
reg [`WIDTH-1:0] din;
reg wr_en, rd_en, clk, rst;
wire [`WIDTH-1:0] dout;

//dut instantiation
synff vut(.din(din),
          .dout(dout),
          .wr_en(wr_en),
          .rd_en(rd_en),
          .clk(clk),
          .rst(rst)
         );

//clk and rst initialization
initial begin 
        clk = 0;
        forever 
            #8 clk = ~clk;
end
initial begin 
        rst = 0;
        #10 rst = 1;
end

//test signals
initial begin
        wr_en = 0;
        rd_en = 0;
        #4 wr_en = 1;
        din = 8;
        #200 wr_en = 0;
        #1 rd_en = 1;
        #400 rd_en = 0;
end

//dump 
initial begin
        $dumpfile("dump1.vcd");
        $dumpvars();
        #800 $finish();
end
endmodule
