


module MultiTypeShift
#(INPUT_DATA_WIDTH  = 32,
  SHIFT_BIT_WIDTH   = 5 ,
  OUTPUT_DATA_WIDTH = 32
)(
  input                                iSftR  ,
  input                                iSftA  ,
  input                                iSftL  ,
  input                                iSftR  ,
  input        [INPUT_DATA_WIDTH -1:0] iDat   ,
  input        [SHIFT_BIT_WIDTH  -1:0] iSftBit,
  output logic [OUTPUT_DATA_WIDTH-1:0] oDat
);

  wire [INPUT_DATA_WIDTH  -1:0] datReverse, sftDat, highBits, sftRsltTmp, rsltReverse;
  wire [INPUT_DATA_WIDTH*2-1:0] jointDat;
  always_comb begin
    datReverse  = {1<<{iDat}};
    sftDat      =  ({INPUT_DATA_WIDTH{iSftR}} & iDat) 
                  |({INPUT_DATA_WIDTH{iSftL}} & datReverse); 
    highBits    = {INPUT_DATA_WIDTH{iSftA & sftDat[$high(sftDat)]}};
    jointDat    = (iSftR)? {sftDat,sftDat} : {highBits,sftDat};
    sftRsltTmp  = INPUT_DATA_WIDTH'({highBits,sftDat} >> iSftBit);
    rsltReverse = {1<<{sftRsltTmp}};
    oDat        =  ({INPUT_DATA_WIDTH{iSftR}} & sftRsltTmp) 
                  |({INPUT_DATA_WIDTH{iSftL}} & rsltReverse);
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

endmodule : MultiTypeShift

