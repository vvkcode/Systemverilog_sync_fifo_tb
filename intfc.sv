`define WIDTH 8
interface intf(input logic clk, rst);
  logic [`WIDTH-1:0]din;
  logic wr_en,rd_en;
  logic [`WIDTH-1:0]dout;
  logic full,empty;
  
  clocking driver_cb@(posedge clk);
   //default input #1 output #1;
    output din;
    output wr_en,rd_en;
    output full,empty;
    output rst;
    input dout;
  endclocking

  clocking monitor_cb@(posedge clk);
    //default input #1 output #1;
    input din;
    input wr_en,rd_en;
    input dout;
    input full,empty;
    input rst;
  endclocking
  
  modport DRIVER(clocking driver_cb,input clk, rst);
  modport MONITOR(clocking monitor_cb,input clk, rst);
    
endinterface  
