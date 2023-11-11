module alu (
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] alu_op,
    input wire [1:0] sh,
    output reg [31:0] result,
    output reg zero,
    output reg lt,
    output reg gt
);

  always @* begin
    case (alu_op)
      4'b0000: result = op1 & op2;  // AND
      4'b0001: result = op1 ^ op2;  // XOR
      4'b0010: result = op1 - op2;  // SUB
      4'b0100: result = op1 + op2;  // ADD
      4'b1010: result = op1 - op2;  // CMP
      4'b1100: result = op1 | op2;  // ORR
      4'b1101: begin
        case(sh)
        2'b00: result = op1 << op2; // LSL
        2'b01: result = op1 >> op2; // LSR
        endcase
      end
      default: result = 32'b0;
    endcase
    zero = (result == 32'b0);
    lt   = (op1 < op2);
    gt   = (op1 > op2);
  end

endmodule
