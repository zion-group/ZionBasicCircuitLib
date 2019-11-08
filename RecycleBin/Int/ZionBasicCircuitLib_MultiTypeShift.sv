///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_MultiTypeShift
// Author      : Wenheng Ma
// Date        : 2019-11-06
// Version     : 2.0
// Parameter   : None
// Description :
//   Get absolute value.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-06 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MultiTypeShift
`ifdef ZionBasicCircuitLib_MultiTypeShift
  `__DefErr__(ZionBasicCircuitLib_MultiTypeShift)
`else
  `define ZionBasicCircuitLib_MultiTypeShift(UnitName,iSftR_MT,iSftA_MT,iSftL_MT,iDat_MT,iSftBit_MT,oDat_MT) \
ZionBasicCircuitLib_MultiTypeShift  #(.INPUT_DATA_WIDTH($bits(iDat_MT)),              \
                                      .SHIFT_BIT_WIDTH($bits(iSftBit_MT)),            \
                                      .OUTPUT_DATA_WIDTH($bits(oDat_MT)))             \
                                UnitName(                                             \
                                      .iSftR(iSftR_MT),                               \
                                      .iSftA(iSftA_MT),                               \
                                      .iSftL(iSftL_MT),                               \
                                      .iDat(iDat_MT),                                 \
                                      .iSftBit(iSftBit_MT),                           \
                                      .oDat(oDat_MT)                                  \
                                );
`endif
module ZionBasicCircuitLib_MultiTypeShift
#(INPUT_DATA_WIDTH  = 32,
  SHIFT_BIT_WIDTH   = 5 ,
  OUTPUT_DATA_WIDTH = 32
)(
  input                                iSftR  ,
  input                                iSftA  ,
  input                                iSftL  ,
  //input                                iSftR  ,
  input        [INPUT_DATA_WIDTH -1:0] iDat   ,
  input        [SHIFT_BIT_WIDTH  -1:0] iSftBit,
  output logic [OUTPUT_DATA_WIDTH-1:0] oDat
);

  logic [INPUT_DATA_WIDTH  -1:0] datReverse, sftDat, highBits;
  logic [INPUT_DATA_WIDTH*2-1:0] jointDat,sftRsltTmp, rsltReverse;
  always_comb begin
    datReverse  = {<<{iDat}};//reverse
    sftDat      =  ({INPUT_DATA_WIDTH{iSftR}} & iDat)
                  |({INPUT_DATA_WIDTH{iSftL}} & datReverse); 
    highBits    = {INPUT_DATA_WIDTH{iSftA & sftDat[$high(sftDat)]}};
    jointDat    = (iSftR)? {highBits,sftDat} :{sftDat,sftDat} ;
    sftRsltTmp  = (jointDat >> iSftBit);//INPUT_DATA_WIDTH*2'
    rsltReverse = {<<{sftRsltTmp}};
    oDat        =  ({INPUT_DATA_WIDTH{iSftR}} & sftRsltTmp) 
                  |({INPUT_DATA_WIDTH{iSftL}} & rsltReverse);
  end

  // parameter check.
  initial begin
    if(INPUT_DATA_WIDTH != OUTPUT_DATA_WIDTH) begin
      $error("Parameter Error: MultiTypeShift data width mismatch. The width of output data is not equal the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule
`endif
