////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright(C) Zion Team. Open source License: MIT.
// ALL RIGHT RESERVED
// Filename : ZionBasicCircuitLib.vh
// Author   : Zion Team
// Date     : 2019-06-20
// Version  : 0.1
// Description :
//     This is a header file of basic circuit element library. 
// Modification History:
//   Date   |   Author    |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 |  Zion Team  |     0.1     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`define ZionBasicCircuitLib_MacroDef(ImportName, DefName)                 \
  `ifdef ImportName``DefName                                              \
    Macro Define Error: ImportName``DefName has already been defined!!    \
  `else                                                                   \
    `define ImportName``DefName `ZionBasicCircuitLib_``DefName            \
  `endif
`define ZionBasicCircuitLib_PackageDef(ImportName, DefName)               \
  `ifdef ImportName``DefName                                              \
    Macro Define Error: ImportName``DefName has already been defined!!    \
  `else                                                                   \
    `define ImportName``DefName ZionBasicCircuitLib_``DefName             \
  `endif
`define ZionBasicCircuitLib_InterfaceDef(ImportName, DefName)             \
  `ifdef ImportName``DefName                                              \
    Macro Define Error: ImportName``DefName has already been defined!!    \
  `else                                                                   \
    `define ImportName``DefName ZionBasicCircuitLib_``DefName             \
  `endif
`define ZionBasicCircuitLib_ModuleDef(ImportName, DefName)                \
  `ifdef ImportName``DefName                                              \
    Macro Define Error: ImportName``DefName has already been defined!!    \
  `else                                                                   \
    `define ImportName``DefName `ZionBasicCircuitLib_``DefName            \
  `endif
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`define Use_ZionBasicCircuitLib(ImportName)                 \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRanDff)   \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRapDff)   \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRsnDff)   \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRcDff)    \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRspDff)   \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRanDff)     \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRapDff)     \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRcDff)      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRsnDff)     \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRspDff)     \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Dff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnDff)         \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRanDff)      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRapDff)      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRcDff)       \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRsnDff)      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRspDff)      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RanDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RapDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RcDff)         \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RsnDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RspDff)          

`define Unuse_ZionBasicCircuitLib(ImportName) \
  `undef ImportName``ClrEnRanDff              \
  `undef ImportName``ClrEnRapDff              \
  `undef ImportName``ClrEnRsnDff              \
  `undef ImportName``ClrEnRcDff               \
  `undef ImportName``ClrEnRspDff              \
  `undef ImportName``ClrRanDff                \
  `undef ImportName``ClrRapDff                \
  `undef ImportName``ClrRcDff                 \
  `undef ImportName``ClrRsnDff                \
  `undef ImportName``ClrRspDff                \
  `undef ImportName``Dff                      \
  `undef ImportName``EnDff                    \
  `undef ImportName``EnRanDff                 \
  `undef ImportName``EnRapDff                 \
  `undef ImportName``EnRcDff                  \
  `undef ImportName``EnRsnDff                 \
  `undef ImportName``EnRspDff                 \
  `undef ImportName``RanDff                   \
  `undef ImportName``RapDff                   \
  `undef ImportName``RcDff                    \
  `undef ImportName``RsnDff                   \
  `undef ImportName``RspDff        
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







