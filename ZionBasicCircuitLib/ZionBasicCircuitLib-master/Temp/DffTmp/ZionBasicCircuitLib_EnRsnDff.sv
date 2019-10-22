
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_EnRsnDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Description :
//   DFF with reset(rst) and enable(iEn). 
//   Reset is synchronous and active low. 
//   Reset value is indicated by the INI_DATA.
//   Enable(iEn) is active high.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_EnRsnDff
`ifdef ZionBasicCircuitLib_EnRsnDff
  `__DefErr__(ZionBasicCircuitLib_EnRsnDff)
`else
  `define ZionBasicCircuitLib_EnRsnDff(UnitName,clk_MT,rst_MT,iEn_MT,iDat_MT,oDat_MT,INI_DATA_MT='0)\
ZionBasicCircuitLib_EnRsnDff  #(.WIDTH_IN($bits(iDat_MT)),    \
                                  .WIDTH_OUT($bits(oDat_MT)), \
                                  .INI_DATA(INI_DATA_MT))     \
                                UnitName(                     \
                                  .clk(clk_MT),               \
                                  .rst(rst_MT),               \
                                  .iEn(iEn_MT),               \
                                  .iDat(iDat_MT),             \
                                  .oDat(oDat_MT)              \
                                )
`endif

module ZionBasicCircuitLib_EnRsnDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  = '0   //'0         // initial value for reset 
)(
  input                        clk,rst,
  input                        iEn,  // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_ff@(posedge clk) begin
    if(!rst)
      oDat <= INI_DATA;
    else begin
      if(iEn)
        oDat <= iDat;
    end
  end

  // parameter check
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Error: Dff IO width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_EnRsnDff
`endif