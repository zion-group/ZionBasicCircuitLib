////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright(C) Zion Team. Open source License: MIT.
// ALL RIGHT RESERVED
// File name   : ZionBasicCircuitLib.sv
// Author      : Zion Team
// Date        : 2019-06-20
// Version     : 1.0
// Description :
//     This is a basic circuit element library. All packages, interfaces and modules is designed in this file.
// Modification History:
//   Date   |   Author    |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 |  Zion Team  |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//section: DFF +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  In this section, many kinds of DFFs are provided.
//  Name meaning:
//    Clr - DFF with clear port.
//    En  - DFF with enable prot.
//    Rc  - DFF with configurable reset. For RcDff, there are two parameters: RST_SYN and RST_POS.
//          If RST_SYN==1, the DFF is synchronous reset, else it is asynchronous reset. Default value is 0.
//          If RST_POS==1, the reset signal is active high, else it is active low. Default value is 0.
//          If you instantiate a RcDff without indicating, the reset is asynchronous and active low.
//    Ran - DFF with asynchronous reset, and the reset signal is active low.
//    Rap - DFF with asynchronous reset, and the reset signal is active high.
//    Rsn - DFF with  synchronous reset, and the reset signal is active low.
//    Rsp - DFF with  synchronous reset, and the reset signal is active high.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_ClrEnRcDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Parameter   :
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
//   RST_CFG   - type of reset,meaning that whether asynchronous or synchronous reset and reset active low or high 
// Description :
//   DFF with reset(rst), enable(iEn) and clear(iClr).
//   Reset is configurable:
//     TODO: new description
//   Both of the reset value and clear value are indicated by the INI_DATA.
//   Enable(iEn) and clear(iClr) are both active high.
// Modification History:
//   Date   |   Author   |   Version   |   Change Description
//======================================================================================================================
// 19-07-24 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_ClrEnRcDff
`ifdef ZionBasicCircuitLib_ClrEnRcDff
  `__DefErr__(ZionBasicCircuitLib_ClrEnRcDff)
