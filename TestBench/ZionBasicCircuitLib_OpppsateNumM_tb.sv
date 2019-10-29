module ZionBasicCircuitLib_OpppsateNumM_tb;
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
      if (`BcOpppsateNumM(dat) != ~dat + 1'b1) begin
        $error("oDat fault, %0d!=%0d", dat,~dat + 1'b1);
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_OpppsateNumM_tb,"+all");
    #500 $finish;
  end 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 