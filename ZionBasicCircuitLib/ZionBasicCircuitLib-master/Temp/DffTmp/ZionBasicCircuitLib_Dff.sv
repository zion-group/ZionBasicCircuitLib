///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Dff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Description :
//   DFF with no other port. Input data is stored each cycle.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Dff
`ifdef ZionBasicCircuitLib_Dff
  `__DefErr__(ZionBasicCircuitLib_Dff)
`else
  `define ZionBasicCircuitLib_Dff(UnitName,clk_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_Dff #(.WIDTH_IN($bits(iDat_MT)),                 \
                            .WIDTH_OUT($bits(oDat_MT)))              \
                          UnitName(                                  \
                            .clk(clk_MT),                            \
                            .iDat(iDat_MT),                          \
                            .oDat(oDat_MT)                           \
                          )
`endif

module ZionBasicCircuitLib_Dff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input                        clk,
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_ff@(posedge clk)
    oDat <= iDat;

  // parameter check
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Err: Dff IO width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Dff
`endif