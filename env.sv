`include "trnsaction.sv"
`include "genrtr.sv"
`include "drv.sv"
`include "mon.sv"
`include "scbd.sv"
class env;
//instantiation
genrtr gen;
drv drvv;
mon monn;
scbd scbdd;

mailbox mbox_gd;
mailbox mbox_ms;

virtual intf vif_ff;

//event to stop generation of signals
event genstop;

function new(virtual intf vif_ff);
  this.vif_ff = vif_ff;
  $display("env created");

endfunction

task build();
$display("enter into build phase");
  mbox_gd = new();
  mbox_ms = new();

  gen = new(genstop, mbox_gd);
  drvv = new(vif_ff,mbox_gd);
  monn = new(vif_ff, mbox_ms);
  scbdd = new(mbox_gd,mbox_ms);
endtask

//reset
task pre_test();
  drvv.reset;
endtask

task test();
 $display("ENV:genrtr start");
 gen.main(5); //repeat, mailbox
 $display("ENV:driver start");
 drvv.drive();
 $display("ENV:monitor start");
 monn.main();
 $display("ENV:scbd start");
 scbdd.main();
endtask

task post_test();
  wait(genstop.triggered);
//check for no of transactions 
endtask

task run();
  pre_test();
  test();
  post_test();
 #800 $finish;
endtask

endclass
