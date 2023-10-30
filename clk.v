module clk (
    output reg clk
);

  initial begin
    clk = 0;
  end

  always #5 clk = ~clk;

endmodule
