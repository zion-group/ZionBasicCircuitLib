module ZionBasicCircuitLib_Bitmap2OhM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 8,   
            WIDTH_OUT   = 8,            
            period = 20;

  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;



  initial begin
    forever #(period)begin
      //iDat = {$random()}%(32'hffff_ffff);
      #20 iDat = 8'b1;
      #20 iDat = 8'b10;
      #20 iDat = 8'b11;
      #20 iDat = 8'b11;
      #20 iDat = 8'b11111;

    end
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Bitmap2OhM_tb,"+all");
    #500 $finish;
  end 
  //always_comb
  `BcBitmap2OhM    (
                     iDat,        // input
                     oDat         // output                
                  );   

  // initial begin 
  //   forever@(posedge clk) begin
  //     #(half_period/5);
  //     if(iEn) begin
  //       if (oDat != iDat) begin
  //         $error("iEn fault, %0d!=%0d", oDat,iDat);
  //         $finish;
  //       end
  //     end else if (oDat != out) begin
  //       $error("oDat fault, %0d!=%0d", oDat,out);
  //       $finish;       
  //     end
  //   end
  // end  
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_Bitmap2OhM_tb 