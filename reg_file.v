module reg_file (
    input wire clk,
    input wire reset,
    input wire reg_write_enable,
    input wire [3:0] write_reg_sel,
    input wire [31:0] write_reg_data,
    input wire [3:0] read_reg_sel1,
    input wire [3:0] read_reg_sel2,
    output wire [31:0] read_reg_data1,
    output wire [31:0] read_reg_data2
);
  integer i;
  reg [31:0] reg_file[0:15];

  initial begin
    for (i = 0; i < 16; i = i + 1) begin
      reg_file[i] <= 32'b0;
    end
  end

  always @(posedge reset) begin
    for (i = 0; i < 16; i = i + 1) begin
      reg_file[i] <= 32'b0;
    end
  end

  always @(posedge clk) begin
    if (reg_write_enable) begin
      reg_file[write_reg_sel] <= write_reg_data;
    end
  end


  assign read_reg_data1 = reg_file[read_reg_sel1];
  assign read_reg_data2 = reg_file[read_reg_sel2];

endmodule
