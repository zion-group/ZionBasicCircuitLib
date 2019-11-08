///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Module name  : ZionBasicCircuitLib_BitWrite
// Author       : Wenheng Ma
// Date         : 2019-10-28
// Version      : 2.0
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