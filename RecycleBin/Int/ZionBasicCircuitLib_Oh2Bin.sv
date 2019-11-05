  
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