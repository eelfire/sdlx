`timescale 1ns / 1ps

module RegFile (
  clk,  // input clock
  reset,  // active high reset the regFile
  writeEnable, // Write enable
  regDest, // destination address
  regSource_1,  // Source address 1
  regSource_2,  // Source address 2
  dataIn,
  dataOut_1,
  dataOut_2
);

  input clk;
  input reset;
  input writeEnable;
  input [4:0] regDest;
  input [4:0] regSource_1;
  input [4:0] regSource_2;
  input [31:0] dataIn;
  output [31:0] dataOut_1;
  output [31:0] dataOut_2;

  wire [31:0] regFile [0:7];

  wire [31:0] RE1;
  wire [31:0] RE2;
  wire [31:0] RD;

  genvar i, j;

  Decoder_3x8 D1 (regSource_1[2:0], RE1);
  Decoder_3x8 D2 (regSource_2[2:0], RE2);
  Decoder_5x32 D3 (regDest, RD);

  generate
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 31; j = j + 1) begin
        bufif1 B1 (dataOut_1[j], regFile[i][j], RE1[j]);
        bufif1 B2 (dataOut_2[j], regFile[i][j], RE2[j]);    
        bufif1 Bin (regFile[i][j], dataIn[j], (writeEnable & RD[j]));    
      end
    end
  endgenerate

endmodule


module Decoder_3x8 (
  in,
  out
);
  
  input [2:0] in;
  output reg [7:0] out;
  
  always @(in) begin
    case(in)
      3'b000 : out = 8'b00000001;
      3'b001 : out = 8'b00000010;
      3'b010 : out = 8'b00000100;
      3'b011 : out = 8'b00001000;
      3'b100 : out = 8'b00010000;
      3'b101 : out = 8'b00100000;
      3'b110 : out = 8'b01000000;
      3'b111 : out = 8'b10000000;
      default: out = 8'b00000000;
    endcase
  end

endmodule


module Decoder_5x32 (
  in,
  out
);

  input [4:0] in;
  output reg [31:0] out;

  always @(in) begin
    case(in)
      5'b00000: out = 32'b00000000000000000000000000000001;
      5'b00001: out = 32'b00000000000000000000000000000010;
      5'b00010: out = 32'b00000000000000000000000000000100;
      5'b00011: out = 32'b00000000000000000000000000001000;
      5'b00100: out = 32'b00000000000000000000000000010000;
      5'b00101: out = 32'b00000000000000000000000000100000;
      5'b00110: out = 32'b00000000000000000000000001000000;
      5'b00111: out = 32'b00000000000000000000000010000000;
      5'b01000: out = 32'b00000000000000000000000100000000;
      5'b01001: out = 32'b00000000000000000000001000000000;
      5'b01010: out = 32'b00000000000000000000010000000000;
      5'b01011: out = 32'b00000000000000000000100000000000;
      5'b01100: out = 32'b00000000000000000001000000000000;
      5'b01101: out = 32'b00000000000000000010000000000000;
      5'b01110: out = 32'b00000000000000000100000000000000;
      5'b01111: out = 32'b00000000000000001000000000000000;
      5'b10000: out = 32'b00000000000000010000000000000000;
      5'b10001: out = 32'b00000000000000100000000000000000;
      5'b10010: out = 32'b00000000000001000000000000000000;
      5'b10011: out = 32'b00000000000010000000000000000000;
      5'b10100: out = 32'b00000000000100000000000000000000;
      5'b10101: out = 32'b00000000001000000000000000000000;
      5'b10110: out = 32'b00000000010000000000000000000000;
      5'b10111: out = 32'b00000000100000000000000000000000;
      5'b11000: out = 32'b00000001000000000000000000000000;
      5'b11001: out = 32'b00000010000000000000000000000000;
      5'b11010: out = 32'b00000100000000000000000000000000;
      5'b11011: out = 32'b00001000000000000000000000000000;
      5'b11100: out = 32'b00010000000000000000000000000000;
      5'b11101: out = 32'b00100000000000000000000000000000;
      5'b11110: out = 32'b01000000000000000000000000000000;
      5'b11111: out = 32'b10000000000000000000000000000000;
      default:  out = 32'b00000000000000000000000000000000;
    endcase
  end

endmodule
