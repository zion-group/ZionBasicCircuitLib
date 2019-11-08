
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxBin
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a binary selection data.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxBin
`ifdef ZionBasicCircuitLib_MuxBin
  `__DefErr__(ZionBasicCircuitLib_MuxBin)
`else
  `define ZionBasicCircuitLib_MuxBin(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxBin  #(.WIDTH_SEL($bits(iSel_MT)),              \
                                .WIDTH_IN($bits(iDat_MT)),             \
                                .WIDTH_OUT($bits(oDat_MT)))            \
                              UnitName(                                \
                                .iSel(iSel_MT),                        \
                                .iDat(iDat_MT),                        \
                                .oDat(oDat_MT)                         \
                              );
`endif

module ZionBasicCircuitLib_MuxBin
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel,
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  wire [WIDTH_IN/WIDTH_OUT-1:0][WIDTH_OUT-1:0] datTmp = iDat;
  assign oDat   = datTmp[iSel];

  // parameter check.
  initial begin
    if((WIDTH_IN%WIDTH_OUT)!=0) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of output data is not divisible by the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(WIDTH_OUT*(2**WIDTH_SEL) < WIDTH_IN) begin
    //if(WIDTH_IN*(2**WIDTH_SEL) < WIDTH_OUT) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

  // Assertions for iSel overflow.
  always_comb begin
   $display("WIDTH_OUT = %0d,WIDTH_SEL = %0d,WIDTH_IN = %0d",WIDTH_OUT,WIDTH_SEL,WIDTH_IN);
   $display("WIDTH_OUT*(2**WIDTH_SEL)= %0d",WIDTH_OUT*(2**WIDTH_SEL));
   
    // If iSel try to get a data that is beyond the input boundry, print an error.
    //assert(WIDTH_OUT*(2**iSel) > WIDTH_IN)
    assert(WIDTH_OUT*(2**WIDTH_SEL) == WIDTH_IN) else $error("Signal Error: iSel is overflow. There is no enough data for input.");
   
  end

endmodule: ZionBasicCircuitLib_MuxBin
`endif