`else
  `define ZionBasicCircuitLib_ClrEnRcDff(UnitName,clk_MT,rst_MT,iEn_MT,iClr_MT,iDat_MT,oDat_MT,INI_DATA_MT='0,RST_CFG_MT=4)\
ZionBasicCircuitLib_ClrEnRcDff  #(.WIDTH_IN($bits(iDat_MT)),    \
                                    .WIDTH_OUT($bits(oDat_MT)), \
                                    .INI_DATA(INI_DATA_MT),     \
                                    .RST_CFG(RST_CFG_MT))       \
                                  UnitName(                     \
                                    .clk(clk_MT),               \
                                    .rst(rst_MT),               \
                                    .iEn(iEn_MT),               \
                                    .iClr(iClr_MT),             \
                                    .iDat(iDat_MT),             \
                                    .oDat(oDat_MT)              \
                                  );
`endif

module ZionBasicCircuitLib_ClrEnRcDff
#(WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  INI_DATA  =  '0, //'0         // initial value for reset and clear
  RST_CFG   =   0  //4          // reset type
)(
  input                        clk,rst,
  input                        iEn,  // active high
  input                        iClr, // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  `ifdef RST_CFG_ASYN_LOW
    localparam RST_MACRO_CFG = 0;
  `elsif RST_CFG_ASYN_HIGH
    localparam RST_MACRO_CFG = 1;
  `elsif RST_CFG_SYN_LOW
    localparam RST_MACRO_CFG = 2;
  `elsif RST_CFG_SYN_HIGH
    localparam RST_MACRO_CFG = 3;
  `endif

  `gen_if((RST_CFG==0)|| (RST_MACRO_CFG==0) ) begin: Dff_AsynNeg//
    always_ff@(posedge clk, negedge rst) // DFF with asynchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else if(iEn)
          oDat <= iDat;
      end
  end `gen_elif((RST_CFG==1)|| (RST_MACRO_CFG==1) ) begin: Dff_AsynPos//
    always_ff@(posedge clk, posedge rst) // DFF with asynchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else if(iEn)
          oDat <= iDat;
      end
  end `gen_elif((RST_CFG==2)|| (RST_MACRO_CFG==2) ) begin: Dff_SynNeg//
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else if(iEn)
          oDat <= iDat;
      end
  end `gen_elif((RST_CFG==3)|| (RST_MACRO_CFG==3)) begin: Dff_SynPos// 
    always_ff@(posedge clk) begin// DFF with synchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iClr)
          oDat <= INI_DATA;
        else if(iEn)
          oDat <= iDat;
      end 
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
    if(!(RST_CFG inside {0,1,2,3,4})) begin
      $error("Parameter Error: RcDff RST_CFG set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_ClrEnRcDff
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_ClrRcDff
// Author      : Wenheng Ma
// Date        : 2019-07-24
// Version     : 1.0
// Parameter   :
//   WIDTH_IN  - width of input data,input data is range from 0 to 2**WIDTH_IN-1
//   WIDTH_OUT - width of output data,output data is range from 0 to 2**WIDTH_OUT-1
//   INI_DATA  - initial value for reset and clear;can be any value,if not injected, default value is '0
//   RST_CFG   - type of reset,meaning that whether asynchronous or synchronous reset and reset active low or high 
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
// 07-24-19 | Wenheng Ma |     1.0     |   Original Version
// 10-22-19 |  Yudi Gao  |     2.0     |   Change Reset Model
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_ClrRcDff
`ifdef ZionBasicCircuitLib_ClrRcDff
  `__DefErr__(ZionBasicCircuitLib_ClrRcDff)
`else
  `define ZionBasicCircuitLib_ClrRcDff(UnitName,clk_MT,rst_MT,iClr_MT,iDat_MT,oDat_MT,INI_DATA_MT='0,RST_SYN_MT=RST_SYN,RST_CFG_MT=4)\
ZionBasicCircuitLib_ClrRcDff  #(.WIDTH_IN($bits(iDat_MT)),    \
                                  .WIDTH_OUT($bits(oDat_MT)), \
                                  .INI_DATA(INI_DATA_MT),     \
                                  .RST_CFG(RST_CFG_MT))       \
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
  RST_CFG   =   0  //4          // reset type
)(
  input                        clk,rst,
  input                        iClr, // active high
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);
 

  `ifdef RST_CFG_ASYN_LOW
    localparam RST_MACRO_CFG = 0;
  `elsif RST_CFG_ASYN_HIGH
    localparam RST_MACRO_CFG = 1;
  `elsif RST_CFG_SYN_LOW
    localparam RST_MACRO_CFG = 2;
  `elsif RST_CFG_SYN_HIGH
    localparam RST_MACRO_CFG = 3;
  `endif
 

 `gen_if((RST_CFG==0) || (RST_MACRO_CFG==0)) begin: Dff_AsynNeg
    always_ff@(posedge clk, negedge rst) // DFF with asynchronous reset, and the reset signal is active low.
      if(!rst) begin
        oDat <= INI_DATA;
      end else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end 
  
  
  `gen_elif((RST_CFG==1)|| (RST_MACRO_CFG==1)) begin: Dff_AsynPos
    always_ff@(posedge clk, posedge rst) // DFF with asynchronous reset, and the reset signal is active high.
      if(rst) begin
        oDat <= INI_DATA;
      end else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end 

  `gen_elif((RST_CFG==2)|| (RST_MACRO_CFG==2)) begin: Dff_SynNeg
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active low.
      if(!rst) begin
        oDat <= INI_DATA;
      end else begin
        if(iClr)
          oDat <= INI_DATA;
        else
          oDat <= iDat;
      end
  end 

  `gen_elif((RST_CFG==3)|| (RST_MACRO_CFG==3)) begin: Dff_SynPos
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active high.
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
    if(!(RST_CFG inside {0,1,2,3,4})) begin
      $error("Parameter Error: RcDff RST_CFG set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_ClrRcDff
`endif

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

  `ifdef RST_CFG_ASYN_LOW
    localparam RST_MACRO_CFG = 0;
  `elsif RST_CFG_ASYN_HIGH
    localparam RST_MACRO_CFG = 1;
  `elsif RST_CFG_SYN_LOW
    localparam RST_MACRO_CFG = 2;
  `elsif RST_CFG_SYN_HIGH
    localparam RST_MACRO_CFG = 3;
  `endif

  `gen_if((RST_CFG==0) || (RST_MACRO_CFG==0)) begin: Dff_AsynNeg
    always_ff@(posedge clk, negedge rst) // DFF with asynchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end `gen_elif((RST_CFG==1) || (RST_MACRO_CFG==1)) begin: Dff_AsynPos
    always_ff@(posedge clk, posedge rst) // DFF with asynchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end `gen_elif((RST_CFG==2) || (RST_MACRO_CFG==2)) begin: Dff_SynNeg
    always_ff@(posedge clk) // DFF with  synchronous reset, and the reset signal is active low.
      if(!rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
  end`gen_elif((RST_CFG==3) || (RST_MACRO_CFG==3)) begin: Dff_SynPos
    always_ff@(posedge clk) begin // DFF with  synchronous reset, and the reset signal is active high.
      if(rst)
        oDat <= INI_DATA;
      else begin
        if(iEn)
          oDat <= iDat;
      end
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
    if(!(RST_CFG inside {0,1,2,3,4})) begin
      $error("Parameter Error: RcDff RST_CFG set error!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_EnRcDff
`endif
//endsection: RcDFF +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//section: Int +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  In this section, many kinds of Int instruction are provided.
//  Name meaning:
//    Abs            - Calculate the absolute value of a number
//    AddSub         - Use an adder for the addition
//    Bin2Oh         - Binary to Onehot decoder.
//    Oh2Bin         - Onehot to Binary decoder.
//    Bitmap2Oh      - Bitmap vector to Onehot decoder.
//    MuxBin         - Bit mux according to a binary selection data.
//    MultiTypeShift - Get absolute value.
//    MuxBitmap      - Bit mux according to a bitmap selection data. It is a priority mux. the LSB has the highest priority.
//    MuxOnehot      - Bit mux according to a onehot selection data. 
//    OnehotDef      - Automatically define onehot signal according to iDat. 
//                     The width of onehot data is inferred automatically according to iDat, and then implement the decode circuits.
//                     This auto data type define macro is designed to use in modules.
//    OpppsateNum    - Calculate a complement of a number
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_Abs
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

`ifndef Disable_ZionBasicCircuitLib_Abs
  `ifdef ZionBasicCircuitLib_Abs
    `__DefErr__(ZionBasicCircuitLib_Abs)
  `else
    `define ZionBasicCircuitLib_Abs(UnitName,iDat_MT,oDat_MT)       \
ZionBasicCircuitLib_Abs #(.WIDTH_IN($bits(iDat_MT)),        \
                          .WIDTH_OUT($bits(oDat_MT)))       \
                         UnitName(                          \
                                  .iDat(iDat_MT),           \
                                  .oDat(oDat_MT)            \
                                  );

  `endif
module ZionBasicCircuitLib_Abs
#(parameter
   WIDTH_IN  = "_", //$bits(iDat)// width of input data
   WIDTH_OUT = "_" //$bits(oDat)// width of output data
)(
   input        [WIDTH_IN -1:0] iDat,
   output logic [WIDTH_OUT-1:0] oDat
);

  always_comb begin
    oDat = (iDat[$high(iDat)])? (~iDat+1'b1) : iDat;
  end

endmodule : ZionBasicCircuitLib_Abs
`endif

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Bin2Oh
// Author      : Wenheng Ma
// Date        : 2019-10-28
// Version     : 1.0
// Parameter   :
//   START - Indicate the starting point of the data. For example, if START is 1, iDat==0 will not have a 
//           Onehot signal. That is, the oDat[0] represents iDat==1. The default value is 0.
//   STEP  - Indicate the step between two onehot signals. The default value is 1.
// Description :
//   Binary to Onehot decoder.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-29 |  Yudi Gao  |     2.0     |   add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Bin2Oh
  `ifdef ZionBasicCircuitLib_Bin2Oh
    `__DefErr__(ZionBasicCircuitLib_Bin2Oh)
  `else
    `define ZionBasicCircuitLib_Bin2Oh(UnitName,iDat_MT,oDat_MT,START_MT=0,STEP_MT=1) \
ZionBasicCircuitLib_Bin2Oh #(.WIDTH_IN($bits(iDat_MT)),          \
                              .WIDTH_OUT($bits(oDat_MT)) ,       \
                              .START(START_MT),                  \
                              .STEP(STEP_MT))                    \
                           UnitName(                             \
                                  .iDat(iDat_MT),                \
                                  .oDat(oDat_MT)                 \
                              )  
  `endif

module ZionBasicCircuitLib_Bin2Oh
#(parameter 
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  START     =   0, //0          // start point of the onehot decode
  STEP      =   1  //1          // step of each increment
)(
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  always_comb begin
    foreach(oDat[i]) oDat[i] = (iDat == (i*STEP + START));
  end

  // parameter check.
  initial begin
    if(START > 2**WIDTH_IN-2) begin
      $error("Parameter Error: Bin2Oh start point is larger than max input data!!,%1d,%1d,%1d,%1d",START,2**32,2**WIDTH_IN,2**WIDTH_IN-2);
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(((WIDTH_IN-START)/STEP) < WIDTH_OUT) begin
      $error("Parameter Error: Bin2Oh data width mismatch. The width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Bin2Oh
`endif
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Oh2Bin
// Author      : Yudi Gao
// Date        : 2019-11-2
// Version     : 1.0
// Parameter   :
//   START - Indicate the starting point of the data. For example, if START is 1, iDat==0 will not have a 
//           Onehot signal. That is, the oDat[0] represents iDat==1. The default value is 0.
//   STEP  - Indicate the step between two onehot signals. The default value is 1.
// Description :
//   Onehot to Binary decoder.
// Modification History:
//    Date    |   Author   |   Version   |   CiDate Description
//======================================================================================================================
// 2019-10-28 | Yudi Gao |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Oh2Bin
  `ifdef ZionBasicCircuitLib_Oh2Bin
    `__DefErr__(ZionBasicCircuitLib_Oh2Bin)
  `else
    `define ZionBasicCircuitLib_Oh2Bin(UnitName,iDat_MT,oDat_MT,START_MT=0,STEP_MT=1) \
ZionBasicCircuitLib_Oh2Bin #(.WIDTH_IN($bits(iDat_MT)),          \
                              .WIDTH_OUT($bits(oDat_MT)) ,       \
                              .START(START_MT),                  \
                              .STEP(STEP_MT))                    \
                           UnitName(                             \
                                  .iDat(iDat_MT),                \
                                  .oDat(oDat_MT)                 \
                              )  
  `endif

module ZionBasicCircuitLib_Oh2Bin
#(parameter 
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_", //$bits(oDat)// width of output data
  START     =   0, //0          // start point of the onehot decode
  STEP      =   1  //1          // step of each increment
)(
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
); 
  logic                    flag;
  logic [2*(WIDTH_IN-1):0] temp;
  logic [   WIDTH_OUT-1:0] addr [2*(WIDTH_IN-1):0];
  genvar i;
  for(i=0; i<WIDTH_IN;i++) begin
    assign temp[i] = iDat[i];
    assign addr[i] = i;
  end
  genvar j;
  for(j=0;j<WIDTH_IN-1;j++) begin
     assign temp[WIDTH_IN+j] = temp[2*j] | temp[2*j+1];
     assign addr[WIDTH_IN+j] = temp[2*j] ? addr[2*j] : temp[2*j+1] ? addr[2*j+1] : addr[2*j];
  end
  assign flag = temp[2*(WIDTH_IN-1)] ? 1 : 0;
  assign oDat = flag ? addr[2*(WIDTH_IN-1)] : '0;
  initial begin
     $display("flag = %b, oDat = %b\n", flag, oDat);
  end
  // parameter check.
  initial begin
    if(START > 2**WIDTH_OUT-2) begin
      $error("Parameter Error: Oh2Bin start point is larger than max input data!!,%1d,%1d,%1d,%1d",START,2**32,2**WIDTH_IN,2**WIDTH_IN-2);
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(((WIDTH_OUT-START)/STEP) > WIDTH_IN) begin
      $error("Parameter Error: Oh2Bin data width mismatch. The width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Oh2Bin
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_Bitmap2Oh
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bitmap vector to Onehot decoder.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_Bitmap2Oh
`ifdef ZionBasicCircuitLib_Bitmap2Oh
  `__DefErr__(ZionBasicCircuitLib_Bitmap2Oh)
`else
  `define ZionBasicCircuitLib_Bitmap2Oh(UnitName,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_Bitmap2Oh#(.WIDTH_IN($bits(iDat_MT)),         \
                               .WIDTH_OUT($bits(oDat_MT))         \
                              )                                   \
                              UnitName(                           \
                                       .iDat(iDat_MT),            \
                                       .oDat(oDat_MT)             \
                                       );
  `endif

module ZionBasicCircuitLib_Bitmap2Oh
#(parameter
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input        [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  logic [WIDTH_IN-2:0] previousFlg;
  for(genvar i=0;i<WIDTH_IN-1;i++) 
    assign previousFlg[i] = |iDat[i:0];
    assign oDat[0] = iDat[0];
  for(genvar i=1;i<WIDTH_OUT;i++) 
    assign oDat[i] = ~previousFlg[i-1] & iDat[i];
  // parameter check.
  initial begin
    if(WIDTH_IN != WIDTH_OUT) begin
      $error("Parameter Error: Bitmap2Oh data width mismatch. The width of output data is not equal to the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule: ZionBasicCircuitLib_Bitmap2Oh
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxBin
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a binary selection data.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxBin
`ifdef ZionBasicCircuitLib_MuxBin
  `__DefErr__(ZionBasicCircuitLib_MuxBin)
`else
  `define ZionBasicCircuitLib_MuxBin(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxBin  #(.WIDTH_SEL($bits(iSel_MT)),              \
                                .WIDTH_IN($bits(iDat_MT)),             \
                                .WIDTH_OUT($bits(oDat_MT)))            \
                              UnitName(                                \
                                .iSel(iSel_MT),                        \
                                .iDat(iDat_MT),                        \
                                .oDat(oDat_MT)                         \
                              );
`endif

module ZionBasicCircuitLib_MuxBin
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel,
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);

  wire [WIDTH_IN/WIDTH_OUT-1:0][WIDTH_OUT-1:0] datTmp = iDat;
  assign oDat   = datTmp[iSel];

  // parameter check.
  initial begin
    if((WIDTH_IN%WIDTH_OUT)!=0) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of output data is not divisible by the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if(WIDTH_OUT*(2**WIDTH_SEL) < WIDTH_IN) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

  // Assertions for iSel overflow.
  always_comb begin
   $display("WIDTH_OUT = %0d,WIDTH_SEL = %0d,WIDTH_IN = %0d",WIDTH_OUT,WIDTH_SEL,WIDTH_IN);
   $display("WIDTH_OUT*(2**WIDTH_SEL)= %0d",WIDTH_OUT*(2**WIDTH_SEL));
   
    // If iSel try to get a data that is beyond the input boundry, print an error.
    assert(WIDTH_OUT*(2**WIDTH_SEL) == WIDTH_IN) else $error("Signal Error: iSel is overflow. There is no enough data for input.");
   
  end

endmodule: ZionBasicCircuitLib_MuxBin
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxBitmap
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a bitmap selection data. It is a priority mux. the LSB has the highest priority.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxBitmap
`ifdef ZionBasicCircuitLib_MuxBitmap
  `__DefErr__(ZionBasicCircuitLib_MuxBitmap)
`else
  `define ZionBasicCircuitLib_MuxBitmap(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxBitmap  #(.WIDTH_SEL($bits(iSel_MT)),              \
                                  .WIDTH_IN($bits(iDat_MT)),              \
                                  .WIDTH_OUT($bits(oDat_MT)))             \
                                UnitName(                                 \
                                  .iSel(iSel_MT),                         \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_MuxBitmap
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel, 
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat 
);
  // Get onehot selection signal.
  logic [WIDTH_SEL-2:0] selPreviousFlg;
  logic [WIDTH_SEL-1:0] selOh;
  for(genvar i=1;i<WIDTH_SEL-1;i++) 
    assign selPreviousFlg[i] = |iSel[i:0];
    assign selOh[0] = iSel[0];
  for(genvar i=1;i<WIDTH_SEL;i++) 
    assign selOh[i] = ~selPreviousFlg[i-1] & iSel[i];

  logic [WIDTH_OUT/WIDTH_IN-1:0][WIDTH_IN-1:0] datTmp, rsltTmp;
  assign datTmp = iDat;
  always_comb begin
    foreach(rsltTmp[i]) rsltTmp[i] = selOh[i]? datTmp : '0;
  end
  assign oDat   = rsltTmp;
  // parameter check.
  initial begin
    if(WIDTH_IN*WIDTH_SEL != WIDTH_OUT) begin
      $error("Parameter Error: MuxBitmap data width mismatch. The width of input data is equal to WIDTH_OUT * WIDTH_SEL !!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end
endmodule: ZionBasicCircuitLib_MuxBitmap
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_MuxOnehot
// Author      : Wenheng Ma
// Date        : 2019-11-04
// Version     : 2.0
// Parameter   :
//   WIDTH_SEL - Width of selection data(iSel). The selection data is a binary data.
//   WIDTH_IN  - Width of input data.
//   WIDTH_OUT - Width of output data.
// Description :
//   Bit mux according to a onehot selection data.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-04 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MuxOnehot
`ifdef ZionBasicCircuitLib_MuxOnehot
  `__DefErr__(ZionBasicCircuitLib_MuxOnehot)
`else
  `define ZionBasicCircuitLib_MuxOnehot(UnitName,iSel_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_MuxOnehot  #(.WIDTH_SEL($bits(iSel_MT)),               \
                                  .WIDTH_IN($bits(iDat_MT)),              \
                                  .WIDTH_OUT($bits(oDat_MT)))             \
                                UnitName(                                 \
                                  .iSel(iSel_MT),                         \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_MuxOnehot
#(WIDTH_SEL = "_", //$bits(iSel)// width of selection data
  WIDTH_IN  = "_", //$bits(iDat)// width of input data
  WIDTH_OUT = "_"  //$bits(oDat)// width of output data
)(
  input  logic [WIDTH_SEL-1:0] iSel,
  input  logic [WIDTH_IN -1:0] iDat,
  output logic [WIDTH_OUT-1:0] oDat
);
  logic [WIDTH_IN/WIDTH_OUT-1:0][WIDTH_OUT-1:0] datTmp, rsltTmp;
  logic [WIDTH_SEL-1:0] oDatTmp;
  always_comb begin
    foreach(datTmp[i]) datTmp[i] = iDat [i*WIDTH_OUT+:WIDTH_OUT];
    foreach(rsltTmp[i]) rsltTmp[i] = iSel[i]? datTmp[i] : '0;
      for (int m=0;m<WIDTH_OUT;m++) begin 
    for(int j=0;j<WIDTH_SEL;j++) begin 
      oDatTmp[j] = rsltTmp[j][m];
    end
      oDat[m] = |oDatTmp;
    end 
  end

  // parameter check.
  initial begin
    if(WIDTH_OUT*WIDTH_SEL != WIDTH_IN) begin
      $error("Parameter Error: MuxBin data width mismatch. The width of input data is equal to WIDTH_OUT * WIDTH_SEL !!");
      $display("WIDTH_OUT=%0d,WIDTH_SEL=%0d,WIDTH_IN=%0d",WIDTH_OUT,WIDTH_SEL,WIDTH_IN);
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

  always_comb begin
    assert($onehot0(iSel)) 
    else $error("Signal Error: More than 1 selection signals are activated in iSel which only one signal could work.");
  end

endmodule: ZionBasicCircuitLib_MuxOnehot
`endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_MultiTypeShift
// Author      : Wenheng Ma
// Date        : 2019-11-06
// Version     : 2.0
// Parameter   : None
// Description :
//   Get absolute value.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-06 | Wenheng Ma |     1.0     |   Original Version
// 2019-11-06 |  Yudi Gao  |     2.0     |   Add testbench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_MultiTypeShift
`ifdef ZionBasicCircuitLib_MultiTypeShift
  `__DefErr__(ZionBasicCircuitLib_MultiTypeShift)
`else
  `define ZionBasicCircuitLib_MultiTypeShift(UnitName,iSftR_MT,iSftA_MT,iSftL_MT,iSftC_MT,iDat_MT,iSftBit_MT,oDat_MT) \
ZionBasicCircuitLib_MultiTypeShift  #(.INPUT_DATA_WIDTH($bits(iDat_MT)),              \
                                      .SHIFT_BIT_WIDTH($bits(iSftBit_MT)),            \
                                      .OUTPUT_DATA_WIDTH($bits(oDat_MT)))             \
                                UnitName(                                             \
                                      .iSftR(iSftR_MT),                               \
                                      .iSftA(iSftA_MT),                               \
                                      .iSftL(iSftL_MT),                               \
                                      .iSftC(iSftC_MT),                               \
                                      .iDat(iDat_MT),                                 \
                                      .iSftBit(iSftBit_MT),                           \
                                      .oDat(oDat_MT)                                  \
                                );
`endif
module ZionBasicCircuitLib_MultiTypeShift
#(INPUT_DATA_WIDTH  = "_",
  SHIFT_BIT_WIDTH   = "_",
  OUTPUT_DATA_WIDTH = "_"
)(
  input                                iSftR  ,
  input                                iSftA  ,
  input                                iSftL  ,
  input                                iSftC  ,
  input        [INPUT_DATA_WIDTH -1:0] iDat   ,
  input        [SHIFT_BIT_WIDTH  -1:0] iSftBit,
  output logic [OUTPUT_DATA_WIDTH-1:0] oDat
);

  logic [INPUT_DATA_WIDTH  -1:0] datReverse, sftDat, highBits,lowBits;
  logic [INPUT_DATA_WIDTH*2-1:0] jointDat,sftRsltTmp, rsltReverse;
  always_comb begin
    datReverse  = {<<{iDat}};//reverse
    sftDat      =  ({INPUT_DATA_WIDTH{iSftR}} & iDat)
                  |({INPUT_DATA_WIDTH{iSftL}} & datReverse); 
    highBits    = {INPUT_DATA_WIDTH{iSftA & sftDat[$high(sftDat)]}};
    lowBits     = {INPUT_DATA_WIDTH{iSftA & sftDat[$low(sftDat)]}};//add
    jointDat    = (iSftR & ~iSftC)? {highBits,sftDat} :
                  (iSftR &  iSftC)? {sftDat,sftDat}   :
                  (iSftL &  iSftC)? {sftDat,sftDat}  :
                  (iSftL &  iSftA)? {sftDat,datReverse}  :{sftDat,sftDat};
    sftRsltTmp  = (jointDat >> iSftBit);//INPUT_DATA_WIDTH*2'
    rsltReverse = {<<{sftRsltTmp}};
    oDat        =  ({INPUT_DATA_WIDTH{iSftR}} & sftRsltTmp) 
                  |({INPUT_DATA_WIDTH{iSftL & ~iSftA & ~iSftC}} & rsltReverse)
                  |({INPUT_DATA_WIDTH{iSftL &  iSftA}} & rsltReverse[INPUT_DATA_WIDTH*2-1:INPUT_DATA_WIDTH])
                  |({INPUT_DATA_WIDTH{iSftL &  iSftC}} & rsltReverse[INPUT_DATA_WIDTH/2*3-:INPUT_DATA_WIDTH]);
                  
  end

  // parameter check.
  initial begin
    if(INPUT_DATA_WIDTH != OUTPUT_DATA_WIDTH) begin
      $error("Parameter Error: MultiTypeShift data width mismatch. The width of output data is not equal the width of input data!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Macro name  : ZionBasicCircuitLib_OnehotDef
// Author      : Wenheng Ma
// Date        : 2019-10-28
// Version     : 1.0
// Parameter   : 
//   START - Indicate the starting point of the data. For example, if START is 1, iDat==0 will not have a 
//           Onehot signal. That is, the oDat[0] represents iDat==1. The default value is 0.
//   STEP  - Indicate the step between two onehot signals. The default value is 1.
// Description :
//   Automatically define onehot signal according to iDat. 
//   The width of onehot data is inferred automatically according to iDat, and then implement the decode circuits.
//   This auto data type define macro is designed to use in modules.
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-29 |  Yudi Gao  |     2.0     |   add testbench 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef Disable_ZionBasicCircuitLib_OnehotDef
  `ifdef ZionBasicCircuitLib_OnehotDef
    `__DefErr__(ZionBasicCircuitLib_OnehotDef)
  `else
    `define ZionBasicCircuitLib_OnehotDef(iDat_MT,ohDat,START_MT=0,STEP_MT=1) \
  logic [(($bits(iDat_MT)-START_MT)/STEP_MT):0] ohDat;                        \
  ZionBasicCircuitLib_Bin2Oh  #(.WIDTH_IN($bits(iDat_MT)),                    \
                                .WIDTH_OUT($bits(ohDat)),                     \
                                .START(START_MT),                             \
                                .STEP(STEP_MT))                               \
                              U_Bin2Oh_``ohDat(                               \
                                .iDat(iDat_MT),                               \
                                .oDat(ohDat)                                  \
                              )

  `endif
`endif
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
//endsection: Int +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//section: Memory +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  In this section, many kinds of Memory instruction are provided.
//  Name meaning:
//    BitMaskGen   - Generate mask of a number
//    BitRead      - Read operations under combinatorial logic
//    BitWrite     - Write operations under sequential logic
//    DatRead      - Read data
//    WriteDatExtd - Write data
//    WriteMaskExtd- Generate write mask
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name : ZionBasicCircuitLib_BitMaskGen
// Author      : Wenheng Ma 
// Date        : 2019-10-28
// Version     : 2.0
// Parameter   :
//  WIDTH_ADDR - width of input  address
//  WIDTH_OUT  - width of output data
//  WIDTH_BIT  - 
//  MASK_FLAG  - value can be 0(active low) or 1(active high)
// Description :
//   Generate mask of a number
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-31 |  Yudi Gao  |     2.0     |   Add TestBench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_BitMaskGen
`ifdef ZionBasicCircuitLib_BitMaskGen
  `__DefErr__(ZionBasicCircuitLib_BitMaskGen)
`else
  `define ZionBasicCircuitLib_BitMaskGen(UnitName,iAddr_MT,oDat_MT,WIDTH_BIT_MT,MASK_FLAG_MT=0) \
ZionBasicCircuitLib_BitMaskGen  #(.WIDTH_ADDR($bits(iAddr_MT)),                              \
                                    .WIDTH_OUT($bits(oDat_MT)),                              \
                                    .WIDTH_BIT(WIDTH_BIT_MT),                                \
                                    .MASK_FLAG(MASK_FLAG_MT))                                \
                                  UnitName(                                                  \
                                    .iAddr(iAddr_MT),                                        \
                                    .oDat(oDat_MT)                                           \
                                  )
`endif

module ZionBasicCircuitLib_BitMaskGen
#(WIDTH_ADDR = "_", //$bits(iAddr)// width of input address
  WIDTH_OUT  = "_", //$bits(oDat)// width of output data
  WIDTH_BIT  = "_",
  MASK_FLAG  =  0 
)(
  input        [WIDTH_ADDR-1:0] iAddr,
  output logic [WIDTH_OUT -1:0] oDat
);

  logic [WIDTH_OUT/WIDTH_BIT-1:0][WIDTH_BIT-1:0] datTmp;

  `gen_if(MASK_FLAG==0) begin
    always_comb begin
      foreach(datTmp[i]) datTmp[i] = (iAddr == i)? '0 : '1;
    end
  end `gen_elif(MASK_FLAG==1) begin
    always_comb begin
      foreach(datTmp[i]) datTmp[i] = (iAddr == i)? '1 : '0;
    end
  end

  assign oDat = datTmp;

  // parameter check.
  initial begin
    if((WIDTH_OUT % WIDTH_BIT)!=0) begin
      $error("Parameter Error: Width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end 
    if(WIDTH_OUT > (2**WIDTH_ADDR)*WIDTH_BIT) begin
      $error("Parameter Error: Width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
    if((MASK_FLAG!=0) && (MASK_FLAG!=1)) begin
      $error("Parameter Error: MASK_FLAG must be 0 or 1!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule : ZionBasicCircuitLib_BitMaskGen
`endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name  : ZionBasicCircuitLib_BitRead
// Author       : Wenheng Ma
// Date         : 2019-10-28
// Version      : 2.0
// Parameter    :
//WIDTH_ADDR    -  width of input  address
//WIDTH_DATA_IN -  width of input  data
//WIDTH_DATA_OUT-  width of output data
// Description  :
//   Read operations under combinatorial logic
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-31 |  Yudi Gao  |     2.0     |   Add TestBench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_BitRead
`ifdef ZionBasicCircuitLib_BitRead
  `__DefErr__(ZionBasicCircuitLib_BitRead)
`else
  `define ZionBasicCircuitLib_BitRead(UnitName,iAddr_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_BitRead #(.WIDTH_ADDR($bits(iAddr_MT)),              \
                                .WIDTH_DATA_IN($bits(iDat_MT)),          \
                                .WIDTH_DATA_OUT($bits(oDat_MT)))         \
                              UnitName(                                  \
                                .iAddr(iAddr_MT),                        \
                                .iDat(iDat_MT),                          \
                                .oDat(oDat_MT)                           \
                              )
`endif

module ZionBasicCircuitLib_BitRead
#(WIDTH_ADDR     = "_", //$bits(iAddr)// width of input  addr
  WIDTH_DATA_IN  = "_", //$bits(iDat) // width of input  data
  WIDTH_DATA_OUT = "_"  //$bits(oDat) // width of output data
)(
  input        [WIDTH_ADDR    -1:0] iAddr,
  input        [WIDTH_DATA_IN -1:0] iDat,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_DATA_OUT/WIDTH_DATA_IN-1:0][WIDTH_DATA_IN-1:0] datTmp;

  assign datTmp = iDat  ;
  assign oDat   = datTmp;

  // parameter check.
  initial begin
    if((WIDTH_DATA_IN % WIDTH_DATA_OUT)!=0) begin
      $error("Parameter Error: Width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end 
    if(WIDTH_DATA_IN > (2**WIDTH_ADDR)*WIDTH_DATA_OUT) begin
      $error("Parameter Error: Width of input data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule : ZionBasicCircuitLib_BitRead
`endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name  : ZionBasicCircuitLib_BitWrite
// Author       : Wenheng Ma
// Date         : 2019-10-28
// Version      : 1.0
// Parameter    :
//WIDTH_ADDR    -  width of input  address
//WIDTH_DATA_IN -  width of input  data
//WIDTH_DATA_OUT-  width of output data
// Description  :
//   Write operations under sequential logic
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-10-28 | Wenheng Ma |     1.0     |   Original Version
// 2019-10-31 |  Yudi Gao  |     2.0     |   Add TestBench
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_BitWrite
`ifdef ZionBasicCircuitLib_BitWrite
  `__DefErr__(ZionBasicCircuitLib_BitWrite)
`else
  `define ZionBasicCircuitLib_BitWrite(UnitName,iAddr_MT,iDat_MT,oDat_MT) \
ZionBasicCircuitLib_BitWrite  #(.WIDTH_ADDR($bits(iAddr_MT)),             \
                                  .WIDTH_DATA_IN($bits(iDat_MT)),         \
                                  .WIDTH_DATA_OUT($bits(oDat_MT)))        \
                                UnitName(                                 \
                                  .iAddr(iAddr_MT),                       \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_BitWrite
#(WIDTH_ADDR     = "_", //$bits(iAddr)// width of input  addr
  WIDTH_DATA_IN  = "_", //$bits(iDat) // width of input  data
  WIDTH_DATA_OUT = "_"  //$bits(oDat) // width of output data
)(
  input        [WIDTH_ADDR    -1:0] iAddr,
  input        [WIDTH_DATA_IN -1:0] iDat,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_DATA_OUT/WIDTH_DATA_IN-1:0][WIDTH_DATA_IN-1:0] datTmp;

  always_comb begin
    foreach(datTmp[i]) datTmp[i] = (iAddr == i)? iDat : '1;
  end

  assign oDat = datTmp;

  // parameter check.
  initial begin
    if((WIDTH_DATA_OUT % WIDTH_DATA_IN)!=0) begin
      $error("Parameter Error: Width mismatch!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end 
    if(WIDTH_DATA_OUT > (2**WIDTH_ADDR)*WIDTH_DATA_IN) begin
      $error("Parameter Error: Width of output data is overflow!!");
      `ifdef CHECK_ERR_EXIT
        $finish;
      `endif
    end
  end

endmodule : ZionBasicCircuitLib_BitWrite
`endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name      : ZionBasicCircuitLib_DatRead
// Author           : Wenheng Ma
// Date             : 2019-11-03
// Version          : 1.0
// Parameter        :
//   WIDTH_TYPE_NUM - number of width type
//   WIDTH_ADDR     - width of input  addr
//   WIDTH_DATA_IN  - width of input  data
//   WIDTH_DATA_OUT - width of output data
// Description      :
//   Read data
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-03 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_DatRead
`ifdef ZionBasicCircuitLib_DatRead
  `__DefErr__(ZionBasicCircuitLib_DatRead)
`else
  `define ZionBasicCircuitLib_DatRead(UnitName,iSignedRd_MT,iEn_MT,iAddr_MT,iDat_MT,oDat_MT,MULTI_DATA_WIDTH_MT={0},ADDR_TYPE_MT=0) \
ZionBasicCircuitLib_DatRead #(.WIDTH_TYPE_NUM($bits(iEn_MT)),           \
                                .WIDTH_ADDR($bits(iAddr_MT)),           \
                                .WIDTH_DATA_IN($bits(iDat_MT)),         \
                                .WIDTH_DATA_OUT($bits(oDat_MT)),        \
                                .MULTI_DATA_WIDTH(MULTI_DATA_WIDTH_MT), \
                                .ADDR_TYPE(ADDR_TYPE_MT))               \
                              UnitName(                                 \
                                .iSignedRd(iSignedRd_MT),                \
                                .iEn(iEn_MT),                           \
                                .iAddr(iAddr_MT),                       \
                                .iDat(iDat_MT),                         \
                                .oDat(oDat_MT)                          \
                              )

`endif

module ZionBasicCircuitLib_DatRead
#(int WIDTH_TYPE_NUM   = "_", //$bits(iEn)  // number of width type
  int    WIDTH_ADDR       = "_", //$bits(iAddr)// width of input  addr
  int    WIDTH_DATA_IN    = "_", //$bits(iDat) // width of input  data
  int    WIDTH_DATA_OUT   = "_", //$bits(oDat) // width of output data
  int    MULTI_DATA_WIDTH[WIDTH_TYPE_NUM] = {0,0,0},
  int    ADDR_TYPE        = 0
)(
  input                             iSignedRd,
  input        [WIDTH_TYPE_NUM-1:0] iEn  ,
  input        [WIDTH_ADDR    -1:0] iAddr,
  input        [WIDTH_DATA_IN -1:0] iDat ,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_TYPE_NUM-1:0][WIDTH_DATA_OUT-1:0] rsltTmp;
  `gen_if(WIDTH_TYPE_NUM==1) begin :  SingleDatGen
    logic [WIDTH_DATA_IN/WIDTH_DATA_OUT-1:0][WIDTH_DATA_OUT-1:0] datTmp, readDat;
    assign datTmp = (iEn[0])? iDat : '0;
    always_comb begin
      foreach(readDat[j]) readDat[j] = (iAddr == j)? datTmp[j] : '0;
    oDat = '0;
    foreach(readDat[j]) oDat = oDat | readDat[j];
    end
  end `gen_else begin : MultiDatGen
    for(genvar i=0;i<WIDTH_TYPE_NUM;i++) begin : EachDatGen
      logic [WIDTH_DATA_IN/MULTI_DATA_WIDTH[i]-1:0][MULTI_DATA_WIDTH[i]-1:0] datTmp, readDat;
      assign datTmp = (iEn[i])? iDat : '0;
      `gen_if(MULTI_DATA_WIDTH[i]==WIDTH_DATA_OUT) begin : DataGen_FullWidth
        assign readDat = datTmp;
      end `gen_else begin : DataGen_NonFullWidth
        `gen_if(ADDR_TYPE==0) begin : AddrType0_readDatGen
          always_comb begin
            foreach(readDat[j]) begin
              readDat[j] = (iAddr[$high(iAddr)-:$clog2(WIDTH_DATA_IN/MULTI_DATA_WIDTH[i])] == j)? datTmp[j] : '0;
            end
          end
        end `gen_else begin : AddrType1_readDatGen
          always_comb begin
            foreach(readDat[j]) readDat[j] = (iAddr == j)? datTmp[j] : '0;
          end
        end
      end
    always_comb begin
      rsltTmp[i] = '0;
      foreach(readDat[j]) rsltTmp[i] = rsltTmp[i] |  {{($bits(oDat)-MULTI_DATA_WIDTH[i]){iSignedRd&readDat[j][MULTI_DATA_WIDTH[i]-1]}},readDat[j]};
    end
   end
    always_comb begin
    oDat = '0;
    foreach(rsltTmp[j]) oDat = oDat | rsltTmp[j];
    end
  end
endmodule : ZionBasicCircuitLib_DatRead
`endif
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name      : ZionBasicCircuitLib_WriteDatExtd
// Author           : Wenheng Ma
// Date             : 2019-11-03
// Version          : 1.0
// Parameter        :
//   WIDTH_TYPE_NUM - number of width type
//   WIDTH_ADDR     - width of input  addr
//   WIDTH_DATA_IN  - width of input  data
//   WIDTH_DATA_OUT - width of output data
// Description      :
//   Write data
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-03 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_WriteDatExtd
`ifdef ZionBasicCircuitLib_WriteDatExtd
  `__DefErr__(ZionBasicCircuitLib_WriteDatExtd)
`else
  `define ZionBasicCircuitLib_WriteDatExtd(UnitName,iEn_MT,iAddr_MT,iDat_MT,oDat_MT,MULTI_DATA_WIDTH_MT={0},ADDR_TYPE_MT=0) \
ZionBasicCircuitLib_WriteDatExtd  #(.WIDTH_TYPE_NUM($bits(iEn_MT)),       \
                                  .WIDTH_ADDR($bits(iAddr_MT)),           \
                                  .WIDTH_DATA_IN($bits(iDat_MT)),         \
                                  .WIDTH_DATA_OUT($bits(oDat_MT)),        \
                                  .MULTI_DATA_WIDTH(MULTI_DATA_WIDTH_MT), \
                                  .ADDR_TYPE(ADDR_TYPE_MT))               \
                                UnitName(                                 \
                                  .iEn(iEn_MT),                           \
                                  .iAddr(iAddr_MT),                       \
                                  .iDat(iDat_MT),                         \
                                  .oDat(oDat_MT)                          \
                                )
`endif

module ZionBasicCircuitLib_WriteDatExtd
#(int WIDTH_TYPE_NUM   = "_", //$bits(iEn)  // number of width type
 int WIDTH_ADDR       = "_", //$bits(iAddr)// width of input  addr
 int WIDTH_DATA_IN    = "_", //$bits(iDat) // width of input  data
 int WIDTH_DATA_OUT   = "_", //$bits(oDat) // width of output data
 int MULTI_DATA_WIDTH[WIDTH_TYPE_NUM] = {0,0,0},
 int ADDR_TYPE        = 0
)(
  input        [WIDTH_TYPE_NUM-1:0] iEn  ,
  input        [WIDTH_ADDR    -1:0] iAddr,
  input        [WIDTH_DATA_IN -1:0] iDat ,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_TYPE_NUM-1:0][WIDTH_DATA_OUT-1:0] rsltTmp;

  `gen_if(WIDTH_TYPE_NUM==1) begin :  SingleDatGen
    logic [WIDTH_DATA_OUT/WIDTH_DATA_IN-1:0][WIDTH_DATA_IN-1:0] datTmp;
    wire  [WIDTH_DATA_IN-1:0] wrDat = (iEn[0])? iDat : '0;
    always_comb begin
      foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : '0;
    end
    assign oDat = datTmp;
  end `gen_else begin : MultiDatGen
    for(genvar i=0;i<WIDTH_TYPE_NUM;i++) begin : EachDatGen
    //parameter int  slip1=WIDTH_DATA_OUT/MULTI_DATA_WIDTH[i];
      logic [WIDTH_DATA_OUT/MULTI_DATA_WIDTH[i]-1:0][MULTI_DATA_WIDTH[i]-1:0] datTmp;
      wire  [MULTI_DATA_WIDTH[i]-1:0] wrDat = (iEn[i])? iDat[MULTI_DATA_WIDTH[i]-1:0] : '0;
      `gen_if(MULTI_DATA_WIDTH[i]==WIDTH_DATA_OUT) begin : DataGen_FullWidth
       assign datTmp[0] = wrDat ;
      end `gen_else begin : DataGen_NonFullWidth
        `gen_if(ADDR_TYPE==0) begin : AddrType0_datTmpGen
          always_comb begin
            foreach(datTmp[j]) begin
            //parameter int  slip2=WIDTH_DATA_OUT/MULTI_DATA_WIDTH[i];
              datTmp[j] = (iAddr[$high(iAddr)-:$clog2(WIDTH_DATA_OUT/MULTI_DATA_WIDTH[i])] == j)? wrDat : '0;
            end
          end
        end `gen_else begin : AddrType1_datTmpGen
          always_comb begin
            foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : '0;
          end
        end
      end
      assign rsltTmp[i] = datTmp;
    end
    always_comb begin
      oDat = '0;
      foreach(rsltTmp[i]) oDat = rsltTmp[i] | oDat;
    end
  end
