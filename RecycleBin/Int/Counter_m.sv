
module Counter_m
#(WIDTH = 32
)(
  input                    clk,     rst,
  output logic             overflow,
  output logic [WIDTH-1:0] counter, counter_f
);

  logic clr,en;
  logic [WIDTH-1:0] startNum, endNum, step;

  assign counter_f = (en)? (counter + step): counter;
  assign overflow = (counter == endNum);

  always_ff@(posedge clk, negedge rst) begin
    if(!rst)begin
      counter <= startNum;
    end else begin
      counter <= (clr)? startNum : counter_f;
    end
  end

endmodule 
