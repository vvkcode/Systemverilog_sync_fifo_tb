class genrtr;
//mailbox - needed to send to the driver
mailbox mbox_gd;
event genstop;

function new(event genstop , mailbox mbox_gd);
  this.genstop = genstop;
  this.mbox_gd = mbox_gd;
endfunction

rand trnsaction trans;
task main(int n);
  repeat(n)
  begin
    trans = new();
    if(!trans.randomize())
         $fatal("Gen::trans randomization failed");
    else begin
        mbox_gd.put(trans);
        $display("GEN: successfull din= %0h, wr_en = %0h, rd_en = %0h", trans.din, trans.wr_en, trans.rd_en);
    end
  ->genstop;
  end
endtask

endclass
