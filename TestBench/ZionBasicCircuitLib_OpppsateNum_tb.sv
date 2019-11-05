module ZionBasicCircuitLib_OpppsateNum_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;
  logic [31:0]iDat,oDat;

  initial begin
    forever #(period/2) 
     // iDat = {$random()}%(32'hffff_ffff);
      iDat = 32'hffff_fff0;

  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (oDat != ~iDat + 1'b1) begin
        $error("oDat fault, %0d!=%0d", oDat,~iDat + 1'b1);
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_OpppsateNum_tb,"+all");
    #500 $finish;
  end 

 `BcOpppsateNum ( U_OpppsateNum,
                    iDat,
                    oDat
                );
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 