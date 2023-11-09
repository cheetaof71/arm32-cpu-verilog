all:
	rm -rf output *.vcd
	iverilog -o output alu.v control_unit.v memory.v program_counter.v processor.v reg_file.v clk.v reset.v
	vvp output
clean:
	rm -rf output *.vcd
