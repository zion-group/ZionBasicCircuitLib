module ZionBasicCircuitLib_MultiTypeShift_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period            = 20,
            INPUT_DATA_WIDTH  = 8,
            SHIFT_BIT_WIDTH   = 3,
            OUTPUT_DATA_WIDTH = 8;

 logic                         iSftR  ;
 logic                         iSftA  ;
 logic                         iSftL  ;
 logic [INPUT_DATA_WIDTH -1:0] iDat   ;
 logic [SHIFT_BIT_WIDTH  -1:0] iSftBit;
 logic [OUTPUT_DATA_WIDTH-1:0] oDat   ;

  initial begin
    iDat = 8'b1111_1111;
    forever begin//#(period/2) 
    //Arithmetic right shift
    #20  iSftR   = '1;iSftA = '1;iSftL ='0;iSftBit = '0;
    #20  iSftBit = 'h1;
    #20  iSftBit = 'h2;
    #20  iSftBit = 'h3;
    #20  iSftBit = 'h4;
    //Logical right shift
    #20  iSftR   = '1;iSftA = '0;iSftL ='0;iSftBit = '0;
    #20  iSftBit = 'h1;
    #20  iSftBit = 'h2;
    #20  iSftBit = 'h3;
    #20  iSftBit = 'h4;
    //Arithmetic left shift
    #20  iSftR   = '0;iSftA = '1;iSftL ='1; iSftBit = '0;
    #20  iSftBit = 'h1;
    #20  iSftBit = 'h2;
    #20  iSftBit = 'h3;
    #20  iSftBit = 'h4;  
    //Logical left shift 
    #20  iSftR   = '0;iSftA = '0;iSftL ='1; iSftBit = '0;
    #20  iSftBit = 'h1;
    #20  iSftBit = 'h2;
    #20  iSftBit = 'h3;
    #20  iSftBit = 'h4; 

   
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_MultiTypeShift_tb,"+all");
    #500 $finish;
  end 

  `BcMultiTypeShift ( U_MultiTypeShift,
                        iSftR,
                        iSftA,
                        iSftL,
                        iDat,                     
                        iSftBit,                         
                        oDat  
                    );
  //UnitName,iSftR_MT,iSftA_MT,iSftL_MT,iAddr_MT,iDat_MT,iSftBit_MT,oDat_MT
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 
