`define WIDTH 8
`define DEPTH 8
`define THRES
`define PNTR $clog2(`WIDTH)
module synff(
input [`WIDTH-1:0] din,
input wr_en, rd_en,
input clk, rst,
output reg [`WIDTH-1:0] dout
);

//internal reg
reg full, empty;
reg almost_full;
reg [`PNTR-1:0] wr_pntr;
reg [`PNTR-1:0] rd_pntr;
//dcount will increment with write and decrement with read
//indicates the fifo status
reg [`PNTR-1:0] dcount;

//register declaration
reg [`WIDTH-1:0] mem_ff [`DEPTH-1:0];

//reset logic
always @(posedge clk) 
begin
        if(!rst) begin
          dout = 0;
         //full = 0;
         // empty = 0;
          dcount = 0;
          wr_pntr = 0;
          rd_pntr = 0;
        end
end
//fifo wr/rd
always @(posedge clk)
begin
        if(wr_en & !full)
        begin
          mem_ff[wr_pntr] <= din;
          wr_pntr <= wr_pntr + 1;
          dcount <= dcount + 1;
         // $display("FIFO read with wr_en = %0b and wr_pntr %b", wr_en, wr_pntr);
        end
        else if(rd_en & !empty)
        begin
          dout <= mem_ff[rd_pntr];
          rd_pntr <= rd_pntr + 1;
          dcount <= dcount - 1;
         // $display("FIFO read with rd_en = %0b and rd_pntr is %b", rd_en, rd_pntr);
        end
        //else
         // $display("FIFO is either full or empty and rd_pntr = %b , wr_pntr = %b", rd_pntr, wr_pntr);
end

//full/empty

 assign full = (dcount==`WIDTH-1)?1'b1:1'b0;
 assign empty = (rd_pntr == wr_pntr)?1'b1:1'b0;

endmodule
