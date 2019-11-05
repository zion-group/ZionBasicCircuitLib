///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_AddSub
// Author      : Yudi Gao
// Date        : 2019-11-4
// Version     : 1.0
// Parameter   : None
// Description :
//   Addition and subtraction computing. One adder is reused in both of the computation.
//   If 'addEn' is 1, calculate the addition. If 'subEn' is 1, calculate the subtraction. 
//   If 'addEn' and 'subEn' are both 0, result is 0. If they are both 0, result is undefined.
//   Both of 'addEn' and 'subEn' must be 1 bit signal,. Otherwise, the result is undefined.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-4  |  Yudi Gao  |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef Disable_ZionBasicCircuitLib_AddSub
  `ifdef ZionBasicCircuitLib_AddSub
    `__DefErr__(ZionBasicCircuitLib_AddSub)
  `else
    `define ZionBasicCircuitLib_AddSub(UnitName,addEn_MT,subEn_MT,datA_MT,datB_MT,oDat_MT)       \
ZionBasicCircuitLib_AddSub #(.WIDTH_IN_A($bits(datA_MT)),    \
                             .WIDTH_IN_B($bits(datA_MT)),    \
                             .WIDTH_OUT($bits(oDat_MT)))     \
                         UnitName(                           \
                                  .addEn(addEn_MT),          \
                                  .subEn(subEn_MT),          \
                                  .datA(datA_MT),            \
                                  .datB(datB_MT),            \
                                  .oDat(oDat_MT)             \
                                  );

  `endif
module ZionBasicCircuitLib_AddSub
#(parameter
   WIDTH_IN_A  = "_", //$bits(iDat)// width of input data A
   WIDTH_IN_B  = "_", //$bits(iDat)// width of input data B
   WIDTH_OUT   = "_" //$bits(oDat)// width of output data
)(
   input                          addEn,subEn,
   input        [WIDTH_IN_A -1:0] datA,
   input        [WIDTH_IN_B -1:0] datB,
   output logic [WIDTH_OUT  -1:0] oDat
);

  always_comb begin
    oDat = ({WIDTH_IN_A{addEn | subEn}} & datA) + (({WIDTH_IN_B{subEn}} & ~datB)|({WIDTH_IN_B{addEn}} & datB)+subEn);
    //    ({$bits(datA){addEn & subEn}} & datA) + (({$bits(datB){subEn}} & datB)|({$bits(datB){addEn}} & datB)) + subEn
  end

  // parameter check
  initial begin
    if(addEn & subEn) begin
      $error("Parameter Error: addEn can not be active while subEn is active!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule : ZionBasicCircuitLib_AddSub
`endif