endmodule : ZionBasicCircuitLib_WriteDatExtd
`endif

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name      : ZionBasicCircuitLib_WriteMaskExtd
// Author           : Wenheng Ma
// Date             : 2019-11-03
// Version          : 1.0
// Parameter        :
//   WIDTH_TYPE_NUM - number of width type
//   WIDTH_ADDR     - width of input  addr
//   WIDTH_DATA_OUT - width of output data
// Description      :
//   Generate write mask
// Modification History:
//    Date    |   Author   |   Version   |   Change Description
//======================================================================================================================
// 2019-11-03 | Wenheng Ma |     1.0     |   Original Version
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`ifndef Disable_ZionBasicCircuitLib_WriteMaskExtd
`ifdef ZionBasicCircuitLib_WriteMaskExtd
  `__DefErr__(ZionBasicCircuitLib_WriteMaskExtd)
`else
  `define ZionBasicCircuitLib_WriteMaskExtd(UnitName,iEn_MT,iAddr_MT,oDat_MT,MASK_WIDTH_MT={0},ADDR_TYPE_MT=0,MASK_FLAG_MT=0) \
ZionBasicCircuitLib_WriteMaskExtd  #(.WIDTH_TYPE_NUM($bits(iEn_MT)),  \
                                  .WIDTH_ADDR($bits(iAddr_MT)),       \
                                  .MASK_WIDTH(MASK_WIDTH_MT),         \
                                  .WIDTH_DATA_OUT($bits(oDat_MT)),    \
                                  .ADDR_TYPE(ADDR_TYPE_MT),           \
                                  .MASK_FLAG(MASK_FLAG_MT))           \
                                UnitName(                             \
                                  .iEn(iEn_MT),                       \
                                  .iAddr(iAddr_MT),                   \
                                  .oDat(oDat_MT)                      \
                                )
