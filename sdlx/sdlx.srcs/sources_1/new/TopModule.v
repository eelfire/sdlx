`timescale 1ns / 1ps

module TopModule (
  clk,
  halfInstr,
  pushButton1,
  ledOutput // bits to be displayed on LEDs
);
  input clk;
  input [15:0] halfInstr;
  input pushButton1;
  output [15:0] ledOutput;

  wire reset;
  wire writeEnable;
  wire [31:0] dataIn;
  wire [31:0] dataOut_1;
  wire [31:0] dataOut_2;
  wire [31:0] IR;

  Reg_File R (clk, reset, writeEnable, IR[15:11], IR[20:16], IR[25:21]);


endmodule