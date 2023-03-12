`timescale 1ns / 1ps

// Control Unit testbench
module tb();
      /****** Inputs ******/
  reg globalReset;
  reg [31:0] currentInstruction;
  reg isRS1Zero;

  /****** Outputs ******/
  wire resetPC;
  wire selectNewPC; // 0 - increment, 1 - set from input data
  wire extensionCtrl; // 0 - Extn16, 1 - Extn26
  wire regFileReset;
  wire regFileWriteEnable;
  wire [4:0] regFileDest;
  wire [4:0] regFileSource_1;
  wire [4:0] regFileSource_2;
  wire [5:0] ALUInstructionCode;
  wire regFileDinSel_1; // 0 - ALUOut, 1 - memoryOut
  wire regFileDinSel_2; // 0 - (ALU | Memory Out), 1 - Incremented PC
  wire oprnd1Sel; // 0 - RS1, 1 - current PC
  wire oprnd2Sel; // 0 - RS2, 1 - immediate value
  wire memoryReadCtrl;

  ControlUnit controlUnit (
    globalReset,
    currentInstruction,
    isRS1Zero,
    resetPC,
    selectNewPC,
    extensionCtrl,
    regFileReset,
    regFileWriteEnable,
    regFileDest,
    regFileSource_1,
    regFileSource_2,
    ALUInstructionCode,
    regFileDinSel_1,
    regFileDinSel_2,
    oprnd1Sel,
    oprnd2Sel,
    memoryReadCtrl
  );

    // R triadic
    // 000000 00000 00000 00000 00000 000000
    // opcode RS1   RS2   RD    0     FuncCode


    // R-I triadic
    // 0xxxxx 00000 00000 0000000000000000
    // opcode RS1   RD    Immediate Const


    // R dyadic
    // 1000xx 00000 00000 0000000000000000
    // opcode RS1   0     signed offset


    // J
    // 11000x 00000000000000000000000000
    // opcode signed offset

  initial begin
    globalReset = 1;
    currentInstruction = 0;
    isRS1Zero = 0;
    #10;
    globalReset = 0;
    #10;
    
    // R type triadic
    currentInstruction = 32'b000000_00001_00101_00010_00000_000001; #10;    // ADD R1,R5,R2
    currentInstruction = 32'b000000_00001_00010_00011_00000_000001; #10;    // ADD R1,R2,R3

    // R-I type triadic
    currentInstruction = 32'b001011_10100_10110_0000000000111100; #10;    // ADDI R20,R22,60
    currentInstruction = 32'b000101_10110_00001_1111111111111100; #10;    // XORI R22,R1,65532

    // R type diadic
    currentInstruction = 32'b100000_10100_00000_0000000000000010; #10;    // LB R20,2(R0)

    // J type
    currentInstruction = 32'b110000_0000000000000000000000001; #10;    // J 1

    $finish;
  end
endmodule
