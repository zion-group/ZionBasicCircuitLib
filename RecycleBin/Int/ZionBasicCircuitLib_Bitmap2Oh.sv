
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Bitmap2Oh
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bitmap vector to Onehot decoder.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Bitmap2Oh
`ifdef ZionBasicCircuitLib_Bitmap2Oh
  `__DefErr__(ZionBasicCircuitLib_Bitmap2Oh)
`else
  `define ZionBasicCircuitLib_Bitmap2Oh(UnitName,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_Bitmap2Oh#(.WIDTH_IN($bits(iDat_MT)),         \
                               .WIDTH_OUT($bits(oDat_MT))         \
                              )                                   \
                              UnitName(                           \
                                       .iDat(iDat_MT),            \
                                       .oDat(oDat_MT)             \
                                       );
  `endif

module ZionBasicCircuitLib_Bitmap2Oh
#(parameter
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  logic [WIDTH_IN-2:0] previousFlg;
  for(genvar i=1;i<WIDTH_IN-1;i++) 
    assign previousFlg[i] = |iDat[i:0];
    assign oDat[0] = iDat[0];
  for(genvar i=1;i<WIDTH_OUT;i++) 
    assign oDat[i] = ~previousFlg[i-1] & iDat[i];
  // always_comb begin
  //   foreach(previousFlg[i]) previousFlg[i] = |iDat[i:0];
  //   oDat[0] = iDat[0];
  //   for(int j=1;j<WIDTH_OUT;j++) oDat[j] = ~previousFlg[j-1] & iDat[j];
  // end


  // parameter check.
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Error: Bitmap2Oh data width mismatch. The width of output data is not equal to the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Bitmap2Oh
`endif