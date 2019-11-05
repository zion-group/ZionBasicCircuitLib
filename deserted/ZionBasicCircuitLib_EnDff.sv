

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_EnDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 2.0
// Parameter   : 
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
// Description :
//   DFF with enable. Enable(iEn) is active high.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-07-24 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-25 | Qiao Cheng |     2.0     |   Add parameter
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_EnDff
`ifdef ZionBasicCircuitLib_EnDff
  `__DefErr__(ZionBasicCircuitLib_EnDff)
`else
  `define ZionBasicCircuitLib_EnDff(UnitName,clk_MT,iEn_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_EnDff #(.WIDTH_IN($bits(iDat_MT)),                        \
                              .WIDTH_OUT($bits(oDat_MT)))                     \
                            UnitName(                                         \
                              .clk(clk_MT),                                   \
                              .iEn(iEn_MT),                                   \
                              .iDat(iDat_MT),                                 \
                              .oDat(oDat_MT)                                  \
                            )
`endif

module ZionBasicCircuitLib_EnDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input                        clk,
  input                        iEn,  // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_ff@(posedge clk)
    if(iEn)
      oDat <= iDat;

  // parameter check
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Error: Dff IO width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_EnDff
`endif



