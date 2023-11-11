module DHT22 (
    input wire clk,
    input wire rst,
    inout wire dht_pin,
    output reg [31:0] dht_data
);
  reg pin_buf;
  reg flag;
  reg hg;
  reg [3:0] state;
  reg [32:0] timer;
  reg [6:0] bit_count;
  reg [39:0] shift_reg;

  assign dht_pin = (state == REQUEST) ? pin_buf : 1'bz;

  reg IDLE = 3'b000, REQUEST = 3'b001, RESPONSE = 3'b010, READ_DATA = 3'b011;

  always @(rst) begin
    state <= IDLE;
    bit_count <= 6'b0;
    shift_reg <= 40'b0;
    timer <= 32'd1_000_000;
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
          timer   <= timer - 1;
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
          dht_data <= shift_reg[39:7];
          timer <= 32'd5_000_000;
          state <= IDLE;
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
    endcase
  end

endmodule