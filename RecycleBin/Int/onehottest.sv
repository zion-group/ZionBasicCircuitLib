module onehottest(
                  //input [2:0]i_oh
                  input  logic [8-1:0] iDat,
                  output logic [8-1:0] oDat
                  );

`Use_ZionBasicCircuitLib(Bc)
//parameter START=0,STEP=1;//logic [7:0]o;
//logic [$bits(iDat)-1:0] oDat;


// function automatic logic [7:0] bbbb(input [2:0]i_oh);
//     `BcOnehotDefBinM(Onehot,i_oh,START,STEP) ;
// return Onehot;
//  endfunction
// always_comb begin: ohDatt
//  o = bbbb(i_oh);

function automatic logic [7:0] bbbb(input [7:0]iDat);
  logic [$bits(iDat)-1:0] oDat; 
  //`BcOnehotDefBitmapM(oDat,iDat);
  for(int oDat_i_=0;oDat_i_<$bits(oDat);oDat_i_++)begin if(oDat_i_==0) oDat[0]=iDat[0]; else oDat[oDat_i_]= ~(|iDat[oDat_i_-1:0]) & iDat[oDat_i_];end
  return(oDat);
endfunction 
 always_comb begin
  oDat = bbbb(iDat);
 end
`Unuse_ZionBasicCircuitLib(Bc)
endmodule
 