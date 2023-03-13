`timescale 1ns / 1ps

module Main (
  /****** Inputs ******/
  clk,
  switches,
  pushButtons,

  /****** Outputs ******/
  leds
);

  input clk;
  input [15:0] switches;
  input [4:0] pushButtons;
  output [15:0] leds;

  // Input
  wire [4:0] pushButtonsDebounced;
  wire [31:0] userInstruction;

  wire processorClk;
  wire globalReset;
  wire outputToggle;
  assign processorClk = pushButtonsDebounced[2];
  assign globalReset  = pushButtonsDebounced[3];
  assign outputToggle = pushButtonsDebounced[4];

  // Control Unit
  wire resetPC;
  wire selectNewPC;
  wire extensionCtrl;
  wire regFileReset;
  wire regFileWriteEnable;
  wire [4:0] regFileDest;
  wire [4:0] regFileSource_1;
  wire [4:0] regFileSource_2;
  wire [5:0] ALUInstructionCode;
  wire regFileDinSel_1;
  wire regFileDinSel_2;
  wire oprnd1Sel;
  wire oprnd2Sel;
  wire memoryReadCtrl;

  // PC
  wire [29:0] incrementedPC;
  wire [29:0] currentPC;

  // SignExtension32b
  wire [31:0] immediateValue_32b;

  // RegFile
  wire [31:0] regFileDataOut_1;
  wire [31:0] regFileDataOut_2;

  wire isRS1Zero;
  assign isRS1Zero = (regFileDataOut_1 == 32'b0);

  // ALU
  wire carryOut;
  wire [31:0] ALUOut;
  wire [29:0] ALUOutPC;
  assign ALUOutPC = ALUOut[31:2];

  // Muxes
  wire [31:0] muxDataOut;
  wire [31:0] regFileDataIn;
  wire [31:0] ALUOperand1;
  wire [31:0] ALUOperand2;

  // Memory
  wire [31:0] memoryOut;
  assign memoryOut = 32'b0;

  Input in(clk, switches, pushButtons, pushButtonsDebounced, userInstruction);

  ControlUnit cu(globalReset, userInstruction, isRS1Zero, resetPC, selectNewPC, extensionCtrl, regFileReset, regFileWriteEnable, regFileDest, regFileSource_1, regFileSource_2, ALUInstructionCode, regFileDinSel_1, regFileDinSel_2, oprnd1Sel, oprnd2Sel, memoryReadCtrl);

  PC pc(processorClk, resetPC, selectNewPC, ALUOutPC, incrementedPC, currentPC);

  SignExtension32b ext(userInstruction, extensionCtrl, immediateValue_32b);

  RegFile regFile(processorClk, regFileReset, regFileWriteEnable, regFileDest, regFileSource_1, regFileSource_2, regFileDataIn, regFileDataOut_1, regFileDataOut_2);

  ALU alu(ALUOperand1, ALUOperand2, ALUInstructionCode, carryOut, ALUOut);

  Output out(ALUOut, outputToggle, leds);

  // Muxes for RegFile Inputs
  Mux #(.BIT_WIDTH(32)) m_0 (regFileDinSel_1, ALUOut, memoryOut, muxDataOut);

  Mux #(.BIT_WIDTH(32)) m_1 (regFileDinSel_2, muxDataOut, {incrementedPC, 2'b00}, regFileDataIn);

  // Muxes for ALU Inputs
  Mux #(.BIT_WIDTH(32)) m_2 (oprnd1Sel, regFileDataOut_1, {currentPC, 2'b00}, ALUOperand1);

  Mux #(.BIT_WIDTH(32)) m_3 (oprnd2Sel, regFileDataOut_2, immediateValue_32b, ALUOperand2);

endmodule
