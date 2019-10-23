module ZionBasicCircuitLib_ClrEnRcDff_tb; 
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,  
            INI_DATA    = 32'h1,
            RST_CFG0    = 0,
            RST_CFG1    = 1,
            RST_CFG2    = 2,
            RST_CFG3    = 3,
            RST_CFG4    = 4,
            half_period = 5;
  logic                 clk,rst,iEn;
  logic                 iClr;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat0;
  logic [WIDTH_OUT-1:0] oDat1;
  logic [WIDTH_OUT-1:0] oDat2;
  logic [WIDTH_OUT-1:0] oDat3;
  logic [WIDTH_OUT-1:0] oDat4;
  logic [WIDTH_OUT-1:0] out0 ;
  logic [WIDTH_OUT-1:0] out1 ;
  logic [WIDTH_OUT-1:0] out2 ;
  logic [WIDTH_OUT-1:0] out3 ;
  logic [WIDTH_OUT-1:0] out4 ;

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
    out0 <= oDat0;
    out1 <= oDat1;
    out2 <= oDat2;
    out3 <= oDat3;
    out4 <= oDat4;
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ClrEnRcDff_tb,"+all");
    #500 $finish;
  end 
  `BcClrEnRcDff  (U_ClrEnRcDff_0,           // DFF with asynchronous reset, and the reset signal is active low.
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat0,                    // output
                  INI_DATA,RST_CFG0         // parameter
                );
  `BcClrEnRcDff  (U_ClrEnRcDff_1,           // DFF with asynchronous reset, and the reset signal is active high.
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat1,                    // output
                  INI_DATA,RST_CFG1         // parameter
                );
  `BcClrEnRcDff  (U_ClrEnRcDff_2,           // DFF with  synchronous reset, and the reset signal is active low.
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat2,                    // output
                  INI_DATA,RST_CFG2         // parameter
                );
  `BcClrEnRcDff  (U_ClrEnRcDff_3,           // DFF with synchronous reset, and the reset signal is active high.
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat3,                    // output
                  INI_DATA,RST_CFG3         // parameter
                );
  `BcClrEnRcDff  (U_ClrEnRcDff_4,           // FPGA_PROJECT OR ASIC_PROJECT
                  clk,rst,iEn,iClr,iDat,    // input
                  oDat4,                    // output
                  INI_DATA                  // parameter
                );
  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      // DFF with asynchronous reset, and the reset signal is active low.
      if(RST_CFG0 == 0) begin
        if(!rst) begin
          if (oDat0 != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of %0d = ", oDat0,INI_DATA,RST_CFG0);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat0 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of %0d = ", oDat0,INI_DATA,RST_CFG0);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat0 != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of %0d = ", oDat0,iDat,RST_CFG0);
              $finish;
            end 
          end else if (oDat0 != out0) begin
            $error("oDat0 fault, %0d!=%0d,in the case of %0d = ", oDat0,out0,RST_CFG0);
            $finish;       
          end
        end
      end
      // DFF with asynchronous reset, and the reset signal is active high.
      if(RST_CFG1 == 1) begin
        if(rst) begin
          if (oDat1 != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of %0d = ", oDat1,INI_DATA,RST_CFG1);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat1 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of %0d = ", oDat1,INI_DATA,RST_CFG1);
              $finish;
            end 
          end else if(iEn) begin
            if (oDat1 != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of %0d = ", oDat1,iDat,RST_CFG1);
              $finish;
            end
          end else if (oDat1 != out1)begin 
              $error("oDat1 fault, %0d!=%0d,in the case of %0d = ", oDat1,out1,RST_CFG1);
              $finish;      
          end
        end
      end
      // DFF with  synchronous reset, and the reset signal is active low.
      if(RST_CFG2 == 2) begin
        if(!rst) begin
          if (oDat2 != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of %0d = ", oDat2,INI_DATA,RST_CFG2);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat2 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of %0d = ", oDat2,INI_DATA,RST_CFG2);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat2 != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of %0d = ", oDat2,iDat,RST_CFG2);
              $finish;
            end
          end else if (oDat2 != out2)begin 
            $error("oDat2 fault, %0d!=%0d,in the case of %0d = ", oDat2,out2,RST_CFG2);
            $finish;       
          end
        end
      end    
      //DFF with synchronous reset, and the reset signal is active high.
      if(RST_CFG3 == 3) begin
        if(rst) begin
          if (oDat3 != INI_DATA) begin
            $error("rst fault, %0d!=%0d,in the case of %0d = ", oDat3,INI_DATA,RST_CFG3);
            $finish;
          end 
        end else begin
          if(iClr) begin
            if (oDat3 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of %0d = ", oDat3,INI_DATA,RST_CFG3);
              $finish;
            end 
          end else if(iEn)begin
            if (oDat3 != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of %0d = ", oDat3,iDat,RST_CFG3);
              $finish;
            end
          end else if (oDat3 != out3)begin 
            $error("oDat3 fault, %0d!=%0d,in the case of %0d = ", oDat3,out3,RST_CFG3);
            $finish;       
          end
        end
      end    

      //`define FPGA_PROJECT
      if(RST_CFG4== 4) begin
        `ifdef FPGA_PROJECT begin
          if (!rst) begin   
            if (iClr) begin 
              if (oDat4 != INI_DATA) begin
                $error("iClr fault, %0d!=%0d,in the case of FPGA_PROJECT %0d =", oDat4,INI_DATA,RST_CFG4);
                $finish;
              end
            end else if (iEn) begin
              if (oDat4 != iDat)begin
                $error("iDat fault, %0d!=%0d,in the case of FPGA_PROJECT %0d =", oDat4,iDat,RST_CFG4);
                $finish;
              end
            end else if (oDat4 != out4)begin 
              $error("oDat4 fault, %0d!=%0d,in the case of FPGA_PROJECT %0d = ", oDat4,out4,RST_CFG4);
              $finish;      
            end
          end
        end
        `elsif ASIC_PROJECT begin
          if (rst) begin 
            if (iClr) begin 
              if (oDat4 != INI_DATA) begin
                $error("iClr fault, %0d!=%0d,in the case of ASIC_PROJECT %0d = ", oDat4,INI_DATA,RST_CFG4);
                $finish;
              end
            end else if (iEn) begin
              if (oDat4 != iDat) begin
                $error("iDat fault, %0d!=%0d,in the case of ASIC_PROJECT %0d = ,", oDat4,iDat,RST_CFG4);
                $finish;
              end
            end else if (oDat4 != out4) begin 
              $error("oDat fault, %0d!=%0d,in the case of ASIC_PROJECT %0d = ", oDat4,out4,RST_CFG4);
              $finish;      
            end
          end 
        end
        `else
        if(rst) begin 
          if(iClr) begin
            if (oDat4 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of %0d = ", oDat4,INI_DATA,RST_CFG4);
              $finish;
            end 
          end else if(iEn) begin
            if (oDat4 != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of %0d = ", oDat4,iDat,RST_CFG4);
              $finish;
            end 
          end else if (oDat4 != out4)begin 
            $error("oDat4 fault, %0d!=%0d,in the case of %0d = ", oDat4,out4,RST_CFG4);
            $finish;
          end       
        end   
        `endif
      end
      //`undef  FPGA_PROJECT
    end
  end
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule