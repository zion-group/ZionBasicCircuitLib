
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxOnehot
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a onehot selection data.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxOnehot
`ifdef ZionBasicCircuitLib_MuxOnehot
  `__DefErr__(ZionBasicCircuitLib_MuxOnehot)
`else
  `define ZionBasicCircuitLib_MuxOnehot(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxOnehot  #(.WIDTH_SEL($bits(iSel_MT)),               \
                                  .WIDTH_IN($bits(iDat_MT)),              \
                                  .WIDTH_OUT($bits(oDat_MT)))             \
                                UnitName(                                 \
                                  .iSel(iSel_MT),                         \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_MuxOnehot
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel,
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  //logic [WIDTH_OUT/WIDTH_IN-1:0][WIDTH_IN-1:0] datTmp, rsltTmp;
  logic [WIDTH_IN/WIDTH_OUT-1:0][WIDTH_OUT-1:0] datTmp, rsltTmp;

  //assign datTmp = iDat;
  always_comb begin
    foreach(datTmp[i]) datTmp[i] = iDat [i*WIDTH_OUT+:WIDTH_OUT];
    //foreach(rsltTmp[i]) rsltTmp[i] = iSel? datTmp : '0;
    foreach(rsltTmp[i]) rsltTmp[i] = iSel[i]? datTmp[i] : '0;
    foreach(oDat[i])    oDat   = |rsltTmp[i];
  end
 // assign oDat   = |rsltTmp;



  // parameter check.
  initial begin
    if(WIDTH_OUT*WIDTH_SEL != WIDTH_IN) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of input data is equal to WIDTH_OUT * WIDTH_SEL !!");
      $display("",);
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

  always_comb begin
    assert($onehot0(iSel)) 
    else $error("Signal Error: More than 1 selection signals are activated in iSel which only one signal could work.");
  end

endmodule: ZionBasicCircuitLib_MuxOnehot
`endif