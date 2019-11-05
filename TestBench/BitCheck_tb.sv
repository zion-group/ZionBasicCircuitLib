module BitCheck_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period    = 20,
            WIDTH_BIT = 8,
            MASK_FLAG = 0;

  logic [31:0] iAddr,iDat;
  logic [31:0] oDat,oDat_rd,oDat_wr; 
  logic [32/WIDTH_BIT-1:0][WIDTH_BIT-1:0] datTmp;
 
  initial begin
    forever #(period/2) 
      iDat = {$random()}%(32'hffff_ffff);
  end
  //test ZionBasicCircuitLib_BitMaskGen.sv
  initial begin 
    forever #(period/2) begin
      #5;
      `gen_if(MASK_FLAG==0) begin
        foreach(datTmp[i])begin 
          if (datTmp[i] != ((iAddr == i)? '0 : '1))begin
            $error("in case of MASK_FLAG=0,oDat fault,in ZionBasicCircuitLib_BitMaskGen.sv");
            $finish;
          end
        end
      end `gen_elif(MASK_FLAG==1) begin
        foreach(datTmp[i]) begin
          if (datTmp[i] != ((iAddr == i)? '1 : '0))begin 
            $error("in case of MASK_FLAG=1,oDat fault,in ZionBasicCircuitLib_BitMaskGen.sv");
            $finish;
          end
        end
      end
    end
  end
  //test ZionBasicCircuitLib_BitWrite.sv
  initial begin 
    forever #(period/2) begin
      #5;
      foreach(datTmp[i])begin 
        if (datTmp[i] != ((iAddr == i)? iDat : '1))begin
          $error("oDat fault,in ZionBasicCircuitLib_BitWrite.sv");
          $finish;
        end
      end
    end
  end
  //test ZionBasicCircuitLib_BitRead.sv
  initial begin 
    forever #(period/2) begin
      #5;
      if (datTmp != iDat )begin
        $error("iDat fault,in ZionBasicCircuitLib_BitRead.sv");
        $finish;
      end else if (oDat_rd != datTmp) begin
        $error("oDat fault,in ZionBasicCircuitLib_BitRead.sv");
        $finish;
      end
    end
  end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,BitCheck_tb,"+all");
    #500 $finish;
  end 
  
  `BcBitMaskGen  (
                    U_BitMaskGen,  
                      iAddr,                //input
                      oDat,                 //output
                      WIDTH_BIT,MASK_FLAG   //parameter
      
                 );
  `BcBitRead     (
                    U_BitRead,  
                      iAddr,iDat,           //input
                      oDat_rd                  //output
                 );
  `BcBitWrite    (
                    U_BitWrite,
                      iAddr,iDat,           //input
                      oDat_wr                  //output
                 );

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
