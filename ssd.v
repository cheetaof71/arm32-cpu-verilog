module ssd (
    input wire [3:0] ssd_data,  // 4-bit input ssd_data
    output reg [6:0] ssd_pins  // 7-bit output for the segments
);

  always @(ssd_data) begin
    case (ssd_data)
      4'b0000: ssd_pins = 7'b1000000;  // Display 0
      4'b0001: ssd_pins = 7'b1111001;  // Display 1
      4'b0010: ssd_pins = 7'b0100100;  // Display 2
      4'b0011: ssd_pins = 7'b0110000;  // Display 3
      4'b0100: ssd_pins = 7'b0011001;  // Display 4
      4'b0101: ssd_pins = 7'b0010010;  // Display 5
      4'b0110: ssd_pins = 7'b0000010;  // Display 6
      4'b0111: ssd_pins = 7'b1111000;  // Display 7
      4'b1000: ssd_pins = 7'b0000000;  // Display 8
      4'b1001: ssd_pins = 7'b0010000;  // Display 9
      default: ssd_pins = 7'b0000000;  // Turn off display if input is not valid
    endcase
  end

endmodule
