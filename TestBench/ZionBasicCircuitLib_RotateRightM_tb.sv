module ZionBasicCircuitLib_RotateRightM_tb;
`Use_ZionBasicCircuitLib(Bc) 
  parameter period = 20;
  logic [ 4:0] shift;
  logic [31:0] dat;

  initial begin
    forever #(period/2) 
      shift = {$random()}%33;
      dat   = {$random()}%(32'hffff_ffff);
  end

  initial begin 
    forever #(period/2) begin
      #5;
      if (`BcRotateRightM(dat,shift) != $bits(dat)'({dat,dat} >> shift)) begin
        $error("oDat fault, dat = %0d,shift = %0d,result = %0d", dat,shift,$bits(dat)'({dat,dat} >> shift));
        $finish;
      end
    end
  end
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_RotateRightM_tb,"+all");
    #500 $finish;
  end 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule 