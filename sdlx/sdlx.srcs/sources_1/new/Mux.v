`timescale 1ns / 1ps

module Mux #(parameter BIT_WIDTH = 6)(
  /****** Inputs ******/
  sel,
  A,
  B,

  /****** Outputs ******/
  out
);

  input sel;
  input [BIT_WIDTH-1:0] A;
  input [BIT_WIDTH-1:0] B;
  output [BIT_WIDTH-1:0] out;

  assign out = (sel == 1'b0) ? A : B;

endmodule

module Mux_3x1 #(parameter BIT_WIDTH = 6)(
  /****** Inputs ******/
  sel,
  A,
  B,
  C,

  /****** Outputs ******/
  out
);

  input [1:0] sel;
  input [BIT_WIDTH-1:0] A;
  input [BIT_WIDTH-1:0] B;
  input [BIT_WIDTH-1:0] C;
  output reg [BIT_WIDTH-1:0] out;

  always @(sel) begin
    case (sel)
      2'b00: out = A;
      2'b01: out = B;
      2'b10: out = C;
      default: out = 1'bz;
    endcase
  end

endmodule
