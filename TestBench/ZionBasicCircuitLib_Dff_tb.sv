module ZionBasicCircuitLib_Dff_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,            
            half_period = 5;
  logic                 clk;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  initial begin
    forever @(negedge clk) begin
      iDat = {$random()}%(32'hffff_ffff);
    end
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Dff_tb,"+all");
    #500 $finish;
  end 
  `BcDff    (U_Dff,
               clk,iDat,        // input
               oDat             // output                
            );  
  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      if (oDat != iDat) begin
        $error("oDat fault, %0d!=%0d", oDat,iDat);
        $finish;
      end
    end
  end  
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_Dff_tb 