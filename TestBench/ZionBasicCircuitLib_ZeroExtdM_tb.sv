module ZionBasicCircuitLib_ZeroExtdM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20,
            WIDTH  = 32;
  logic [31:0] dat;

  initial begin
    forever #(period/2) 
      dat   = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (`BcZeroExtdM(dat,WIDTH) != {{(WIDTH-$bits(dat)){1'b0}},dat}) begin
        $error("oDat fault, dat = %0d,shift = %0d,result = %0d", dat,WIDTH,{{(WIDTH-$bits(dat)){1'b0}},dat});
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ZeroExtdM_tb,"+all");
    #500 $finish;
  end 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 