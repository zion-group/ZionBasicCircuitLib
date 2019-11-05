
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_WriteMaskExtd
// Author      : Wenheng Ma
// Date        : 2019-11-03
// Version     : 1.0
// Parameter   :
//   TODO
// Description :
//   TODO
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-03 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_WriteMaskExtd
`ifdef ZionBasicCircuitLib_WriteMaskExtd
  `__DefErr__(ZionBasicCircuitLib_WriteMaskExtd)
`else
  `define ZionBasicCircuitLib_WriteMaskExtd(UnitName,iEn_MT,iAddr_MT,iDat_MT,oDat_MT,MASK_WIDTH_MT={0},ADDR_TYPE_MT=0,MASK_FLAG_MT=0) \
ZionBasicCircuitLib_WriteMaskExtd  #(.WIDTH_TYPE_NUM($bits(iEn_MT)),  \
                                  .WIDTH_ADDR($bits(iAddr_MT)),       \
                                  .MASK_WIDTH(MASK_WIDTH_MT),         \
                                  .WIDTH_DATA_OUT($bits(oDat_MT)),    \
                                  .ADDR_TYPE(ADDR_TYPE_MT),           \
                                  .MASK_FLAG(MASK_FLAG_MT))           \
                                UnitName(                             \
                                  .iEn(iEn_MT),                       \
                                  .iAddr(iAddr_MT),                   \
                                  .oDat(oDat_MT)                      \
                                )
`endif

module ZionBasicCircuitLib_WriteMaskExtd
#(WIDTH_TYPE_NUM = "_", //$bits(iEn)  // number of width type
  WIDTH_ADDR     = "_", //$bits(iAddr)// width of input  addr
  MASK_WIDTH     = "_",
  WIDTH_DATA_OUT = "_", //$bits(oDat) // width of output data
  ADDR_TYPE      =  0 ,
  MASK_FLAG      =  0
)(
  input        [WIDTH_TYPE_NUM-1:0] iEn  ,
  input        [WIDTH_ADDR    -1:0] iAddr,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_TYPE_NUM-1:0][WIDTH_DATA_OUT-1:0] rsltTmp;

  `gen_if(WIDTH_TYPE_NUM==1) begin :  SingleDatGen
    logic [WIDTH_DATA_OUT/MASK_WIDTH-1:0][MASK_WIDTH-1:0] datTmp;
    logic [MASK_WIDTH-1:0] maskFlg, unmaskFlg;
    `gen_if(MASK_FLAG) begin
      assign maskFlg   = '0;
      assign unmaskFlg = '1;
    end `gen_else begin
      assign maskFlg   = '1;
      assign unmaskFlg = '0;
    end
    wire  [MASK_WIDTH-1:0] wrDat = (iEn[0])? maskFlg : unmaskFlg;
    always_comb begin
      foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : unmaskFlg;
    end
    assign oDat = datTmp;
  end `gen_else begin : MultiDatGen
    for(genvar i=0;i<WIDTH_TYPE_NUM;i++) begin : EachDatGen
      logic [WIDTH_DATA_OUT/MASK_WIDTH[i]-1:0][MASK_WIDTH[i]-1:0] datTmp;
      logic [MASK_WIDTH[i]-1:0] maskFlg, unmaskFlg;
      `gen_if(MASK_FLAG) begin
        assign maskFlg   = '0;
        assign unmaskFlg = '1;
      end `gen_else begin
        assign maskFlg   = '1;
        assign unmaskFlg = '0;
      end
      wire  [MASK_WIDTH[i]-1:0] wrDat = (iEn[i])? maskFlg : unmaskFlg;
      `gen_if(MASK_WIDTH[i]==WIDTH_DATA_OUT) begin : DataGen_FullWidth
        datTmp[0] = wrDat ;
      end `gen_else begin : DataGen_NonFullWidth
        `gen_if(ADDR_TYPE==0) begin : AddrType0_datTmpGen
          always_comb begin
            foreach(datTmp[j]) begin
              datTmp[j] = (iAddr[$high(iAddr)-:$clog(WIDTH_DATA_OUT/MASK_WIDTH[i])] == j)? wrDat : unmaskFlg;
            end
          end
        end `gen_else begin : AddrType1_datTmpGen
          always_comb begin
            foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : unmaskFlg;
          end
        end
      end
      assign rsltTmp[i] = datTmp;
    end
    assign oDat = |rsltTmp;
  end


  // // parameter check.
  // initial begin
  //   if((WIDTH_DATA_OUT % WIDTH_DATA_IN)!=0) begin
  //     $error("Parameter Error: Width mismatch!!");
  //     `ifdef CHECK_ERR_EXIT
  //       $finish;
  //     `endif
  //   end 
  //   if(WIDTH_DATA_OUT > (2**WIDTH_ADDR)*WIDTH_DATA_IN) begin
  //     $error("Parameter Error: Width of output data is overflow!!");
  //     `ifdef CHECK_ERR_EXIT
  //       $finish;
  //     `endif
  //   end
  // end

endmodule : ZionBasicCircuitLib_WriteMaskExtd
`endif