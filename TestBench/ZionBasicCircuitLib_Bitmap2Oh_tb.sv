module ZionBasicCircuitLib_Bitmap2Oh_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 8,   
            WIDTH_OUT   = 8,            
            period = 20;

  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;

 

  initial begin
    forever #(period)begin
      iDat = {$random()}%(8'b1111_1111);
    end
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Bitmap2Oh,"+all");
    #500 $finish;
  end 

  `BcBitmap2Oh    (U_Bitmap2Oh,
                     iDat,        // input
                     oDat         // output                
                  );   

 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_Bitmap2Oh_tb 