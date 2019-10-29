module ZionBasicCircuitLib_RotateLeftM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;
  logic [ 4:0] shift;
  logic [31:0] dat;

  initial begin
    forever #(period/2) 
      shift = {$random()}%33;
      dat   = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (`BcRotateLeftM(dat,shift) != {1<<{$bits(dat)'({{1<<{dat}},{1<<{dat}}} >> shift)}}) begin
        $error("oDat fault, dat = %0d,shift = %0d,result = %0d", dat,shift,{1<<{$bits(dat)'({{1<<{dat}},{1<<{dat}}} >> shift)}});
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_RotateLeftM_tb,"+all");
    #500 $finish;
  end 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 