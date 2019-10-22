
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_ClrRcDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Description :
//   DFF with reset(rst) and clear(iClr).
//   Reset is configurable:
//     - If RST_SYN==1, the DFF is synchronous reset, else it is asynchronous reset. Default value is 0.
//     - If RST_POS==1, the reset signal is active high, else it is active low. Default value is 0.
//     - If you instantiate a RcDff without indicating, the reset is asynchronous and active low.
//     - For Macro template, RST_SYN and RST_POS is assigned default by 'RST_SYN' and 'RST_POS'. So you use the 
//       Macro, you can explicitly indicate the parameter or implicit assign the value by define parameters named 
//       RST_SYN and RST_POS.
//   Both of the reset value and clear value are indicated by the INI_DATA.
//   Clear(iClr) is active high.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_ClrRcDff
`ifdef ZionBasicCircuitLib_ClrRcDff
  `__DefErr__(ZionBasicCircuitLib_ClrRcDff)
`else
  `define ZionBasicCircuitLib_ClrRcDff(UnitName,clk_MT,rst_MT,iClr_MT,iDat_MT,oDat_MT,INI_DATA_MT='0,RST_SYN_MT=RST_SYN,RST_POS_MT=RST_POS)\
ZionBasicCircuitLib_ClrRcDff  #(.WIDTH_IN($bits(iDat_MT)),    \
                                  .WIDTH_OUT($bits(oDat_MT)), \
                                  .INI_DATA(INI_DATA_MT),     \
                                  .RST_SYN(RST_SYN_MT),       \
                                  .RST_POS(RST_POS_MT))       \
                                UnitName(                     \
                                  .clk(clk_MT),               \
                                  .rst(rst_MT),               \
                                  .iClr(iClr_MT),             \
                                  .iDat(iDat_MT),             \
                                  .oDat(oDat_MT)              \
                                )
`endif

module ZionBasicCircuitLib_ClrRcDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  =  '0, //'0         // initial value for reset and clear
  RST_SYN   =   0, //RST_SYN    // reset type: 0-asynchronous, 1-synchronous
  RST_POS   =   0  //RST_POS    // reset edge: 0-negedge(active low), 1-posedge(active high)
)(
  input                        clk,rst,
  input                        iClr, // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  `gen_if(RST_SYN==1 && RST_POS==1) begin: Dff_SynPos
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end `gen_elif(RST_SYN==0 && RST_POS==1) begin: Dff_AsynPos
    always_ff@(posedge clk, posedge rst) // DFF with asynchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end `gen_elif(RST_SYN==1 && RST_POS==0) begin: Dff_SynNeg
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end `gen_elif(RST_SYN==0 && RST_POS==0) begin: Dff_AsynNeg
    always_ff@(posedge clk, negedge rst) // DFF with asynchronous reset, and the reset signal is active low.
      if(!rst)
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
    if((RST_SYN!=0) && (RST_SYN!=1)) begin
      $error("Parameter Error: RcDff RST_SYN set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if((RST_POS!=0) && (RST_POS!=1)) begin
      $error("Parameter Error: RcDff RST_POS set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_ClrRcDff
`endif

