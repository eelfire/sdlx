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

  wire processorClk;
  wire globalReset;
  wire outputToggle;
  assign processorClk = pushButtonsDebounced[2];
  assign globalReset  = pushButtonsDebounced[3];
  assign outputToggle = pushButtonsDebounced[4];

  // PC
  wire [29:0] incrementedPC;
  wire [29:0] currentPC;

  // Memory
  wire [31:0] nextInstruction;
  wire [31:0] memoryOut;

  // Memory Lane Switch
  wire [31:0] alignedMemDataIn;
  wire [31:0] alignedMemDataOut;

  // Data Convert
  wire [31:0] convertedMemDataOut;

  // Control Unit
  wire resetPC;
  wire selectNewPC;
  wire [3:0] memoryRWCtrl;
  wire memDataSignExtCntrl;
  wire [1:0] memDataFetchSize;
  wire resetIR;
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

  // Instruction Register
  wire [31:0] currentInstruction;

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
  wire [1:0] laneControl;
  assign ALUOutPC = ALUOut[31:2];
  assign laneControl = ALUOut[1:0];

  // Muxes
  wire [31:0] muxDataOut;
  wire [31:0] regFileDataIn;
  wire [31:0] ALUOperand1;
  wire [31:0] ALUOperand2;

  Input in(clk, pushButtons, pushButtonsDebounced);

  PC pc(processorClk, resetPC, selectNewPC, ALUOutPC, incrementedPC, currentPC);

  // Port A - Instructions, Port B - Data
  Memory mem(
    .BRAM_PORTA_0_addr({ currentPC, 2'b00 }),
    .BRAM_PORTA_0_clk(clk),
    .BRAM_PORTA_0_din(32'b0),
    .BRAM_PORTA_0_dout(nextInstruction),
    .BRAM_PORTA_0_en(1'b1),
    .BRAM_PORTA_0_we(4'b0),
    .BRAM_PORTB_0_addr(ALUOut),
    .BRAM_PORTB_0_clk(clk),
    .BRAM_PORTB_0_din(alignedMemDataIn),
    .BRAM_PORTB_0_dout(memoryOut),
    .BRAM_PORTB_0_en(1'b1),
    .BRAM_PORTB_0_we(memoryRWCtrl)
  );

  MemLaneSwitch mls(laneControl, regFileDataOut_2, memoryOut, alignedMemDataIn, alignedMemDataOut);

  DataConvert dconvt(memDataSignExtCntrl, memDataFetchSize, alignedMemDataOut, convertedMemDataOut);

  InstructionRegister ir(processorClk, resetIR, nextInstruction, currentInstruction);

  ControlUnit cu(globalReset, currentInstruction, isRS1Zero, laneControl, resetPC, selectNewPC, memoryRWCtrl, memDataSignExtCntrl, memDataFetchSize, resetIR, extensionCtrl, regFileReset, regFileWriteEnable, regFileDest, regFileSource_1, regFileSource_2, ALUInstructionCode, regFileDinSel_1, regFileDinSel_2, oprnd1Sel, oprnd2Sel);

  SignExtension32b ext(currentInstruction, extensionCtrl, immediateValue_32b);

  RegFile regFile(processorClk, regFileReset, regFileWriteEnable, regFileDest, regFileSource_1, regFileSource_2, regFileDataIn, regFileDataOut_1, regFileDataOut_2);

  ALU alu(ALUOperand1, ALUOperand2, ALUInstructionCode, carryOut, ALUOut);

  Output out(ALUOut, outputToggle, leds);

  // Muxes for RegFile Inputs
  Mux #(.BIT_WIDTH(32)) m_0(regFileDinSel_1, ALUOut, convertedMemDataOut, muxDataOut);

  Mux #(.BIT_WIDTH(32)) m_1(regFileDinSel_2, muxDataOut, {incrementedPC, 2'b00}, regFileDataIn);

  // Muxes for ALU Inputs
  Mux #(.BIT_WIDTH(32)) m_2(oprnd1Sel, regFileDataOut_1, {currentPC, 2'b00}, ALUOperand1);

  Mux #(.BIT_WIDTH(32)) m_3(oprnd2Sel, regFileDataOut_2, immediateValue_32b, ALUOperand2);

endmodule
