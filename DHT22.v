module DHT22 (
    input wire clk,
    input wire rst,
    inout wire dht_pin,
    output reg [39:0] dht_data
);
  reg pin_buf;
  reg flag;
  reg hg;
  reg [3:0] state;
  reg [32:0] timer;
  reg [6:0] bit_count;
  reg [39:0] shift_reg;

  assign dht_pin = (state == REQUEST) ? pin_buf : 1'bz;

  parameter IDLE = 3'b000, REQUEST = 3'b001, RESPONSE = 3'b010, READ_DATA = 3'b011, NOP = 3'b100;

  always @(rst) begin
    state <= IDLE;
    bit_count <= 6'b0;
    shift_reg <= 40'b0;
    timer <= 32'd100_000;
    dht_data <= 40'b0;
    pin_buf <= 1;
  end

  always @(posedge clk or posedge rst) begin
    case (state)
      IDLE: begin
        if (timer == 32'b0) begin
          timer <= 32'd20_030;
          state <= REQUEST;
        end else begin
          timer <= timer - 1;
        end
      end
      REQUEST: begin
        if (timer == 32'b0) begin
          timer <= 32'b0011;
          state <= RESPONSE;
        end else if (timer <= 32'd30) begin
          flag <= 1;
          pin_buf <= 1;
          timer <= timer - 1;
        end else begin
          pin_buf <= 0;
          timer <= timer - 1;
        end
      end
      RESPONSE: begin
        if (timer == 32'b0) begin
          hg <= 0;
          state <= READ_DATA;
        end else if (dht_pin != flag) begin
          flag  <= dht_pin;
          timer <= timer - 1;
        end
      end
      READ_DATA: begin
        if (bit_count == 6'b101000) begin
          dht_data  <= shift_reg;
          state <= NOP;
        end
        if (dht_pin != flag && !hg) begin
          hg   <= 1'b1;
          flag <= dht_pin;
        end
        if (hg) begin
          timer <= timer + 1;
        end
        if (dht_pin !== flag && hg) begin
          hg <= 1'b0;
          flag <= dht_pin;
          bit_count <= bit_count + 1;

          if (timer > 18) begin
            shift_reg <= (shift_reg << 1) | 40'b1;
            timer <= 32'b0;
          end else begin
            shift_reg <= (shift_reg << 1) | 40'b0;
            timer <= 32'b0;
          end
        end
      end
      NOP: begin
        // 
      end
    endcase
  end

  initial begin
    // $monitor("Time=%t, dht_pin=%d, state=%d, timer=%d", $time, dht_pin, state, timer);
    // $monitor("C: Time=%t, dht_pin=%d", $time, dht_pin);
  end

endmodule

/*
module DHT22_tb;

  integer i;

  reg clk;
  reg rst;
  wire dht_pin;
  wire [39:0] data_out;
  wire valid_out;

  reg done;
  reg data_pin_buf_s;

  // Instantiate the DHT22 module
  DHT22 uut (
      .clk(clk),
      .rst(rst),
      .dht_pin(dht_pin),
      .dht_data(data_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  // Test scenario
  initial begin
    // Initialize inputs
    rst  = 1;
    done = 0;
    #10 rst = 0;
    data_pin_buf_s = 1;

    #240063 done = 1;
    // $display("Time=%d, hi\n", $time);

    #20 data_pin_buf_s = 0;

    #80 data_pin_buf_s = 1;
    #80 data_pin_buf_s = 0;

    for (i = 0; i < 40; i = i + 1) begin
      #50 data_pin_buf_s = 1;
      #25 data_pin_buf_s = 0;

      #50 data_pin_buf_s = 1;
      #70 data_pin_buf_s = 0;
    end
    #10 $finish;
  end

  assign dht_pin = done ? data_pin_buf_s : 1'bz;

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, DHT22_tb);
  end

  initial begin
    $monitor("S: Time=%t, dht_pin=%d", $time, dht_pin);
  end

endmodule
*/