module ZionBasicCircuitLib_ClrEnRcDff_tb; 
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,  
            INI_DATA    = 32'h1,
            RST_CFG     = 0,
            half_period = 5;
  logic                 clk,rst,iEn;
  logic                 iClr;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;
  logic [WIDTH_OUT-1:0] out ;


  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  initial begin
    rst = 1; 
    #20 rst = 0;
    #20 rst = 1;
  end
  initial begin
    iClr = 0;
    iEn  = 0;
    iDat = 32'h0;
    forever @(negedge clk) begin
      iClr = {$random()}%2;
      iEn  = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end
  
  always_ff@(posedge clk)begin
    out <= oDat;
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ClrEnRcDff_tb,"+all");
    #500 $finish;
  end 
  


  `BcClrEnRcDff  (U_ClrEnRcDff,           // DFF with asynchronous reset, and the reset signal is active low.
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat,                    // output
                  INI_DATA,RST_CFG         // parameter
                );

  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      // DFF with asynchronous reset, and the reset signal is active low.
      if(RST_CFG == 0) begin//
        if(!rst) begin
          if (oDat != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of RST_CFG0 = %0d", oDat,INI_DATA,RST_CFG);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG0 = %0d", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG0 = %0d", oDat,iDat,RST_CFG);
              $finish;
            end 
          end else if (oDat != out) begin
            $error("oDat0 fault, %0d!=%0d,in the case of RST_CFG0 = %0d", oDat,out,RST_CFG);
            $finish;       
          end
        end
      end
      // DFF with asynchronous reset, and the reset signal is active high.
      if(RST_CFG == 1) begin//
        if(rst) begin
          if (oDat != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,INI_DATA,RST_CFG);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if(iEn) begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,iDat,RST_CFG);
              $finish;
            end
          end else if (oDat != out)begin 
              $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,out,RST_CFG);
              $finish;      
          end
        end
      end
      // DFF with  synchronous reset, and the reset signal is active low.
      if(RST_CFG == 2) begin//
        if(rst) begin
          if(iClr) begin
            if (oDat != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,iDat,RST_CFG);
              $finish;
            end
          end else if (oDat != out)begin 
            $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,out,RST_CFG);
            $finish;       
          end
        end
      end    
      //DFF with synchronous reset, and the reset signal is active high.
      if(RST_CFG == 3) begin//|| (RST_MACRO_CFG==0)
        if(!rst) begin
          if(iClr) begin
            if (oDat != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,iDat,RST_CFG);
              $finish;
            end
          end else if (oDat != out)begin 
            $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d ", oDat,out,RST_CFG);
            $finish;       
          end
        end
      end    
    end
  end
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule