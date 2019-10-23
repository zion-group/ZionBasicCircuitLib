
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_EnRcDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Parameter   :
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
//   RST_CFG   - type of reset,meaning that whether asynchronous or synchronous reset and reset active low or high 
// Description :
//   DFF with reset(rst) and enable(iEn).
//   Reset is configurable:
//     - If RST_SYN==1, the DFF is synchronous reset, else it is asynchronous reset. Default value is 0.
//     - If RST_POS==1, the reset signal is active high, else it is active low. Default value is 0.
//     - If you instantiate a RcDff without indicating, the reset is asynchronous and active low.
//     - For Macro template, RST_SYN and RST_POS is assigned default by 'RST_SYN' and 'RST_POS'. So you use the 
//       Macro, you can explicitly indicate the parameter or implicit assign the value by define parameters named 
//       RST_SYN and RST_POS.
//   Reset value is indicated by the INI_DATA.
//   Enable(iEn) is active high.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 07-24-19 | Wenheng Ma |     1.0     |   Original Version
// 10-22-19 |  Yudi Gao  |     2.0     |   Change Reset Model
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_EnRcDff
`ifdef ZionBasicCircuitLib_EnRcDff
  `__DefErr__(ZionBasicCircuitLib_EnRcDff)
`else
  `define ZionBasicCircuitLib_EnRcDff(UnitName,clk_MT,rst_MT,iEn_MT,iDat_MT,oDat_MT,INI_DATA_MT='0,RST_CFG_MT=4)\
ZionBasicCircuitLib_EnRcDff #(.WIDTH_IN($bits(iDat_MT)),    \
                                .WIDTH_OUT($bits(oDat_MT)), \
                                .INI_DATA(INI_DATA_MT),     \
                                .RST_CFG(RST_CFG_MT))       \
                              UnitName(                     \
                                .clk(clk_MT),               \
                                .rst(rst_MT),               \
                                .iEn(iEn_MT),               \
                                .iDat(iDat_MT),             \
                                .oDat(oDat_MT)              \
                              )
`endif

module ZionBasicCircuitLib_EnRcDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  =  '0, //'0         // initial value for reset
  RST_CFG   =   0  //4          // reset type
)(
  input                        clk,rst,
  input                        iEn, // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  `gen_if(RST_CFG==0) begin: Dff_AsynNeg
    always_ff@(posedge clk, negedge rst) // DFF with asynchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end `gen_elif(RST_CFG==1) begin: Dff_AsynPos
    always_ff@(posedge clk, posedge rst) // DFF with asynchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end `gen_elif(RST_CFG==2) begin: Dff_SynNeg
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end`gen_elif(RST_CFG==3) begin: Dff_SynPos
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end `gen_elif(RST_CFG==4) begin: Dff_SynPos
    `ifdef FPGA_PROJECT
      always_ff@(posedge clk) // In FPGA project, the DFF is recommanded to work with synchronous reset.
    `elsif ASIC_PROJECT
      always_ff@(posedge clk, negedge rst) // In ASIC project, the DFF is recommanded to work with asynchronous reset.
    `else
      always_ff@(posedge clk, negedge rst) // DFF work with asynchronous reset by default.
    `endif
        `ifdef FPGA_PROJECT 
          if(rst)   // In FPGA project, the reset is recommanded to active high.
        `elsif ASIC_PROJECT 
          if(!rst)  // In FPGA project, the reset is recommanded to active low.
        `else
          if(!rst)  // By default, the reset is active low.
        `endif
            oDat <= INI_DATA;
          else begin
            if(iEn)
              oDat <= iDat;
          end
  end `gen_else begin: Dff_ParamErr
    $error("Parameter Error: RcDff RST_CFG set error!!");
  end
  //end
  // parameter check
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Error: Dff IO width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(!(RST_CFG inside {0,1,2,3,4})) begin
      $error("Parameter Error: RcDff RST_CFG set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_EnRcDff
`endif

