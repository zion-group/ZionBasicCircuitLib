module ZionBasicCircuitLib_EnRspDff_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,  
            INI_DATA    = 32'h1,
            half_period = 5;
  logic                 clk,rst;
  logic                 iEn;
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
    iEn = 0;
    iDat = 32'h0;
    forever @(negedge clk) begin
      iEn  = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end

  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      if(!rst) begin 
        if (iEn) begin
          if (oDat!=iDat) begin
            $error("iDat fault, %0d!=%0d", oDat,iDat);
            $finish;
          end 
        end
      end else if (oDat!=out) begin
        $error("oDat fault, %0d!=%0d", oDat,out);
        $finish;
      end
    end
  end
  always_ff@(posedge clk)begin
    out <= oDat;
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_EnRspDff_tb,"+all");
    #1000 $finish;
  end 
  
  `BcEnRspDff  (U_EnRspDff,
                  clk,rst,iEn,iDat, // input
                  oDat,             // output
                  INI_DATA          // parameter
               );

`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_EnRspDff_tb


