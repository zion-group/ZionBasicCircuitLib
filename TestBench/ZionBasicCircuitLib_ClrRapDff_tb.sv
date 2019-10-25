module ZionBasicCircuitLib_ClrRapDff_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,  
            INI_DATA    = 32'h1,
            half_period = 5;
  logic                 clk,rst;
  logic                 iClr;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;
  logic [WIDTH_OUT-1:0] out ;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  initial begin
    rst = 0; 
    #20 rst = 1;
    #20 rst = 0;
  end
  initial begin
    iClr = 0;
    iDat = 32'h0;
    forever @(negedge clk) begin
      iClr = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end

  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      if (!rst) begin
        if (iClr) begin 
          if (oDat != INI_DATA) begin
            $error("iClr fault, %0d!=%0d", oDat,INI_DATA);
            $finish;
          end
        end else if (out != oDat) begin
          $error("oDat fault, %0d!=%0d", out,oDat);
          $finish;
          end 
        end
      end
    end
  always_ff@(posedge clk)begin
    out <= iDat;
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ClrRapDff_tb,"+all");
    #500 $finish;
  end 
  
  `BcClrRapDff  (U_ClrRapDff,
                   clk,rst,iClr,iDat,     // input
                   oDat,                  // output
                   INI_DATA               // parameter
                );

`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_ClrRapDff_tb