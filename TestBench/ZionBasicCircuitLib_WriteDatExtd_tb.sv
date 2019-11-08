module ZionBasicCircuitLib_WriteDatExtd_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period    = 20,
            WIDTH_TYPE_NUM   = 3, 
            WIDTH_ADDR       = 32, 
            WIDTH_DATA_IN    = 32, 
            WIDTH_DATA_OUT   = 32,   
            ADDR_TYPE        = 1;

  logic [WIDTH_TYPE_NUM-1:0] iEn  ;
  logic [WIDTH_ADDR    -1:0] iAddr;
  logic [WIDTH_DATA_IN -1:0] iDat ;
  logic [WIDTH_DATA_OUT-1:0] oDat;
  logic [WIDTH_DATA_OUT-1:0] out;

parameter int MULTI_DATA_WIDTH[3] = {32,16,8};
  initial begin
    iDat = 0;
    iAddr = 0;
    iEn =0;
  end
  initial begin
    forever #(period/2) begin
      iDat  = {$random()}%(2100000000);
      iAddr = {$random()}%(32);
      iEn[0]  = {$random()}%(2);
      iEn[1]  = {$random()}%(2);
      iEn[2]  = ~iEn[1];
    end
  end
  
  
    if(WIDTH_TYPE_NUM==1) begin //test SingleDatGen
      always_comb begin
        if(iEn[0] == 0) begin
          out = 0;       
        end else if(iEn[0] == 1) begin
          if(iAddr == 0)
            out = iDat;
          else
            out = 0;
        end
      end
    end

    else if(WIDTH_TYPE_NUM==3 && ADDR_TYPE != 0) begin
      always_comb begin
        if(iEn[0] == '1) begin
           out=iDat;
        end
        else if(iEn == 3'b000) begin
          out = 0;
        end
        else if(iEn == 3'b100 ) begin
          if(iAddr == 1) begin
            out  = iDat[7:0] <<8;
          end
          else if(iAddr == 2) begin
            out  = iDat[7:0] << 16;
          end
          else if (iAddr == 3) begin
            out    = iDat[7:0] << 24;
          end
          else if (iAddr == 0) begin
            out = iDat[7:0];
          end else begin
            out =0;
          end
        end
        else if(iEn == 3'b010 )begin
          if(iAddr == 1)begin
            out = iDat[15:0] << 16;
          end else if (iAddr == 0) begin
            out = iDat[15:0];
          end else begin
            out = 0;  
          end 
        end
        else begin
          out = 0;
        end
      end
    end

    else if(WIDTH_TYPE_NUM==3 && ADDR_TYPE == 0) begin
      always_comb begin
        if(iEn[0] == '1) begin
          out=iDat;
        end
        else if(iEn == 3'b000)begin
          out = 0;
        end
        else if(iEn == 3'b100 )begin
          if(iAddr[31:29] == 1)begin
            out = iDat[7:0] << 8;
          end
          else if(iAddr[31:29] == 2) begin
            out = iDat[7:0] << 16;
          end
          else if(iAddr[31:29] == 3) begin
            out = iDat[7:0] << 24;
          end
          else if(iAddr[31:29] == 0) begin
            out = iDat[7:0];
          end
        end
        else if(iEn == 3'b010 )begin
          if(iAddr[31:30] == 2'b01)begin
            out = iDat << 16;
          end
          else if (iAddr[31:30] == 0) begin
            out = iDat[15:0];
          end
        end  
        else begin
            out = 0;
        end
      end
    end
  initial begin 
    forever #(period/2) begin
    #5;
    if(out != oDat)begin
          $error("in case of WIDTH_TYPE_NUM==3 &&ADDR_TYPE != 0,oDat fault,in MultiDatGen");
    end
    end
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars("+all");
    #1000 $finish;
  end 
  
  `BcWriteDatExtd  (
                    U_WriteDatExtd,  
                      iEn,iAddr,iDat,              //input
                      oDat,                       //output         
                     MULTI_DATA_WIDTH,
                     ADDR_TYPE
  );
  

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
