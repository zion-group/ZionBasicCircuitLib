
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Bin2Oh
// Author      : Wenheng Ma
// Date        : 2019-10-28
// Version     : 1.0
// Parameter   :
//   START - Indicate the starting point of the data. For example, if START is 1, iDat==0 will not have a 
//           Onehot signal. That is, the oDat[0] represents iDat==1. The default value is 0.
//   STEP  - Indicate the step between two onehot signals. The default value is 1.
// Description :
//   Binary to Onehot decoder.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-29 |  Yudi Gao  |     2.0     |   add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Bin2Oh
  `ifdef ZionBasicCircuitLib_Bin2Oh
    `__DefErr__(ZionBasicCircuitLib_Bin2Oh)
  `else
    `define ZionBasicCircuitLib_Bin2Oh(UnitName,iDat_MT,oDat_MT,START_MT=0,STEP_MT=1) \
ZionBasicCircuitLib_Bin2Oh #(.WIDTH_IN($bits(iDat_MT)),          \
                              .WIDTH_OUT($bits(oDat_MT)) ,       \
                              .START(START_MT),                  \
                              .STEP(STEP_MT))                    \
                           UnitName(                             \
                                  .iDat(iDat_MT),                \
                                  .oDat(oDat_MT)                 \
                              )  
  `endif

module ZionBasicCircuitLib_Bin2Oh
#(parameter 
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  START     =   0, //0          // start point of the onehot decode
  STEP      =   1  //1          // step of each increment
)(
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_comb begin
    // foreach([oDat``_i_]) 
    //   oDat``[_i_] = (iDat == (_i_*STEP + START));
    foreach(oDat[i])  oDat[i] = (iDat == (i*STEP + START));
  end

  // parameter check.
  initial begin
    if(START > 2**WIDTH_IN-2) begin
      $error("Parameter Error: Bin2Oh start point is larger than max input data!!,%1d,%1d,%1d,%1d",START,2**32,2**WIDTH_IN,2**WIDTH_IN-2);
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(((2**WIDTH_IN-START)/STEP) < WIDTH_OUT) begin
      $error("Parameter Error: Bin2Oh data width mismatch. The width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Bin2Oh
`endif