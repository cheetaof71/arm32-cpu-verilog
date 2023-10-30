module memory (
    input wire clk,
    input wire mem_write_enable,
    input wire [31:0] write_addr,
    input wire [31:0] write_data,
    input wire [31:0] read_addr1,
    input wire [31:0] read_addr2,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

  reg [31:0] mem[0:1023];
  integer i = 0;

  initial begin
    
    // $readmemb("memory.bin", mem);
    //				     IT			  RA   RD            RB    
    //mem[i++] <= 32'b1110_10_10_0000_0000_0000_0000_0000_0011;  //b +3
    // mem[i++] <= 32'b1110_00_0_0100_0_0001_0000_00000000_0011;  //add r0, r1, r3
    // mem[i++] <= 32'b1110_00_0_1100_0_0010_0100_00000000_0001;  //orr r4, r2, r1
    // mem[i++] <= 32'b1110_01_1_0000_1_0101_0000_10101010_xxxx;  //ldr r0, [r5]
    // mem[i++] <= 32'b1110_01_1_0000_0_0011_0000_10101010_xxxx;  //str r0, [r3]
    // mem[i++] <= 32'b1110_00_0_0100_0_0000_0000_00000000_0011;  //add r0, r0, r3
    // mem[i++] <= 32'b1110_10_10_1111_1111_1111_1111_1111_1100;  //b -3
    // mem[i++] <= 32'd10;

    mem[i++] <= 32'b1110_01_1_0000_1_0000_0000_xxxxxxxx_xxxx;  //ldr r0, [r0]
    mem[i++] <= 32'b1110_01_1_0000_1_0001_0001_xxxxxxxx_xxxx;  //ldr r1, [r1]
    mem[i++] <= 32'b1110_00_0_0100_x_0000_0000_00000000_0001;  //add r0, r0, r1
    mem[i++] <= 32'b1110_01_1_0000_0_0010_0000_xxxxxxxx_xxxx;  //str r0, [r2]
    mem[i++] <= 32'b1110_01_1_0000_1_0000_0000_xxxxxxxx_xxxx;  //ldr r0, [r2]

    mem[10] = 32'd10;
    mem[11] = 32'd20;
    mem[12] = 32'd15;
  end

  always @(posedge clk) begin
    if (mem_write_enable) begin
      mem[write_addr] <= write_data;
    end
  end

  assign read_data1 = mem[read_addr1];
  assign read_data2 = mem[read_addr2];

endmodule
