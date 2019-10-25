
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_ClrRspDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Parameter   : 
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
// Description :
//   DFF with reset(rst) and clear(iClr). 
//   Reset is synchronous and active high. 
//   Both of the reset value and clear value are indicated by the INI_DATA.
//   Clear(iClr) is active high.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 07-24-19 | Wenheng Ma |     1.0     |   Original Version
// 10-25-19 |  Meng Xu   |     2.0     |   Add Parameter
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_ClrRspDff
`ifdef ZionBasicCircuitLib_ClrRspDff
  `__DefErr__(ZionBasicCircuitLib_ClrRspDff)
`else
  `define ZionBasicCircuitLib_ClrRspDff(UnitName,clk_MT,rst_MT,iClr_MT,iDat_MT,oDat_MT,INI_DATA_MT='0)\
ZionBasicCircuitLib_ClrRspDff #(.WIDTH_IN($bits(iDat_MT)),    \
                                  .WIDTH_OUT($bits(oDat_MT)), \
                                  .INI_DATA(INI_DATA_MT))     \
                                UnitName(                     \
                                  .clk(clk_MT),               \
                                  .rst(rst_MT),               \
                                  .iClr(iClr_MT),             \
                                  .iDat(iDat_MT),             \
                                  .oDat(oDat_MT)              \
                                )
`endif

module ZionBasicCircuitLib_ClrRspDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  = '0   //'0         // initial value for reset and clear
)(
  input                        clk,rst,
  input                        iClr, // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_ff@(posedge clk) begin
    if(rst)
      oDat <= INI_DATA;
    else begin
      if(iClr)
        oDat <= INI_DATA;
      else 
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

endmodule: ZionBasicCircuitLib_ClrRspDff
`endif