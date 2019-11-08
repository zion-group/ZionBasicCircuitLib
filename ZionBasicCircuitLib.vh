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
`define Use_ZionBasicCircuitLib(ImportName)                      \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Abs)                \
  `ZionBasicCircuitLib_ModuleDef(ImportName, AddSub)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Bin2Oh)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Bitmap2Oh)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, BitMaskGen)         \
  `ZionBasicCircuitLib_ModuleDef(ImportName, BitRead)            \
  `ZionBasicCircuitLib_ModuleDef(ImportName, BitWrite)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRanDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRapDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRsnDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRcDff)         \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrEnRspDff)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRanDff)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRapDff)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRcDff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRsnDff)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, ClrRspDff)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Dff)                \
  `ZionBasicCircuitLib_ModuleDef(ImportName, DatRead)            \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnDff)              \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRanDff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRapDff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRcDff)            \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRsnDff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, EnRspDff)           \
  `ZionBasicCircuitLib_ModuleDef(ImportName, OpppsateNum)        \
  `ZionBasicCircuitLib_ModuleDef(ImportName, MultiTypeShift)     \
  `ZionBasicCircuitLib_ModuleDef(ImportName, MuxBin)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, MuxBitmap)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, MuxOnehot)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, Oh2Bin)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, OnehotDef)          \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RanDff)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RapDff)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RcDff)              \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RsnDff)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, RspDff)             \
  `ZionBasicCircuitLib_ModuleDef(ImportName, WriteDatExtd)       \
  `ZionBasicCircuitLib_ModuleDef(ImportName, WriteMaskExtd)      \
  `ZionBasicCircuitLib_MacroDef(ImportName,  AbsM)               \
  `ZionBasicCircuitLib_MacroDef(ImportName,  AddSubM)            \
  `ZionBasicCircuitLib_MacroDef(ImportName,  ArithmShiftRightM)  \
  `ZionBasicCircuitLib_MacroDef(ImportName,  Bin2OhM)            \
  `ZionBasicCircuitLib_MacroDef(ImportName,  Bitmap2OhM)         \
  `ZionBasicCircuitLib_MacroDef(ImportName,  HighB)              \
  `ZionBasicCircuitLib_MacroDef(ImportName,  Oh2BinM)            \
  `ZionBasicCircuitLib_MacroDef(ImportName,  OnehotDefBitmap)    \
  `ZionBasicCircuitLib_MacroDef(ImportName,  OnehotDefBitmapM)   \
  `ZionBasicCircuitLib_MacroDef(ImportName,  OnehotDefM)         \
  `ZionBasicCircuitLib_MacroDef(ImportName,  OnehotDefBinM)      \
  `ZionBasicCircuitLib_MacroDef(ImportName,  OpppsateNumM)       \
  `ZionBasicCircuitLib_MacroDef(ImportName,  RotateLeftM)        \
  `ZionBasicCircuitLib_MacroDef(ImportName,  RotateRightM)       \
  `ZionBasicCircuitLib_MacroDef(ImportName,  SignExtdM)          \
  `ZionBasicCircuitLib_MacroDef(ImportName,  ZeroExtdM)


`define Unuse_ZionBasicCircuitLib(ImportName) \
  `undef ImportName``Abs                      \
  `undef ImportName``AbsM                     \
  `undef ImportName``AddSub                   \
  `undef ImportName``AddSubM                  \
  `undef ImportName``ArithmShiftRightM        \
  `undef ImportName``Bin2Oh                   \
  `undef ImportName``Bin2OhM                  \
  `undef ImportName``BitMaskGen               \
  `undef ImportName``Bitmap2Oh                \
  `undef ImportName``Bitmap2OhM               \
  `undef ImportName``BitRead                  \
  `undef ImportName``BitWrite                 \
  `undef ImportName``ClrEnRanDff              \
  `undef ImportName``ClrEnRapDff              \
  `undef ImportName``ClrEnRcDff               \
  `undef ImportName``ClrEnRsnDff              \
  `undef ImportName``ClrEnRspDff              \
  `undef ImportName``ClrRanDff                \
  `undef ImportName``ClrRapDff                \
  `undef ImportName``ClrRcDff                 \
  `undef ImportName``ClrRsnDff                \
  `undef ImportName``ClrRspDff                \
  `undef ImportName``DatRead                  \
  `undef ImportName``Dff                      \
  `undef ImportName``EnDff                    \
  `undef ImportName``EnRanDff                 \
  `undef ImportName``EnRapDff                 \
  `undef ImportName``EnRcDff                  \
  `undef ImportName``EnRsnDff                 \
  `undef ImportName``EnRspDff                 \
  `undef ImportName``HighB                    \
  `undef ImportName``MuxBin                   \
  `undef ImportName``MuxBitmap                \
  `undef ImportName``MultiTypeShift           \
  `undef ImportName``MuxOnehot                \
  `undef ImportName``Oh2Bin                   \
  `undef ImportName``Oh2BinM                  \
  `undef ImportName``OnehotDef                \
  `undef ImportName``OnehotDefM               \
  `undef ImportName``OnehotDefBinM            \
  `undef ImportName``OnehotDefBitmap          \
  `undef ImportName``OnehotDefBitmapM         \
  `undef ImportName``OpppsateNumM             \
  `undef ImportName``OpppsateNum              \
  `undef ImportName``RanDff                   \
  `undef ImportName``RapDff                   \
  `undef ImportName``RcDff                    \
  `undef ImportName``RotateLeftM              \
  `undef ImportName``RotateRightM             \
  `undef ImportName``RsnDff                   \
  `undef ImportName``RspDff                   \
  `undef ImportName``SignExtdM                \
  `undef ImportName``WriteDatExtd             \
  `undef ImportName``WriteMaskExtd            \
  `undef ImportName``ZeroExtdM
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







