module control_unit (
    input wire [31:0] instruction,
    output reg [3:0] alu_op,
    output reg [3:0] write_reg_sel,
    output reg reg_write_enable,
    output reg [3:0] read_reg_sel1,
    output reg [3:0] read_reg_sel2,
    output reg [31:0] immidiate_val,
    output reg immidiate,
    output reg jump_en,
    output reg [31:0] jump_addr,
    output reg mem_load,
    output reg mem_store,
    output reg mem_load_im,
    output reg mem_store_im,
    output reg [31:0] mem_im_addr
);


  always @* begin

    alu_op = 4'bx;
    write_reg_sel = 1'bx;
    reg_write_enable = 1'b0;
    read_reg_sel1 = 4'bx;
    read_reg_sel2 = 4'bx;
    immidiate_val = 32'bx;
    immidiate = 1'b0;
    jump_en = 1'b0;
    jump_addr = 32'bx;
    mem_load = 1'b0;
    mem_store = 1'b0;
    mem_load_im = 1'b0;
    mem_store_im = 1'b0;
    mem_im_addr = 32'bx;

    case (instruction[27:26])
      2'b00: begin  // ALU OPS
        alu_op = instruction[24:21];
        reg_write_enable = 1'b1;
        read_reg_sel1 = instruction[19:16];
        write_reg_sel = instruction[15:12];
        if (instruction[25] == 1'b0) begin
          read_reg_sel2 = instruction[3:0];
        end else begin
          immidiate = 1'b1;
          immidiate_val = {24'b0, instruction[7:0]};
        end
      end
      2'b01: begin  // Memory OPS
        read_reg_sel1 = instruction[19:16];

        if (instruction[25]) begin
          if (instruction[20]) begin  // LDR R
            mem_load = 1'b1;
            reg_write_enable = 1'b1;
            write_reg_sel = instruction[15:12];
          end else begin  // STR R
            mem_store = 1'b1;
            read_reg_sel2 = instruction[15:12];
          end
        end else begin
          mem_im_addr = {20'b0, instruction[11:0]};
          if (instruction[20]) begin  // LDR I
            mem_load = 1'b1;
            mem_load_im = 1'b1;
            reg_write_enable = 1'b1;
            write_reg_sel = instruction[15:12];
          end else begin  // STR I
            mem_store = 1'b1;
            mem_store_im = 1'b1;
            read_reg_sel2 = instruction[15:12];
          end
        end
      end
      2'b10: begin  // Jump OPS
        jump_en   = 1'b1;
        jump_addr = {{8{instruction[23]}}, instruction[23:0]};
      end
    endcase
  end

endmodule
