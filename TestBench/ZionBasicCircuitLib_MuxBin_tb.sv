module ZionBasicCircuitLib_MuxBin_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 8,  
            WIDTH_SEL   = 2,
            period      = 20;
  logic [WIDTH_SEL-1:0] iSel;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;
  ///wire  [WIDTH_OUT/WIDTH_IN-1:0][WIDTH_IN-1:0] datTmp;
  initial begin
    forever #(period) begin
      iSel = {$random()}%3;
      iDat = {$random()}%(32'h1111_1111);
    end
  end

  // initial begin 
  //   forever #(period) begin
  //     #(period/5);
  //     if (oDat != datTmp[iSel]) begin
  //       $error("oDat fault, %0d!=%0d", oDat,datTmp[iSel]);
  //       $finish;
  //     end 
  //   end
  // end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_MuxBin_tb,"+all");
    #1000 $finish;
  end 
  
  `BcMuxBin  (U_MuxBin,
                iSel,iDat,         // input
                oDat               // output
             );

  `Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_MuxBin_tb

