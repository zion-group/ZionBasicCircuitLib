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
//   TODO
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