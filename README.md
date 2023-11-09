ARM 32 bit cpu implemented using verilog.

## Run & Simulate using iverilog & gtkwave.

```bash
iverilog -o output alu.v control_unit.v memory.v program_counter.v processor.v reg_file.v clk.v reset.v
vvp output
gtkwave sim.vcd
```
