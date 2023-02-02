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

  reg [31:0] regFile [0:7];

  wire [31:0] RE1;
  wire [31:0] RE2;

  integer i, j;

  decoder_3x8 D1 (regSource_1[2:0], RE1);
  decoder_3x8 D2 (regSource_2[2:0], RE2);

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

module decoder_3x8 (
  b,
  o
);
  input [2:0] b;
  output [7:0] o;
  
  always @(b) begin
    case(b)
      3'b000: o = 8'b00000001;
      3'b001: o = 8'b00000010;
      3'b010: o = 8'b00000100;
      3'b011: o = 8'b00001000;
      3'b100: o = 8'b00010000;
      3'b101: o = 8'b00100000;
      3'b110: o = 8'b01000000;
      3'b111: o = 8'b10000000;
      default: o = 8'b00000000;
    endcase
  end
endmodule

module decoder_5x32 (
  a,
  out
  );
  input [4:0] a;
  output reg [31:0] out;
  
  always @(a) begin
    case(a)
      5'b00000: out = 1;
      5'b00001: out = 2;
      5'b00010: out = 4;
      5'b00011: out = 8;
      
      5'b00100: out = 16;
      5'b00101: out = 32;
      5'b00110: out = 64;
      5'b00111: out = 128;
      
      5'b01000: out = 256;
      5'b01001: out = 512;
      5'b01010: out = 1024;
      5'b01011: out = 2048;
      
      5'b01100: out = 4096;
      5'b01101: out = 8192;
      5'b01111: out = 32768;
      5'b01110: out = 16384;
      
      5'b10000: out = 65536;
      5'b10001: out = 131072;
      5'b10010: out = 262144;
      5'b10011: out = 524288;
      
      5'b10100: out = 1048576;
      5'b10101: out = 2097152;
      5'b10110: out = 4194304;
      5'b10111: out = 8388608;
      
      5'b11000: out = 16777216;
      5'b11001: out = 33554432;
      5'b11010: out = 67108864;
      5'b11011: out = 134217728;
      
      5'b11100: out = 268435456;
      5'b11101: out = 536870912;
      5'b11110: out = 32'b01000000000000000000000000000000;
      5'b11111: out = 32'b10000000000000000000000000000000;
      
      default: out = 32'b0;

    endcase  
  end
endmodule