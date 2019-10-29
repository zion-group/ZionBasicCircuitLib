module ZionBasicCircuitLib_HighB_tb;
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
      if (`BcHighB(dat) != dat[$high(dat)]) begin
        $error("oDat fault, %0d!=%0d", dat,dat[$high(dat)]);
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_HighB_tb,"+all");
    #500 $finish;
  end 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 