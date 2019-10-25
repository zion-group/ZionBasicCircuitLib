module ZionBasicCircuitLib_EnDff_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,            
            half_period = 5;
  logic                 clk;
  logic                 iEn;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;
  logic [WIDTH_OUT-1:0] out;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  initial begin
    forever @(negedge clk) begin
      iEn  = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end
  always_ff@(posedge clk)begin
    out <= oDat;
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_EnDff,"+all");
    #500 $finish;
  end 
  `BcEnDff    (U_EnDff,
                 clk,iEn,iDat,        // input
                 oDat                 // output                
              );   
  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      if(iEn) begin
        if (oDat != iDat) begin
          $error("iEn fault, %0d!=%0d", oDat,iDat);
          $finish;
        end
      end else if (oDat != out) begin
        $error("oDat fault, %0d!=%0d", oDat,out);
        $finish;       
      end
    end
  end  
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_EnDff_tb 