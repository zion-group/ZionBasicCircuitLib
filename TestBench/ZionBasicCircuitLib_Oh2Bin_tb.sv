module ZionBasicCircuitLib_Oh2Bin_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter START     = 0,
            STEP      = 1,
            period    = 20;

  logic [ 7:0] iDat;
  logic [ 2:0] oDat;
  logic        flag;
  logic [14:0] temp;
  logic [ 2:0] addr [14:0];
  initial begin
    //forever #(period) begin
    #(period)  iDat = 8'b0000_0000;
    #(period)  iDat = 8'b0000_0001;
    #(period)  iDat = 8'b0000_0010;
    #(period)  iDat = 8'b0000_0100;
    #(period)  iDat = 8'b0000_1000;
    #(period)  iDat = 8'b0001_0000;
    #(period)  iDat = 8'b0010_0000;
    #(period)  iDat = 8'b0100_0000;
    #(period)  iDat = 8'b1000_0001;
    //end
  end
  //test ZionBasicCircuitLib_Oh2Bin.sv
  initial begin 
    forever begin
      #5;
      foreach(oDat[i])begin
        if (flag != (temp[14] ? 1 : 0)) begin//**STEP+START
          $error("flag fault, %0d!=%0d,", flag,temp);
          $finish;
        end else if (oDat != (flag ? addr[14] : '0)) begin
          $error("oDat fault, %0d!=%0d,in case of flag = %0d", oDat,(addr[14]),flag);
          $finish;
        end
      end
    end
  end
 
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_Oh2Bin_tb,"+all");
    #500 $finish;
  end 


  `BcOh2Bin     (U_Oh2Bin,
                   iDat,             //input 
                   oDat              //output  
                );     
`Unuse_ZionBasicCircuitLib(Bc)
endmodule 