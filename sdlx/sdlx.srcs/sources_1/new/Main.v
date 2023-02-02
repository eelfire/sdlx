`timescale 1ns / 1ps

module Main (
	/****** Inputs ******/
  clk,  // board clock (100 MHz)
  reset,  // input reset
  switches,
  pushButtons,

  /****** Outputs ******/
  leds
);
	
	input clk;
	input reset;
	input [15:0] switches;
	input [2:0] pushButtons;
	output [15:0] leds;
  
	wire [2:0] pushButtonsDebounced;
  wire processorClk;
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

  assign processorClk = pushButtonsDebounced[2];

  Input in (clk, pushButtons, pushButtonsDebounced);

  InstructionRegister ir (switches, pushButtonsDebounced[0], pushButtonsDebounced[1], currentInstruction);

  ControlUnit cu (currentInstruction, regFileReset, regFileWriteEnable, regDestSelect, regSourceSelect_1, regSourceSelect_2, ALUInstructionCode, selectImmediate);

  RegFile rf (processorClk, regFileReset, regFileWriteEnable, regDestSelect, regSourceSelect_1, regSourceSelect_2, ALUOutput, regFileDataOut_1, regFileDataOut_2);

  SignExtension32b se (currentInstruction[15:0], instructionImmediateValue);

  ALU alu (regFileDataOut_1, ALUOperand_2, ALUInstructionCode, carryOut, ALUOutput);

  // Second Operand Select for ALU
  Mux #(.BIT_WIDTH(32)) m0 (selectImmediate, instructionImmediateValue, regFileDataOut_2, ALUOperand_2);

  Output out (clk, ALUOutput, leds);

endmodule
