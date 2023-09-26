class transaction;
  rand bit [7:0] data;
  rand bit [7:0] addr;
endclass : transaction

class generator;
   task transmit_good(mailbox mb);
     transaction tr;
     repeat (5) begin
       // constructing the object
       tr = new();
       // randomizing object
       if (!tr.randomize()) begin
         $error("randomization failed");
       end
       else begin
         $display("GEN: time %t, transmit_good: after randomization tr.addr=%0h, tr.data=%0h", $time, tr.addr, tr.data);
       end
       // putting object in the mailbox
       mb.put(tr);
     end
   endtask : transmit_good
endclass : generator

class driver;
  mailbox  mb;
    task receive_good(mailbox mb);
      transaction tr;
      forever begin
        #5ns;
        mb.get(tr);
        // drive tranaction to DUT
        $display("DRV: tme %t ,receive: Received tr.addr=%0h, tr.data=%0h", $time, tr.addr, tr.data);
      end
    endtask : receive_good
endclass : driver

program main;
  generator gen;
  driver drv;
  mailbox mb;

  initial begin
    mb = new();
    gen = new();
    drv = new();

    // Run producer and Consumer in parallel
    fork
      begin
       gen.transmit_good(mb);
      end
      begin
       drv.receive_good(mb);
      end
    join
  end
endprogram
