module memory (
    input wire clk,
    input wire mem_write_enable,
    input wire [31:0] write_addr,
    input wire [31:0] write_data,
    input wire [31:0] read_addr1,
    input wire [31:0] read_addr2,
    input wire [39:0] dht_data_in,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2,
    output wire [3:0] ssd_data_out
);

  reg [31:0] mem[0:1023];
  integer i = 0;

  initial begin

    // $readmemb("memory.bin", mem);
    //				     IT			  RA   RD            RB    
    //mem[i++] <= 32'b1110_10_10_0000_0000_0000_0000_0000_0011;  //b +3
    // mem[i++] <= 32'b1110_00_0_0100_0_0001_0000_00000000_0011;  //add r0, r1, r3
    // mem[i++] <= 32'b1110_00_0_1100_0_0010_0100_00000000_0001;  //orr r4, r2, r1
    // mem[i++] <= 32'b1110_01_1_0000_1_0101_0000_10101010_0000;  //ldr r0, [r5]
    // mem[i++] <= 32'b1110_01_1_0000_0_0011_0000_10101010_0000;  //str r0, [r3]
    // mem[i++] <= 32'b1110_00_0_0100_0_0000_0000_00000000_0011;  //add r0, r0, r3
    // mem[i++] <= 32'b1110_10_10_1111_1111_1111_1111_1111_1100;  //b -3
    // mem[i++] <= 32'd10;

    // mem[i++] <= 32'b1110_00_1_0100_0_0000_0000_0000_00001010;  //add r0, r0, #10
    // mem[i++] <= 32'b1110_00_1_0100_0_0001_0001_0000_00001011;  //add r1, r1, #11
    // mem[i++] <= 32'b1110_00_1_0100_0_0010_0010_0000_00001100;  //add r2, r2, #12

    mem[i++] <= 32'b1110_01_0_0000_1_0000_0000_00000000_1010;  //ldr r0, #10
    mem[i++] <= 32'b1110_01_0_0000_1_0000_0001_00000000_1011;  //ldr r1, #11
    mem[i++] <= 32'b1110_00_0_0100_0_0000_0000_00000000_0001;  //add r0, r0, r1
    mem[i++] <= 32'b1110_01_0_0000_0_0010_0000_00000000_1100;  //str r0, #12
    mem[i++] <= 32'b1110_01_0_0000_1_0010_0000_00000000_1100;  //ldr r0, #12

    mem[10] = 32'd10;
    mem[11] = 32'd20;
  end

  always @(posedge clk) begin
    if (mem_write_enable) begin
      mem[write_addr] <= write_data;
    end
  end

  always @(dht_data_in) begin
    mem[1001] <= {12'b0, dht_data_in};
  end

  assign read_data1 = mem[read_addr1];
  assign read_data2 = mem[read_addr2];
  assign ssd_data_out = mem[1000][3:0];

endmodule
