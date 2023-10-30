module processor (
	input wire clk,
	input wire reset,
	input wire [31:0] instruction,
	output wire [31:0] addr,
	output wire [31:0] write_addr,
	output wire [31:0] write_data
);

wire jump_en;
wire [31:0] jump_addr;
wire [3:0] alu_op;
wire [4:0] write_reg_sel;
wire reg_write_enable;
wire [4:0] read_reg_sel1;
wire [4:0] read_reg_sel2;
wire immidiate;
wire [31:0] immidiate_val;
wire [31:0] result;
wire [31:0] read_addr1;
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [31:0] read_reg_data1;
wire [31:0] read_reg_data2;
wire zero;
wire mem_load;
wire mem_store;

assign write_data = mem_store ? read_reg_data1 : 32'bx;
assign write_addr = mem_store ? read_reg_data2 : 32'bx;

clk clk_ins (.clk(clk));
reset reset_ins (.reset(reset));

memory memory_ins (
	.clk(clk),
	.mem_write_enable(mem_store),	// STR
	.write_addr(write_addr),		// STR
	.write_data(write_data),		// STR
	.read_addr1(addr),				// FETCH
	.read_addr2(read_reg_data1), 	// LDR
	.read_data1(instruction), 		// FETCH
	.read_data2(read_data2) 		// LDR
);

program_counter program_counter_ins (
	.clk(clk),
	.reset(reset),
	.jump_en(jump_en),
	.jump_addr(jump_addr),
	.addr(addr)
);

control_unit control_unit_ins (
	.instruction(instruction),
	.alu_op(alu_op),
	.write_reg_sel(write_reg_sel),
	.reg_write_enable(reg_write_enable),
	.read_reg_sel1(read_reg_sel1),
	.read_reg_sel2(read_reg_sel2),
	.immidiate_val(immidiate_val),
	.immidiate(immidiate),
	.jump_en(jump_en),
	.jump_addr(jump_addr),
	.mem_load(mem_load),
	.mem_store(mem_store)
);

reg_file reg_file_ins (
	.clk(clk),
	.reset(reset),
	.reg_write_enable(reg_write_enable),
	.write_reg_sel(write_reg_sel),
	.write_reg_data(mem_load ? read_data2 : result),
	.read_reg_sel1(read_reg_sel1),
	.read_reg_sel2(read_reg_sel2),
	.read_reg_data1(read_reg_data1),
	.read_reg_data2(read_reg_data2)
);

alu alu_ins (
	.op1(read_reg_data1),
	.op2(immidiate ? immidiate_val : read_reg_data2),
	.alu_op(alu_op),
	.result(result),
	.zero(zero)
);

initial begin
	$dumpfile("sim.vcd");
	$dumpvars(0, processor);
	// $monitor("time = %3d addr = 0x%h, instruction = 0x%h",$time, addr, instruction);
	#100 $finish;
end

endmodule
