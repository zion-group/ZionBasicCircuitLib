
interface Counter
#(WIDTH = 32
)(
  input clk,rst
);

  logic clr,en,overflow;
  logic [WIDTH-1:0] startNum, endNum, step, counter, counter_f;

  assign counter_f = (en)? (counter + step): counter;
  assign overflow = (counter == endNum);

  always_ff@(posedge clk, negedge rst) begin
    if(!rst)begin
      counter <= startNum;
    end else begin
      counter <= (clr)? startNum : counter_f;
    end
  end

endinterface : Counter

/*,
  START = "_",
  END   = "_",
  CLR   =  1 ,
  EN    =  1 ,*/
