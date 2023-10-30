module alu (
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] alu_op,
    output reg [31:0] result,
    output reg zero
);

  always @* begin
    case (alu_op)
      4'b0000: result = op1 & op2;  // AND
      4'b0001: result = op1 ^ op2;  // XOR
      4'b0010: result = op1 - op2;  // SUB
      4'b0100: result = op1 + op2;  // ADD
      4'b1010: result = op1 - op2;  // CMP
      4'b1100: result = op1 | op2;  // ORR
      default: result = 32'b0;
    endcase
    zero = (result == 32'b0);
  end

endmodule
