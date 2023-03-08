`timescale 1ns / 1ps

module Output (
  /****** Inputs ******/
  data, // actual bits to display (32)
  control, // signal to toggle displaying MSB and LSB bits

  /****** Outputs ******/
  leds // leds to display the bits (16)
);

  input [31:0] data;
  input control;
  output [15:0] leds;

  reg toggle;

  always @(posedge control) begin
    // adding 1 to single bit signal toggles it
    toggle <= toggle + 1;
  end

  assign leds = toggle ? data[31:16] : data[15:0];

endmodule
