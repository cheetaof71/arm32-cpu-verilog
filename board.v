module board (
    inout dht_pin,
    output wire [6:0] ssd_pins
);

  wire clk;
  wire reset;
  wire [31:0] instruction;
  wire [31:0] read_data2;
  wire [31:0] addr;
  wire [31:0] read_addr2;
  wire [31:0] write_addr;
  wire [31:0] write_data;
  wire mem_write_enable;

  wire [3:0] ssd_data;
  wire [39:0] dht_data;

  clk clk_ins (.clk(clk));
  reset reset_ins (.reset(reset));

  processor processor_ins (
      .clk(clk),
      .reset(reset),
      .instruction(instruction),
      .read_data2(read_data2),
      .addr(addr),
      .read_addr2(read_addr2),
      .write_addr(write_addr),
      .write_data(write_data),
      .mem_write_enable(mem_write_enable)
  );

  memory memory_ins (
      .clk             (clk),
      .mem_write_enable(mem_write_enable),  // STR
      .write_addr      (write_addr),        // STR
      .write_data      (write_data),        // STR
      .read_addr1      (addr),              // FETCH
      .read_addr2      (read_addr2),        // LDR
      .dht_data_in     (dht_data),          // DHT22
      .read_data1      (instruction),       // FETCH
      .read_data2      (read_data2),        // LDR
      .ssd_data_out    (ssd_data)           // SSD
  );

  ssd ssd_ins (
      .ssd_data(ssd_data),
      .ssd_pins(ssd_pins)
  );

  DHT22 DHT22_ins (
      .clk(clk),
      .rst(rst),
      .dht_pin(dht_pin),
      .dht_data(dht_data)
  );

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, board);
    // $monitor("time = %3d addr = 0x%h, instruction = 0x%h",$time, addr, instruction);
    #100 $finish;
  end


endmodule
