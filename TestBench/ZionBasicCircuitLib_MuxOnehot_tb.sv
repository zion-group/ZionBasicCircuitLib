module ZionBasicCircuitLib_MuxOnehot_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 8,  
            WIDTH_SEL   = 4, 
            period      = 20;
  logic [WIDTH_SEL-1:0] iSel;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;

  initial begin
    forever #(period) begin
      #20 iSel = 4'b0000;iDat = {$random()}%(32'hffff_ffff);
      #20 iSel = 4'b0010;iDat = {$random()}%(32'hffff_ffff);
      #20 iSel = 4'b0100;iDat = {$random()}%(32'hffff_ffff);
      #20 iSel = 4'b1000;iDat = {$random()}%(32'hffff_ffff);
    end
  end

  // initial begin 
  //   forever #(period) begin
  //     #(period/5);
  //     if (oDat != rsltTmp) begin
  //       $error("oDat fault, %0d!=%0d", oDat,datTmp[iSel]);
  //       $finish;
  //     end 
  //   end
  // end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_MuxOnehot_tb,"+all");
    #1000 $finish;
  end 
  
  `BcMuxOnehot  (U_MuxOnehot,
                   iSel,iDat,         // input
                   oDat               // output
             );

  `Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_MuxOnehot_tb

