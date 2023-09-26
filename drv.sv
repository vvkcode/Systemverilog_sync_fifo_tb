//converts transaction level to signal level
class drv;
virtual intf vif_ff;
mailbox mbox_gd;

function new(virtual intf vif_ff, mailbox mbox_gd);
  this.vif_ff = vif_ff;
  this.mbox_gd = mbox_gd;
endfunction

task reset;
   wait(!vif_ff.rst);
   $display("DRV:resetting @ time %0t rst = %0h", $time,vif_ff.rst );
   vif_ff.DRIVER.driver_cb.wr_en <= 0;
   vif_ff.DRIVER.driver_cb.rd_en <= 0;
   vif_ff.DRIVER.driver_cb.full <= 0;
   vif_ff.DRIVER.driver_cb.empty <= 0;
   wait(vif_ff.rst);
  $display("DRV:resetting done @ time %0t rst = %0h", $time, vif_ff.rst);
endtask

task drive();
  trnsaction trans;
fork
forever begin
  mbox_gd.get(trans);
  //$display("no: of transaction = ", no_trans);

  @(posedge vif_ff.DRIVER.clk);
  if(trans.wr_en || trans.rd_en) begin
  if(trans.wr_en)
  begin
    vif_ff.DRIVER.driver_cb.wr_en <= trans.wr_en;
    vif_ff.DRIVER.driver_cb.din <= trans.din;
    $display("\t DRV: write enable = %0h rd en %0h \t data in %0h and time %0t", trans.wr_en, trans.rd_en, trans.din, $time);
  @(posedge vif_ff.DRIVER.clk);
  end

  if(trans.rd_en)
  begin
    vif_ff.DRIVER.driver_cb.rd_en <= trans.rd_en;
    trans.dout = vif_ff.dout;
     $display("\t DRV: read enable = %0h output = %0h time", trans.rd_en, trans.dout, $time);
  end
  end
  //no_trans++;
end //forever
join_none
endtask

//task final1;
//$display("viff.rst is %0h", vif_ff.rst, $time);
//if(!vif_ff.rst)
//reset;
//else
//drive();
//endtask

endclass
