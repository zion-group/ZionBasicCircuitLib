module ZionBasicCircuitLib_ArithmShiftRightM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;

  logic [ 4:0] shift;
  logic [31:0] dat;

  initial begin
    forever #(period/2) begin
      shift = {$random()}%33;
      dat  = {$random()}%(32'hffff_ffff);
    end
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (`BcArithmShiftRightM(dat,shift)!= $bits(dat)'({{$bits(dat){dat[$high(dat)]}},dat} >> shift)) begin//| `BcAddSubdM(datB)
        $error("oDat fault, %0d!,%0d", dat,shift);
        $finish;
      end
    end
  end
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_ArithmShiftRightM_tb,"+all");
    #500 $finish;
  end 

  
`Unuse_ZionBasicCircuitLib(Bc)
endmodule
