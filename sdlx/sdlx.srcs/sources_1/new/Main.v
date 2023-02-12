`timescale 1ns / 1ps

module Main (
	/****** Inputs ******/
  clk,  // board clock (100 MHz)
  switches,
  pushButtons,

  /****** Outputs ******/
  leds
);
	
	input clk;
	input [15:0] switches;
	input [3:0] pushButtons;
	output [15:0] leds;
  
  wire [3:0] pushButtonsDebounced;
  wire processorClk;
  wire globalReset;
  wire [31:0] currentInstruction;

  // Control Signals
  wire regFileReset;
  wire regFileWriteEnable;
  wire [4:0] regDestSelect;
  wire [4:0] regSourceSelect_1;
  wire [4:0] regSourceSelect_2;
  wire [31:0] regFileDataIn;
  wire [31:0] regFileDataOut_1;
  wire [31:0] regFileDataOut_2;

  wire [5:0] ALUInstructionCode;
  wire selectImmediate;
  wire [31:0] instructionImmediateValue;
  wire [31:0] ALUOutput;
  wire [31:0] ALUOperand_2;
  wire carryOut;
  wire [31:0] userInstruction;

  assign processorClk = pushButtonsDebounced[2];
  assign globalReset = pushButtonsDebounced[3];

  Input in (clk, switches, pushButtons, pushButtonsDebounced, userInstruction);

  InstructionRegister ir (processorClk, globalReset, userInstruction, currentInstruction);

  ControlUnit cu (currentInstruction, globalReset, regFileReset, regFileWriteEnable, regDestSelect, regSourceSelect_1, regSourceSelect_2, ALUInstructionCode, selectImmediate);

  RegFile rf (processorClk, regFileReset, regFileWriteEnable, regDestSelect, regSourceSelect_1, regSourceSelect_2, ALUOutput, regFileDataOut_1, regFileDataOut_2);

  SignExtension32b se (currentInstruction[15:0], instructionImmediateValue);

  ALU alu (regFileDataOut_1, ALUOperand_2, ALUInstructionCode, carryOut, ALUOutput);

  // Second Operand Select for ALU
  Mux #(.BIT_WIDTH(32)) m0 (selectImmediate, instructionImmediateValue, regFileDataOut_2, ALUOperand_2);

  Output out (clk, ALUOutput, leds);

endmodule
