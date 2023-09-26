//convert signal level to transaction level 
class mon;

virtual intf vif_ff;
mailbox mbox_ms;

//constructor
//check the mailbox is empty or not
function new(virtual intf vif_ff, mailbox mbox_ms);
  this.vif_ff = vif_ff;
  if(mbox_ms == null)
  begin
    $display("**ERROR**: MON: mbox_ms is null");
    $finish;
  end
  else
    this.mbox_ms = mbox_ms;
endfunction
        
task main();
  $display("Monitor main module started");
fork
forever begin
  trnsaction trans;
  trans = new();
  @(posedge vif_ff.MONITOR.clk);
  wait(vif_ff.MONITOR.monitor_cb.wr_en || vif_ff.MONITOR.monitor_cb.rd_en);
  @(posedge vif_ff.MONITOR.clk);
  if(vif_ff.MONITOR.monitor_cb.wr_en)
  begin
    trans.wr_en=vif_ff.MONITOR.monitor_cb.wr_en;
    trans.rd_en=vif_ff.MONITOR.monitor_cb.rd_en;
    trans.dout = vif_ff.MONITOR.monitor_cb.dout;
    trans.full = vif_ff.MONITOR.monitor_cb.full;
    trans.empty = vif_ff.MONITOR.monitor_cb.empty;
   $display("\t MON: write enable = %0h and data out = %0h", trans.wr_en, vif_ff.MONITOR.monitor_cb.dout);    
  end
 else
  begin
    trans.wr_en=vif_ff.MONITOR.monitor_cb.wr_en;
    trans.rd_en=vif_ff.MONITOR.monitor_cb.rd_en;
    trans.din = vif_ff.MONITOR.monitor_cb.din;
    trans.full = vif_ff.MONITOR.monitor_cb.full;
    trans.empty = vif_ff.MONITOR.monitor_cb.empty;
      $display("\t MON: rd_en = %0h \t data out =%0h", trans.rd_en, trans.din);
  end  
  mbox_ms.put(trans); //put the sampled data on mailbox
end
$display("end of monitor block");
join_none
endtask
endclass
