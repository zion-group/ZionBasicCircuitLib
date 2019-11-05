module ZionBasicCircuitLib_Bin2OhM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter START     = 0,
            STEP      = 1,
            period    = 20;

  logic [                        16:0] iDat,oDat_M;
  logic [                        16:0] iDat_width;
  logic [                        16:0] oDat,ohDat;
  logic [(($bits(iDat)-START)/STEP):0] ohDat_M;

  initial begin
    forever #(period/2) begin
      iDat       = {$random()}%(32'hffff_ffff); 
      iDat_width = {$random()}%(32'hffff_ffff);    
    end
  end
  //test ZionBasicCircuitLib_Bin2OhM.vm
  initial begin 
    forever #(period/2) begin
      #5;
      for(int i = 0 ; i < 32 ; i ++) begin // foreach(oDat[i])
        if (iDat == (i*STEP + START)) begin
          if (oDat_M[i] != 1) begin
            $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_Bin2OhM.vm ", oDat_M[i],iDat,i);
            $finish;
          end
        end else  begin
          if (oDat_M[i]) begin
            $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_Bin2OhM.vm ", oDat_M[i],iDat,i);
            $finish;
          end
        end
      end
    end
  end
  //test ZionBasicCircuitLib_Bin2Oh.sv
  initial begin 
    forever #(period/2) begin
      #5;
      for(int i = 0 ; i < 32 ; i ++) begin 
        if (iDat_width == (i*STEP + START)) begin
          if (!oDat[i]) begin
            $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_Bin2Oh.sv ", oDat[i],iDat_width,i);
            $finish;
          end
        end else  begin
          if (oDat[i]) begin
            $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_Bin2Oh.sv ", oDat[i],iDat_width,i);
            $finish;
          end
        end
      end
    end
  end
  //test ZionBasicCircuitLib_OnehotDef.sv
  initial begin 
    forever #(period/2) begin
      #5;
      for(int i = 0 ; i < 32 ; i ++) begin //foreach(ohDat[i])
        if (iDat == (i*STEP + START)) begin
          if (!ohDat[i] ) begin
            $error("ohDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_OnehotDef.sv ", ohDat[i],iDat,i*STEP + START);
            $finish;
          end
        end else  begin
          if (ohDat[i]) begin
            $error("ohDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_OnehotDef.sv ", ohDat[i],iDat,i);
            $finish;
          end
        end
      end
    end
  end
  //test ZionBasicCircuitLib_OnehotDefM.sv
  initial begin 
    forever #(period/2) begin
      #5;
      for(int i = 0 ; i < 32 ; i ++)begin // foreach(ohDat_M[i])
        if (iDat == (i*STEP + START)) begin
          if (ohDat_M[i] != 1) begin
            $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_OnehotDefM.sv ", ohDat_M[i],iDat,i);
            $finish;
          end else  begin
            if (ohDat_M[i]) begin
              $error("oDat fault, %0d!=%0d,%0d,in ZionBasicCircuitLib_OnehotDefM.sv ", ohDat_M[i],iDat,i);
              $finish;
            end
          end
        end
      end
    end
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Bin2OhM_tb,"+all");
    #500 $finish;
  end 
  always_comb 
  `BcBin2OhM    ( 
                  iDat,                 //input 
                  oDat_M                //output
                  //START,STEP          //parameter
                );
  `BcBin2Oh     (U_Bin2Oh,
                   iDat_width,       //input 
                   oDat              //output  
                );     
  `BcOnehotDef  ( 
                  iDat_width,           //input 
                   ohDat         //output
                    //parameter
                );       

  always_comb    
  `BcOnehotDefM (      
                                    
                  ohDat_M,        //output
                   iDat           //input
                );



`Unuse_ZionBasicCircuitLib(Bc)
endmodule 