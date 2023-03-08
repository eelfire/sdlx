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
  output [BIT_WIDTH-1:0] out;

  assign out = (sel == 2'b00) ? A : 1'bz;
  assign out = (sel == 2'b01) ? B : 1'bz;
  assign out = (sel == 2'b10) ? C : 1'bz;

endmodule
