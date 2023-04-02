`timescale 1ns / 1ps

module SignExtension32b (
  /****** Inputs ******/
  currentInstruction,
  extensionCtrl,  // control signal for the type of extension [0 - Extn16, 1 - Extn26]

  /****** Outputs ******/
  immediateValue_32b  // second operand to ALU
);

  input [31:0] currentInstruction;
  input extensionCtrl;
  output [31:0] immediateValue_32b;

  wire [15:0] inputValue_16b; // immediate value from R-I/R-dyadic instructions
  wire [25:0] inputValue_26b; // immediate value from J-type instructions

  assign inputValue_16b = currentInstruction[15:0];
  assign inputValue_26b = currentInstruction[25:0];

  assign immediateValue_32b = (extensionCtrl == 1'b1) ? {{6{inputValue_26b[25]}}, inputValue_26b} : {{16{inputValue_16b[15]}}, inputValue_16b};

endmodule
