module ZionBasicCircuitLib_Bin2OhM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter START = 0,
            STEP  = 1,
            period = 20;

  logic [31:0] iDat,oDat;

  initial begin
    forever #(period/2) 
      iDat = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      for(int i = 0 ; i < 32 ; i ++) begin 
        if (iDat == (i*STEP + START)) begin
          if (oDat[i] != 1) begin
            $error("oDat fault, %0d!=%0d,%0d", oDat[i],iDat,i);
            $finish;
          end
        end else  begin
          if (oDat[i]) begin
            $error("oDat fault, %0d!=%0d,%0d", oDat[i],iDat,i);
            $finish;
          end
        end
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Bin2OhM_tb,"+all");
    #500 $finish;
  end 
  always_comb
  `BcBin2OhM  ( iDat,           //input 
                oDat          //output
                //START,STEP    //parameter
              );
  
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 