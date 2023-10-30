module reset (
    output reg reset
);

  initial begin
    reset = 1'b1;
    #2 reset = 1'b0;
  end

endmodule
