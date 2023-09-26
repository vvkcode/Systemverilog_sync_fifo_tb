`define WIDTH 8

class trnsaction;
//no factory
//constructor

//seq1 create and randomise
//bit clk, rst;
bit full, empty;
bit [`WIDTH-1:0] dout;
rand bit [`WIDTH-1:0] din;
rand logic wr_en;
rand logic rd_en;

constraint wr_rd {wr_en != rd_en;}
//constraint crst {rst dist {0:=1, 1:=50};}

endclass

