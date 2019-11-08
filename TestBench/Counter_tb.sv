module Counter_tb;
  parameter WIDTH  = 32,
            period =5;

  logic clk,rst;
  logic clr,en,overflow;
  logic [WIDTH-1:0] startNum, endNum, step, counter, counter_f;

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end
  initial begin
    rst = 0;
    #20  rst = 1;
  end

  initial begin
      clr = 0;
      en  = 1;
    forever @(negedge clk) begin
      // clr  = {$random()}%2;
      // en   = {$random()}%2;
    end
  end
  assign startNum = '0;
  assign endNum   = 32'hf000_0000;
  assign step     = 'h0200_0000;

  // initial begin 
  //   forever @(posedge clk) begin
  //     #period;
  //     if (counter_f != ((en)? (counter + step): counter))begin
  //       $error("counter_f fault");
  //       $finish;
  //     end else if (overflow != (counter == endNum))begin
  //       $error("overflow fault");
  //       $finish;
  //     end
  //   end
  // end
  
  // initial begin 
  //   forever #(period/2) begin
  //     #5;
  //     forever@(posedge clk, negedge rst) begin
  //       if(rst)begin
  //         if (counter != ((clr)? startNum : (counter_f-step)))begin
  //           $error("overflow fault,%d,%d,%d",counter,clr,counter_f);
  //           $finish;
  //         end
  //       end
  //     end
  //   end
  // end

  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,Counter_tb,"+all");
    #5000 $finish;
  end 

  // Counter #(.WIDTH(32))
  //   U_Counter ( clk,
  //                  rst
  //                ); 
  // always_comb begin
  //   Counter.clr       = clr;
  //   Counter.en        = en;
  //   overflow  =Counter.overflow;
  //   Counter.startNum  = startNum;
  //   Counter.endNum    = endNum;
  //   Counter.step      = step;
  //   counter   =  Counter.counter;
  //   counter_f = Counter.counter_f;
  // end
Counter_m #(.WIDTH(32))
    U_Counter_m (clk, rst,overflow,counter, counter_f); 
always_comb begin
    Counter_m.clr       = clr;
    Counter_m.en        = en;
    Counter_m.startNum  = startNum;
    Counter_m.endNum    = endNum;
    Counter_m.step      = step;
  end
endmodule : Counter_tb