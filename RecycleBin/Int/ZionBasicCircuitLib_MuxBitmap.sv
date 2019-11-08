
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxBitmap
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a bitmap selection data. It is a priority mux. the LSB has the highest priority.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxBitmap
`ifdef ZionBasicCircuitLib_MuxBitmap
  `__DefErr__(ZionBasicCircuitLib_MuxBitmap)
`else
  `define ZionBasicCircuitLib_MuxBitmap(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxBitmap  #(.WIDTH_SEL($bits(iSel_MT)),              \
                                  .WIDTH_IN($bits(iDat_MT)),              \
                                  .WIDTH_OUT($bits(oDat_MT)))             \
                                UnitName(                                 \
                                  .iSel(iSel_MT),                         \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_MuxBitmap
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel, 
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat 
);
  // Get onehot selection signal.
  logic [WIDTH_SEL-2:0] selPreviousFlg;
  logic [WIDTH_SEL-1:0] selOh;
  for(genvar i=1;i<WIDTH_SEL-1;i++) 
    assign selPreviousFlg[i] = |iSel[i:0];
    assign selOh[0] = iSel[0];
  for(genvar i=1;i<WIDTH_SEL;i++) 
    assign selOh[i] = ~selPreviousFlg[i-1] & iSel[i];

  logic [WIDTH_OUT/WIDTH_IN-1:0][WIDTH_IN-1:0] datTmp, rsltTmp;
  assign datTmp = iDat;
  always_comb begin
    //foreach(rsltTmp[i]) rsltTmp[i] = selOh? datTmp : '0;
    foreach(rsltTmp[i]) rsltTmp[i] = selOh[i]? datTmp : '0;

  end
  //assign oDat   = |rsltTmp;
  assign oDat   = rsltTmp;
  
  // parameter check.
  initial begin
    if(WIDTH_IN*WIDTH_SEL != WIDTH_OUT) begin
      $error("Parameter Error: MuxBitmap data width mismatch. The width of input data is equal to WIDTH_OUT * WIDTH_SEL !!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end


endmodule: ZionBasicCircuitLib_MuxBitmap
`endif