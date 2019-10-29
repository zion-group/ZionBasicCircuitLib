module ZionBasicCircuitLib_AddSubdM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;

  logic        addEn,subEn;
  logic [31:0] datA, datB;

  initial begin
    forever #(period/2) begin
      addEn = {$random()}%2;
      subEn = {$random()}%2;
      datA  = {$random()}%(32'hffff_ffff);
      datB  = {$random()}%(32'hffff_ffff);
    end
  end
  wire [31:0]a = ({$bits(datA){addEn & subEn}} & datA) + (({$bits(datB){subEn}} & datB)|({$bits(datB){addEn}} & datB)) + subEn;
  initial begin 
    forever #(period/2) begin
      #5;
      if (`BcAddSubdM(addEn,subEn,datA,datB)!= a) begin//| `BcAddSubdM(datB)
        $error("oDat fault, %0d!,%0d,%0d", datA,datA,datB);
        $finish;
      end
    end
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_AddSubdM_tb,"+all");
    #500 $finish;
  end 
  // always_comb
  // `BcAddSubdM  ( 
  //               addEn,subEn,datA,datB
  //             );
  
`Unuse_ZionBasicCircuitLib(Bc)
endmodule
