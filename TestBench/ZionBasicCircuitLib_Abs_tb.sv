module ZionBasicCircuitLib_Abs_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;

  logic [32 -1:0] iDat;
  logic [32 -1:0] oDat;

  initial begin
    forever #(period/2) 
      iDat = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (iDat[$high(iDat)]) begin
        if (oDat != ~iDat+1'b1) begin
          $error("-dat fault, %0d!=%0d", oDat,iDat);
          $finish;
        end
      end else  begin
        if (oDat != iDat) begin
          $error("+dat fault, %0d!=%0d", oDat,iDat);
          $finish;
        end
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Abs_tb,"+all");
    #500 $finish;
  end 

  `BcAbs ( U_Abs,
             iDat,
             oDat
        );
  
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
