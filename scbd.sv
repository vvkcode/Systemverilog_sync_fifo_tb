//compare the dut response and reference model output
`define DEPTH 8
`define WIDTH 8
`define PNTR $clog2(`WIDTH)
class scbd;

//collect data that monitor is monitoring
mailbox mbox_ms;
mailbox mbox_gd;


function new(mailbox mbox_gd, mailbox mbox_ms);
  this.mbox_ms = mbox_ms;
  this.mbox_gd = mbox_gd;
endfunction

task main;
fork
  trnsaction transo;
  trnsaction transi;
forever begin
$display("SCBD block started");
  mbox_ms.get(transo);
  mbox_gd.get(transi);
$display("SCBD: scoreboard receive the packet from the monitor: %0h", transi.din, $time);
  if(transo.dout == transi.din)
      $display("SCBD: PASS , received = %0h , exp = %0h",transo.dout, transi.din, $time);
  else
      $display("SCBD: FAIL received = %0h , exp = %0h",transo.dout, transi.din, $time);
      
//no_trans++;
$display("SCBD block end");
end
join_none
endtask
endclass
