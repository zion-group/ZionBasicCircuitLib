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



`ifdef MACRO_TEMPLATE

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
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRcDff)

`define Unuse_ZionBasicCircuitLib(ImportName) \
  `undef ImportName``ClrEnRcDff               \

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`endif







