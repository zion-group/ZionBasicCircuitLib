
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_DatRead
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
`ifndef Disable_ZionBasicCircuitLib_DatRead
`ifdef ZionBasicCircuitLib_DatRead
  `__DefErr__(ZionBasicCircuitLib_DatRead)
`else
  `define ZionBasicCircuitLib_DatRead(UnitName,iEn_MT,iAddr_MT,iDat_MT,oDat_MT,MULTI_DATA_WIDTH_MT={0},ADDR_TYPE_MT=0) \
ZionBasicCircuitLib_DatRead #(.WIDTH_TYPE_NUM($bits(iEn_MT)),           \
                                .WIDTH_ADDR($bits(iAddr_MT)),           \
                                .WIDTH_DATA_IN($bits(iDat_MT)),         \
                                .WIDTH_DATA_OUT($bits(oDat_MT)),        \
                                .MULTI_DATA_WIDTH(MULTI_DATA_WIDTH_MT), \
                                .ADDR_TYPE(ADDR_TYPE_MT))               \
                              UnitName(                                 \
                                .iEn(iEn_MT),                           \
                                .iAddr(iAddr_MT),                       \
                                .iDat(iDat_MT),                         \
                                .oDat(oDat_MT)                          \
                              )
`endif

module ZionBasicCircuitLib_DatRead
#(WIDTH_TYPE_NUM   = "_", //$bits(iEn)  // number of width type
  WIDTH_ADDR       = "_", //$bits(iAddr)// width of input  addr
  WIDTH_DATA_IN    = "_", //$bits(iDat) // width of input  data
  WIDTH_DATA_OUT   = "_", //$bits(oDat) // width of output data
  MULTI_DATA_WIDTH = "_",
  ADDR_TYPE        = 0
)(
  input        [WIDTH_TYPE_NUM-1:0] iEn  ,
  input        [WIDTH_ADDR    -1:0] iAddr,
  input        [WIDTH_DATA_IN -1:0] iDat ,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_TYPE_NUM-1:0][WIDTH_DATA_OUT-1:0] rsltTmp;

  `gen_if(WIDTH_TYPE_NUM==1) begin :  SingleDatGen
    logic [WIDTH_DATA_IN/WIDTH_DATA_OUT-1:0][WIDTH_DATA_OUT-1:0] datTmp, readDat;
    assign datTmp = (iEn[0])? iDat : '0;
    always_comb begin
      foreach(readDat[j]) readDat[j] = (iAddr == j)? datTmp[j] : '0;
    end
    assign oDat = |readDat;
  end `gen_else begin : MultiDatGen
    for(genvar i=0;i<WIDTH_TYPE_NUM;i++) begin : EachDatGen
      logic [WIDTH_DATA_OUT/MULTI_DATA_WIDTH[i]-1:0][MULTI_DATA_WIDTH[i]-1:0] datTmp, readDat;
      assign datTmp = (iEn[i])? iDat : '0;
      `gen_if(MULTI_DATA_WIDTH[i]==WIDTH_DATA_OUT) begin : DataGen_FullWidth
        assign readDat = datTmp;
      end `gen_else begin : DataGen_NonFullWidth
        `gen_if(ADDR_TYPE==0) begin : AddrType0_readDatGen
          always_comb begin
            foreach(readDat[j]) begin
              readDat[j] = (iAddr[$high(iAddr)-:$clog(WIDTH_DATA_IN/MULTI_DATA_WIDTH[i])] == j)? datTmp[j] : '0;
            end
          end
        end `gen_else begin : AddrType1_readDatGen
          always_comb begin
            foreach(readDat[j]) readDat[j] = (iAddr == j)? datTmp[j] : '0;
          end
        end
      end
      assign rsltTmp[i] = |readDat;
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

endmodule : ZionBasicCircuitLib_DatRead
`endif