//need to connect dut with tb environment using interface
`include "intfc.sv"
`include "test.sv"
module top;
bit clk;
bit rst;
//no need to declare local wire and logic

initial begin
        clk = 0;
        forever
          #5 clk = ~clk;
end
initial begin
        rst = 1;
        #5 rst = 0;
        #20 rst = 1;
end

intf vif(clk, rst);
//connected through interface
//pass the clk and rst to intf
// intf vif;

//instantiate and pass the interface handle
test t1(vif);

//dut instantiation
synff dut(.dout(vif.dout),
          .din(vif.din),
          .wr_en(vif.wr_en),
          .rd_en(vif.rd_en),
          .clk(clk),
          .rst(rst)
         );
//set the interface in config_db, but it is in UVM , how to handle in SV

//run the test case - will not work in SV tb
//initial 
//begin
//  run_test("test name");
//end
initial begin
 $dumpfile("dump.vcd");
 $dumpvars();
//#2000 $finish;
end

endmodule
