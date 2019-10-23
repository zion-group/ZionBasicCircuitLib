module ZionBasicCircuitLib_ClrRcDff_tb;
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
  logic                 clk,rst;
  logic                 iClr;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat0;
  logic [WIDTH_OUT-1:0] oDat1;
  logic [WIDTH_OUT-1:0] oDat2;
  logic [WIDTH_OUT-1:0] oDat3;
  logic [WIDTH_OUT-1:0] oDat4;

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
    forever @(negedge clk) begin
      iClr = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ClrRcDff_tb,"+all");
    #500 $finish;
  end 
  
  //`define FPGA_PROJECT
    
  `BcClrRcDff   (U_ClrRcDff_0,
                   clk,rst,iClr,iDat,         // input
                   oDat0,                     // output
                   INI_DATA,RST_CFG0          // parameter  
                );  
  `BcClrRcDff   (U_ClrRcDff_1,
                   clk,rst,iClr,iDat,         // input
                   oDat1,                     // output
                   INI_DATA,RST_CFG1          // parameter  
                );  
  `BcClrRcDff   (U_ClrRcDff_2,
                   clk,rst,iClr,iDat,         // input
                   oDat2,                     // output
                   INI_DATA,RST_CFG2          // parameter 
                );  
  `BcClrRcDff   (U_ClrRcDff_3,
                   clk,rst,iClr,iDat,         // input
                   oDat3,                     // output
                   INI_DATA,RST_CFG3          // parameter 
                );  
  `BcClrRcDff   (U_ClrRcDff_4,
                   clk,rst,iClr,iDat,         // input
                   oDat4,                     // output
                   INI_DATA                   // parameter  
                );  
  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      // DFF with asynchronous reset, and the reset signal is active low.
      if(RST_CFG0 == 0) begin
        if(rst) begin
          if(iClr) begin
            if (oDat0 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat0,INI_DATA,RST_CFG0);
              $finish;
            end
          end else if (oDat0 != iDat) begin
            $error("oDat0 fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat0,iDat,RST_CFG0);
            $finish;       
          end
        end
      end
      // DFF with asynchronous reset, and the reset signal is active high.
      if(RST_CFG1 == 1) begin
        if(!rst) begin
          if(iClr) begin
            if (oDat1 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat1,INI_DATA,RST_CFG1);
              $finish;
            end
          end else if (oDat1 != iDat)begin 
            $error("oDat1 fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat1,iDat,RST_CFG1);
            $finish;      
          end
        end
      end
      // DFF with  synchronous reset, and the reset signal is active low.
      if(RST_CFG2 == 2) begin
        if(rst) begin
          if(iClr) begin
            if (oDat2 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat2,INI_DATA,RST_CFG2);
              $finish;
            end 
          end else if (oDat2 != iDat)begin 
            $error("oDat2 fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat2,iDat,RST_CFG2);
            $finish;       
          end
        end 
      end   
      //DFF with synchronous reset, and the reset signal is active high.
      if(RST_CFG3 == 3) begin
        if(!rst) begin
          if(iClr) begin
            if (oDat3 != INI_DATA) begin
              $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat3,INI_DATA,RST_CFG3);
              $finish;
            end 
          end else if (oDat3 != iDat)begin 
            $error("oDat3 fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat3,iDat,RST_CFG3);
            $finish;       
          end
        end
      end    
      if(RST_CFG4 == 4) begin
        `ifdef FPGA_PROJECT begin
          if (!rst) begin   
            if (iClr) begin 
              if (oDat4 != INI_DATA) begin
                $error("iClr fault, %0d!=%0d,in the case of FPGA_PROJECT RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
                $finish;
              end
            end else if (oDat4 != iDat)begin
              $error("iDat fault, %0d!=%0d,in the case of FPGA_PROJECT RST_CFG = %0d", oDat4,iDat,RST_CFG4);
              $finish;
          end
        end
        `elsif ASIC_PROJECT begin
          if (rst) begin 
            if (iClr) begin 
              if (oDat4 != INI_DATA) begin
                $error("iClr fault, %0d!=%0d,in the case of ASIC_PROJECT RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
                $finish;
              end
            end else begin
              if (oDat4 != iDat) begin
                $error("iDat fault, %0d!=%0d,in the case of ASIC_PROJECT RST_CFG = %0d", oDat4,iDat,RST_CFG4);
                $finish;
              end
            end    
          end 
        end
        `else begin
          if(rst) begin 
            if(iClr) begin
              if (oDat4 != INI_DATA) begin
                $error("iClr fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
                $finish;
              end 
            end else begin 
              if (oDat4 != iDat)begin 
                $error("iDat fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat4,iDat,RST_CFG4);
                $finish;
              end
            end       
          end 
        end  
        `endif 
      end
    end
    //`undef FPGA_PROJECT
  end
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
