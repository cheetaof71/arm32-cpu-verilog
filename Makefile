all:
	rm -rf output *.vcd
	iverilog -o output *.v
	vvp output
clean:
	rm -rf output *.vcd
