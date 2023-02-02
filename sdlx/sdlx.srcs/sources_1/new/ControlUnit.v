`timescale 1ns / 1ps

module ControlUnit (
	/****** Inputs ******/
  currentInstruction,  // user-input instruction from IR
	
	/****** Outputs ******/
  regFileReset,
  regFileWriteEnable,
  regDestSelect,
  regSourceSelect_1,
  regSourceSelect_2,
  ALUInstructionCode,
  selectImmediate
);

  input [31:0] currentInstruction;
  // regFile control signals
  output reg regFileReset;
  output reg regFileWriteEnable;
  output [4:0] regDestSelect;
  output [4:0] regSourceSelect_1;
  output [4:0] regSourceSelect_2;

  reg selectRegDest; // mux select line for R-I | R-triadic
  
  assign regSourceSelect_1 = currentInstruction[25:21];
  assign regSourceSelect_2 = currentInstruction[20:16];

  Mux #(.BIT_WIDTH(5)) m0 (selectRegDest, currentInstruction[20:16], currentInstruction[15:11], regDestSelect); // Destination Register Select


  // ALU Control Signals
  output [5:0] ALUInstructionCode;

  reg selectFunctionCode; // mux select line for func | opcode
  wire functionCode;
  wire operationCode;
  
  assign functionCode = currentInstruction[5:0];
  assign operationCode = currentInstruction[31:26];

  // Function Code Select
  Mux #(.BIT_WIDTH(6)) m1 (selectFunctionCode, functionCode, operationCode, ALUInstructionCode);

  // Immediate Value Control Signals
  output reg selectImmediate;

  always @(currentInstruction) begin
  	regFileReset = 0;
  	regFileWriteEnable = 1;

  	if(|currentInstruction[31:26]) begin // unary OR to check if it is != 0
  		selectImmediate <= 1;
  		selectFunctionCode <= 0;
  		selectRegDest <= 1;
  	end
  	else begin
  		selectImmediate <= 0;
  		selectFunctionCode <= 1;
  		selectRegDest <= 0;
  	end
  end

endmodule