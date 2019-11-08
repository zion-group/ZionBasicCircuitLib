 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_OnehotDefBin
// Author      : Wenheng Ma
// Date        : 2019-10-28
// Version     : 1.0
// Parameter   : 
//   START - Indicate the starting point of the data. For example, if START is 1, iDat==0 will not have a 
//           Onehot signal. That is, the oDat[0] represents iDat==1. The default value is 0.
//   STEP  - Indicate the step between two onehot signals. The default value is 1.
// Description :
//   Automatically define onehot signal according to iDat. 
//   The width of onehot data is inferred automatically according to iDat, and then implement the decode circuits.
//   This auto data type define macro is designed to use in modules.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-29 |  Yudi Gao  |     2.0     |   add testbench 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef Disable_ZionBasicCircuitLib_OnehotDefBin
  `ifdef ZionBasicCircuitLib_OnehotDefBin
    `__DefErr__(ZionBasicCircuitLib_OnehotDefBin)
  `else
    `define ZionBasicCircuitLib_OnehotDefBin(iDat_MT,ohDat,START_MT=0,STEP_MT=1) \
  logic [(($bits(iDat_MT)-START_MT)/STEP_MT):0] ohDat;                        \
  ZionBasicCircuitLib_Bin2Oh  #(.WIDTH_IN($bits(iDat_MT)),                    \
                                .WIDTH_OUT($bits(ohDat)),                     \
                                .START(START_MT),                             \
                                .STEP(STEP_MT))                               \
                              U_Bin2Oh_``ohDat(                               \
                                .iDat(iDat_MT),                               \
                                .oDat(ohDat)                                  \
                              )

  `endif
`endif