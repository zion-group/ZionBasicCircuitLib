module ZionBasicCircuitLib_AddSub_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;

  logic        addEn,subEn;
  logic [31:0] datA, datB;
  logic [31:0] oDat;

  initial begin
      addEn = '0;
      subEn = '0;
      datA  = 'd3;
      datB  = 'd3;
    forever #(period/2) begin
      addEn = {$random()}%2;
      subEn = {$random()}%2;
      datA  = {$random()}%(32'hffff_ffff);
      datB  = {$random()}%(32'hffff_ffff);
    end
  end
  
  initial begin 
    forever #(period/2) begin
      #5;
      if (({$bits(datA){addEn | subEn}} & datA) + (({$bits(datB){subEn}} & ~datB)|({$bits(datB){addEn}} & datB)+subEn)) begin
        $error("oDat fault,addEn=%0d,subEn=%0d,datA=%0d,datB=%0d,oDat=%0d,",addEn,subEn,datA,datB,oDat);
        $finish;
      end
    end
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_AddSub_tb,"+all");
    #500 $finish;
  end 

  `BcAddSub ( U_AddSub,
                addEn,
                subEn,
                datA,
                datB,
                oDat
    );
  
`Unuse_ZionBasicCircuitLib(Bc)
endmodule
