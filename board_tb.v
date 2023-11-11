module board_tb();

wire dht_pin;
output wire [6:0] ssd_pins;

board board_ins(
    .dht_pin(dht_pin),
    .ssd_pins(ssd_pins)
);

reg i, done, data_pin_buf;

initial begin
    done = 0;
    data_pin_buf = 1;

    #240063 done = 1;

    #20 data_pin_buf = 0;

    #80 data_pin_buf = 1;
    #80 data_pin_buf = 0;

    for (i = 0; i < 40; i = i + 1) begin
      #50 data_pin_buf = 1;
      #25 data_pin_buf = 0;

      #50 data_pin_buf = 1;
      #70 data_pin_buf = 0;
    end
    #10 $finish;
  end

  assign dht_pin = done ? data_pin_buf : 1'bz;

    initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, board_tb);
  end

endmodule