`endif

module ZionBasicCircuitLib_WriteMaskExtd
#(int WIDTH_TYPE_NUM = "_", //$bits(iEn)  // number of width type
  int WIDTH_ADDR     = "_", //$bits(iAddr)// width of input  addr
  int MASK_WIDTH[WIDTH_TYPE_NUM]    = {0,0,0},
  int WIDTH_DATA_OUT = "_", //$bits(oDat) // width of output data
  int ADDR_TYPE      =  0 ,
  int MASK_FLAG      =  0
)
(
  input        [WIDTH_TYPE_NUM-1:0] iEn  ,
  input        [WIDTH_ADDR    -1:0] iAddr,
  output logic [WIDTH_DATA_OUT-1:0] oDat
);

  logic [WIDTH_TYPE_NUM-1:0][WIDTH_DATA_OUT-1:0] rsltTmp;

  `gen_if(WIDTH_TYPE_NUM==1) begin :  SingleDatGen
    logic [WIDTH_DATA_OUT/MASK_WIDTH-1:0][MASK_WIDTH-1:0] datTmp;
    logic [MASK_WIDTH-1:0] maskFlg, unmaskFlg;
    `gen_if(MASK_FLAG) begin
      assign maskFlg   = '0;
      assign unmaskFlg = '1;
    end `gen_else begin
      assign maskFlg   = '1;
      assign unmaskFlg = '0;
    end
    wire  [MASK_WIDTH-1:0] wrDat = (iEn[0])? maskFlg : unmaskFlg;
    always_comb begin
      foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : unmaskFlg;
    end
    assign oDat = datTmp;
  end `gen_else begin : MultiDatGen
    for(genvar i=0;i<WIDTH_TYPE_NUM;i++) begin : EachDatGen
      logic [WIDTH_DATA_OUT/MASK_WIDTH[i]-1:0][MASK_WIDTH[i]-1:0] datTmp;
      logic [MASK_WIDTH[i]-1:0] maskFlg, unmaskFlg;
      `gen_if(MASK_FLAG) begin
        assign maskFlg   = '0;
        assign unmaskFlg = '1;
      end `gen_else begin
        assign maskFlg   = '1;
        assign unmaskFlg = '0;
      end
      wire  [MASK_WIDTH[i]-1:0] wrDat = (iEn[i])? maskFlg : unmaskFlg;
      `gen_if(MASK_WIDTH[i]==WIDTH_DATA_OUT) begin : DataGen_FullWidth
       assign datTmp[0] = wrDat;
      end `gen_else begin : DataGen_NonFullWidth
        `gen_if(ADDR_TYPE==0) begin : AddrType0_datTmpGen
          always_comb begin
            foreach(datTmp[j]) begin
              datTmp[j] = (iAddr[$high(iAddr)-:$clog2(WIDTH_DATA_OUT/MASK_WIDTH[i])] == j)? wrDat : unmaskFlg;
            end
          end
        end `gen_else begin : AddrType1_datTmpGen
          always_comb begin
            foreach(datTmp[j]) datTmp[j] = (iAddr == j)? wrDat : unmaskFlg;
          end
        end
      end
      assign rsltTmp[i] = datTmp;
    end
    always_comb begin
    oDat = 0;
    foreach(rsltTmp[j]) oDat = oDat | rsltTmp[j];
    end
  end
endmodule : ZionBasicCircuitLib_WriteMaskExtd
`endif
//endsection: Memory +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
