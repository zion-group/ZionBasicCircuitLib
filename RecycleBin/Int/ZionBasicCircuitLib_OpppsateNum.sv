///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_OpppsateNum
// Author      : Yudi Gao
// Date        : 2019-11-4
// Version     : 1.0
// Parameter   : None
// Description :
//   Get absolute value.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-4  |  Yudi Gao  |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef Disable_ZionBasicCircuitLib_OpppsateNum
  `ifdef ZionBasicCircuitLib_OpppsateNum
    `__DefErr__(ZionBasicCircuitLib_OpppsateNum)
  `else
    `define ZionBasicCircuitLib_OpppsateNum(UnitName,iDat_MT,oDat_MT)    \
ZionBasicCircuitLib_OpppsateNum #(.WIDTH_IN($bits(iDat_MT)),             \
                                  .WIDTH_OUT($bits(oDat_MT)))            \
                                UnitName(                        \
                                         .iDat(iDat_MT),         \
                                         .oDat(oDat_MT)          \
                                         );
  `endif
module ZionBasicCircuitLib_OpppsateNum
#(parameter
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_" //$bits(oDat)// width of output data
)(
   input        [WIDTH_IN -1:0] iDat,
   output logic [WIDTH_OUT-1:0] oDat
);
  always_comb begin
    oDat = ~iDat + 1'b1;
  end

endmodule : ZionBasicCircuitLib_OpppsateNum
`endif

