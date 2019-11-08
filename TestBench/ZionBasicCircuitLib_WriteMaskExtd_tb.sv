module ZionBasicCircuitLib_WriteMaskExtd_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period    = 20,
            WIDTH_TYPE_NUM   = 3, 
            WIDTH_ADDR       = 32, 
            WIDTH_DATA_OUT   = 32, 
            MASK_FLAG        = 0,   
            ADDR_TYPE        = 1;

  logic [WIDTH_TYPE_NUM-1:0] iEn  ;
  logic [WIDTH_ADDR    -1:0] iAddr;
  logic [31:0]maskFlg,unmaskFlg;
  logic [WIDTH_DATA_OUT-1:0] oDat;
  logic [WIDTH_DATA_OUT-1:0] out;

parameter int MASK_WIDTH[3] = {32,16,8};



  initial begin
    iAddr = 0;
    iEn =0;
  end
  initial begin
      forever #(period/2) begin
      iAddr = {$random()}%(32);
      iEn[0]   = {$random()}%(2);
      iEn[1]   = {$random()}%(2);
      iEn[2]   = ~iEn[1];
      
    end
  end
  
    //if(MASK_FLAG) begin
      //assign maskFlg   = '0;
      //assign unmaskFlg = '1;
      if(MASK_FLAG==0) begin
      assign maskFlg   = '1;
      assign unmaskFlg = '0;
    if(WIDTH_TYPE_NUM==1) begin //test SingleDatGen
      always_comb begin
        if(iEn[0] == 0) begin
          out =unmaskFlg;       
        end else if(iEn[0] == 1) begin
          if(iAddr == 0)
            out = maskFlg;
          else
            out = unmaskFlg;
        end
      end
    end

    else if(WIDTH_TYPE_NUM==3 && ADDR_TYPE != 0) begin
      always_comb begin
        if(iEn[0] == 1) begin
           out=maskFlg;
        end
        else if(iEn == 3'b000) begin
          out = unmaskFlg;
        end
        else if(iEn == 3'b100 ) begin
          if(iAddr == 1) begin
            out  = maskFlg[7:0] <<8;
          end
          else if(iAddr == 2) begin
            out  = maskFlg[7:0] << 16;
          end
          else if (iAddr == 3) begin
            out    = maskFlg[7:0] << 24;
          end
          else if (iAddr == 0) begin
            out = maskFlg[7:0];
          end else begin
            out =unmaskFlg;
          end
        end
        else if(iEn == 3'b010 )begin
          if(iAddr == 1)begin
            out = maskFlg[15:0] << 16;
          end else if (iAddr == 0) begin
            out = maskFlg[15:0];
          end else begin
            out = unmaskFlg;  
          end 
        end
        else begin
          out = unmaskFlg;
        end
      end
    end


    else if(WIDTH_TYPE_NUM==3 && ADDR_TYPE == 0) begin
      always_comb begin
        if(iEn[0] == 1) begin
          out=maskFlg;
        end
        else if(iEn == 3'b000)begin
          out =unmaskFlg;
        end
        else if(iEn == 3'b100 )begin
          if(iAddr[31:29] == 1)begin
            out = maskFlg[7:0] << 8;
          end
          else if(iAddr[31:29] == 2) begin
            out = maskFlg[7:0] << 16;
          end
          else if(iAddr[31:29] == 3) begin
            out = maskFlg[7:0] << 24;
          end
          else if(iAddr[31:29] == 0) begin
            out = maskFlg[7:0];
          end
        end
        else if(iEn == 3'b010 )begin
          if(iAddr[31:30] == 2'b01)begin
            out = maskFlg << 16;
          end
          else if (iAddr[31:30] == 0) begin
            out = maskFlg[15:0];
          end
        end  
        else begin
            out = unmaskFlg;
        end
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
  
  `BcWriteMaskExtd  (
                     U_WriteMaskExtd,  
                      iEn, 
                      iAddr,                //input
                      oDat,                 //output 
                      MASK_WIDTH,
                      ADDR_TYPE,
                      MASK_FLAG
                 );

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 