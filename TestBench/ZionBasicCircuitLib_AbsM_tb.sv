module ZionBasicCircuitLib_AbsM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;

  logic [31:0] dat;

  initial begin
    forever #(period/2) 
      dat = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (dat[$high(dat)]) begin
        if (`BcAbsM(dat) != ~dat+1'b1) begin
          $error("-dat fault, %0d!=%0d,%0d", `BcAbsM(dat),(~dat+1'b1),(dat[$high(dat)]));
          $finish;
        end
      end else  begin
        if (`BcAbsM(dat) != dat) begin
          $error("+dat fault, %0d!=%0d", `BcAbsM(dat),dat);
          $finish;
        end
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_AbsM_tb,"+all");
    #500 $finish;
  end 

  // task in (input logic[31:0]dat1);
  //   dat = dat1;  
  // endtask : in
  
  // always_comb
  // `BcAbsM (
  //          dat
  //         );
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
