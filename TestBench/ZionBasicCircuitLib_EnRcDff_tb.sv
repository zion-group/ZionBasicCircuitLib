module ZionBasicCircuitLib_EnRcDff_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter WIDTH_IN    = 32,   
            WIDTH_OUT   = 32,  
            INI_DATA    = 32'h1,
            RST_CFG     = 0,
            half_period = 5;
  logic                 clk,rst;
  logic                 iEn;
  logic [WIDTH_IN -1:0] iDat;
  logic [WIDTH_OUT-1:0] oDat;
  logic [WIDTH_OUT-1:0] out;

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
      iEn  = {$random()}%2;
      iDat = {$random()}%(32'hffff_ffff);
    end
  end
  always_ff@(posedge clk)begin
    out <= oDat;
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_EnRcDff_tb,"+all");
    #500 $finish;
  end 
  

  `BcEnRcDff   (U_EnRcDff,
                  clk,rst,iEn,iDat,          // input
                  oDat,                      // output
                  INI_DATA,RST_CFG           // parameter  
                ); 
  initial begin 
    forever@(posedge clk) begin
      #(half_period/5);
      // DFF with asynchronous reset, and the reset signal is active low.
      if(RST_CFG == 0) begin
        if(rst) begin
          if(iEn) begin
            if (oDat != iDat) begin
              $error("iEn fault, %d!=%d,in the case of RST_CFG = %d", oDat,INI_DATA,RST_CFG);
              $finish;
            end
          end else if (oDat != out) begin
            $error("oDat fault, %d!=%d,in the case of RST_CFG = %d", oDat,out,RST_CFG);
            $finish;       
          end
        end
      end
      // DFF with asynchronous reset, and the reset signal is active high.
      if(RST_CFG == 1) begin
        if(!rst) begin
          if(iEn) begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,INI_DATA,RST_CFG);
              $finish;
            end
          end else if (oDat != out)begin 
            $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,out,RST_CFG);
            $finish;      
          end
        end
      end
      // DFF with  synchronous reset, and the reset signal is active low.
      if(RST_CFG == 2) begin
        if(rst) begin
          if(iEn) begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if (oDat != out)begin 
            $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,out,RST_CFG);
            $finish;       
          end
        end 
      end   
      //DFF with synchronous reset, and the reset signal is active high.
      if(RST_CFG == 3) begin
        if(!rst) begin
          if(iEn) begin
            if (oDat != iDat) begin
              $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,INI_DATA,RST_CFG);
              $finish;
            end 
          end else if (oDat != out)begin 
            $error("oDat fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat,out,RST_CFG);
            $finish;       
          end
        end
      end 

    //   if(RST_CFG4 == 4) begin
    //     `ifdef FPGA_PROJECT begin
    //       if (!rst) begin   
    //         if (iEn) begin 
    //           if (oDat4 != iDat) begin
    //             $error("iEn fault, %0d!=%0d,in the case of FPGA_PROJECT RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
    //             $finish;
    //           end
    //         end else if (oDat4 != iDat)begin
    //           $error("iDat fault, %0d!=%0d,in the case of FPGA_PROJECT RST_CFG = %0d", oDat4,iDat,RST_CFG4);
    //           $finish;
    //         end else if (oDat4 != out4)begin 
    //           $error("oDat4 fault, %0d!=%0d,in the case of FPGA_PROJECT RST_CFG = %0d", oDat4,out4,RST_CFG4);
    //           $finish;      
    //         end
    //       end
    //     end
        
    //     `elsif ASIC_PROJECT begin
    //       if (rst) begin 
    //         if (iEn) begin 
    //           if (oDat4 != iDat) begin
    //             $error("iEn fault, %0d!=%0d,in the case of ASIC_PROJECT RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
    //             $finish;
    //           end
    //         end else begin
    //             if (oDat4 != iDat) begin
    //               $error("iDat fault, %0d!=%0d,in the case of ASIC_PROJECT RST_CFG = %0d", oDat4,iDat,RST_CFG4);
    //               $finish;
    //             end 
    //         end else begin 
    //           if (oDat4 != out4) begin
    //             $error("oDat4 fault, %0d!=%0d,in the case of ASIC_PROJECT RST_CFG = %0d", oDat4,out4,RST_CFG4);
    //             $finish;
    //           end       
    //         end
    //       end 
    //     end
    //     `else
    //       if(rst) begin 
    //         if(iEn) begin
    //           if (oDat4 != iDat) begin
    //             $error("iEn fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat4,INI_DATA,RST_CFG4);
    //             $finish;
    //           end 
    //         end else if (oDat4 != out4)begin 
    //           $error("oDat4 fault, %0d!=%0d,in the case of RST_CFG = %0d", oDat4,out4,RST_CFG4);
    //           $finish;
    //         end       
    //       end   
    //     `endif
    //     end
    //   end
    end
  end
 
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 