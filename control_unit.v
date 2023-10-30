module control_unit (
    input wire [31:0] instruction,
    output reg [3:0] alu_op,
    output reg [4:0] write_reg_sel,
    output reg reg_write_enable,
    output reg [4:0] read_reg_sel1,
    output reg [4:0] read_reg_sel2,
    output reg [31:0] immidiate_val,
    output reg immidiate,
    output reg jump_en,
    output reg [31:0] jump_addr,
    output reg mem_load,
    output reg mem_store
);


  always @* begin
    case (instruction[27:26])
      2'b00: begin  // ALU OPS
        mem_load = 1'b0;
        mem_store = 1'b0;
        alu_op = instruction[24:21];
        jump_en = 1'b0;
        jump_addr = 32'hxxxx;
        reg_write_enable = 1'b1;
        read_reg_sel1 = instruction[19:16];
        write_reg_sel = instruction[15:12];
        if (instruction[25] == 1'b0) begin
          immidiate = 1'b0;
          immidiate_val = 32'hxxxx_xxxx;
          read_reg_sel2 = instruction[3:0];
        end else begin
          immidiate = 1'b1;
          immidiate_val = {24'b0, instruction[7:0]};
          read_reg_sel2 = 4'hx;
        end
      end
      2'b01: begin  // Memory OPS
        jump_en = 1'b0;
        jump_addr = 32'hxxxx;
        immidiate = 1'b0;
        immidiate_val = 32'hxxxx_xxxx;
		read_reg_sel1 = instruction[19:16];
        read_reg_sel2 = 32'bx;

        if (instruction[20]) begin  // LDR
          mem_load = 1'b1;
          mem_store = 1'b0;
          reg_write_enable = 1'b1;
          write_reg_sel = instruction[15:12];
        end else begin  // STR
          mem_load = 1'b0;
          mem_store = 1'b1;
          reg_write_enable = 1'b0;
          read_reg_sel2 = instruction[15:12];
		  write_reg_sel = 32'bx;
        end
      end
      2'b10: begin  // Jump OPS
        mem_load = 1'b0;
        mem_store = 1'b0;
        jump_en = 1'b1;
        jump_addr = {{8{instruction[23]}}, instruction[23:0]};
        reg_write_enable = 1'b0;
        immidiate = 1'b0;
        immidiate_val = 32'hxxxx_xxxx;
        read_reg_sel1 = 4'hx;
        read_reg_sel2 = 4'hx;
      end
      default: begin
        mem_load = 1'b0;
        jump_en = 1'b0;
        jump_addr = 32'hxxxx;
        reg_write_enable = 1'b0;
        read_reg_sel1 = 4'hx;
        read_reg_sel2 = 4'hx;
        immidiate = 1'b0;
        immidiate_val = 32'hxxxx_xxxx;
      end
    endcase
  end

endmodule
