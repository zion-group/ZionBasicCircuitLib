
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_RapDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 2.0
// Parameter   : 
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
// Description :
//   DFF with reset. Reset is asynchronous and active high. 
//   The Reset value is indicated by the INI_DATA. 
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-07-24 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-25 |  Meng Xu   |     2.0     |   Add Parameter
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_RapDff
`ifdef ZionBasicCircuitLib_RapDff
  `__DefErr__(ZionBasicCircuitLib_RapDff)
`else
  `define ZionBasicCircuitLib_RapDff(UnitName,clk_MT,rst_MT,iDat_MT,oDat_MT,INI_DATA_MT='0) \
ZionBasicCircuitLib_RapDff  #(.WIDTH_IN($bits(iDat_MT)),                                      \
                                .WIDTH_OUT($bits(oDat_MT)),                                   \
                                .INI_DATA(INI_DATA_MT))                                       \
                              UnitName(                                                       \
                                .clk(clk_MT),                                                 \
                                .rst(rst_MT),                                                 \
                                .iDat(iDat_MT),                                               \
                                .oDat(oDat_MT)                                                \
                              )
`endif

module ZionBasicCircuitLib_RapDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  = '0   //'0         // initial value for reset
)(
  input                        clk,rst,
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_ff@(posedge clk, posedge rst) begin
    if(rst)
      oDat <= INI_DATA;
    else begin
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

endmodule: ZionBasicCircuitLib_RapDff
`endif