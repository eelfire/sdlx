`timescale 1ns / 1ps

module ControlUnit (
  /****** Inputs ******/
  globalReset,
  currentInstruction,
  isRS1Zero,

  /****** Outputs ******/
  resetPC,
  selectNewPC, // 0 - increment, 1 - set from input data
  extensionCtrl, // 0 - Extn16, 1 - Extn26
  regFileReset,
  regFileWriteEnable,
  regFileDest,
  regFileSource_1,
  regFileSource_2,
  ALUInstructionCode,
  regFileDinSel_1, // 0 - ALUOut, 1 - memoryOut
  regFileDinSel_2, // 0 - (ALU | Memory Out), 1 - Incremented PC
  oprnd1Sel, // 0 - RS1, 1 - current PC
  oprnd2Sel, // 0 - RS2, 1 - immediate value
  memoryReadCtrl
);

  input globalReset;
  input [31:0] currentInstruction;
  input isRS1Zero;
  wire [5:0] operationCode;
  assign operationCode = currentInstruction[31:26];

  // PC
  output resetPC;
  output reg selectNewPC;

  assign resetPC = globalReset;

  // SignExtension32b
  output reg extensionCtrl;

  // RegFile
  output regFileReset;
  output reg regFileWriteEnable;
  output [4:0] regFileDest;
  output [4:0] regFileSource_1;
  output [4:0] regFileSource_2;

  assign regFileReset = globalReset;
  assign regFileSource_1 = currentInstruction[20:16];
  assign regFileSource_2 = currentInstruction[25:21];

  reg [1:0] regFileDestSel;

  Mux_3x1 #(.BIT_WIDTH(5)) rdSel (regFileDestSel, currentInstruction[15:11], currentInstruction[20:16], 5'b11111, regFileDest);

  // ALU
  output reg [5:0] ALUInstructionCode;

  // Muxes
  output reg regFileDinSel_1;
  output reg regFileDinSel_2;
  output reg oprnd1Sel;
  output reg oprnd2Sel;

  // Memory
  output reg memoryReadCtrl;

  // Control Signal generation
  always @(currentInstruction) begin
    if (operationCode[5] ==  1'b0) begin
      // 1st Half Instructions
      selectNewPC <= 1'b0;
      extensionCtrl <= 1'b0;
      regFileDinSel_2 <= 1'b0;
      oprnd1Sel <= 1'b0;

      if(|operationCode[4:0] == 1'b0) begin
        // R-type triadic
        regFileDinSel_1 = 1'b0;
        regFileWriteEnable <= 1'b1;
        regFileDestSel <= 2'b00;
        ALUInstructionCode <= currentInstruction[5:0];
        oprnd2Sel <= 1'b0;
        memoryReadCtrl <= 1'b0;
      end
      else begin
        // R-I type triadic
        regFileDestSel <= 2'b01;
        // selectFunctionCode <= 1'b1;
        oprnd2Sel <= 1'b1;

        if(operationCode < 6'b010100) begin
          // Non-memory operations
          regFileDinSel_1 = 1'b0;
          regFileWriteEnable <= 1'b1;
          ALUInstructionCode <= currentInstruction[31:26];
          memoryReadCtrl <= 1'b0;
        end
        else begin
          // Memory operations
          ALUInstructionCode <= 6'b000001; // Add

          if(operationCode[3] == 1'b0) begin
            // Store Instructions
            regFileDinSel_1 = 1'b0;
            regFileWriteEnable <= 1'b0;
            memoryReadCtrl <= 1'b0;
          end
          else begin
            // Load Instructions
            regFileDinSel_1 = 1'b1;
            regFileWriteEnable <= 1'b1;
            memoryReadCtrl <= 1'b1;
          end
        end
      end
    end
    else begin
      // 2nd Half Instructions
      regFileDestSel <= 2'b10;
      ALUInstructionCode <= 6'b100000; // Add4
      regFileDinSel_1 <= 1'b0;
      regFileDinSel_2 <= 1'b1;
      oprnd2Sel <= 1'b1;
      memoryReadCtrl <= 1'b0;

      if(operationCode[4] == 1'b0) begin
        // R type diadic
        extensionCtrl <= 1'b0;

        if (operationCode[1] == 1'b0) begin
          // Branch Instructions
          regFileWriteEnable <= 1'b0;
          oprnd1Sel <= 1'b1;

          if(operationCode[0] == 1'b0) begin
            // BEQZ
            selectNewPC <= isRS1Zero;
          end
          else begin
            // BNEZ
            selectNewPC <= !isRS1Zero;
          end
        end
        else begin
          // Non-branch Instructions
          selectNewPC <= 1'b1;
          oprnd1Sel <= 1'b0;

          if(operationCode[0] == 1'b0) begin
            // JR
            regFileWriteEnable <= 1'b0;
          end
          else begin
            // JALR
            regFileWriteEnable <= 1'b1;
          end
        end
      end
      else begin
        // J type
        selectNewPC <= 1'b1;
        extensionCtrl <= 1'b1;
        oprnd1Sel <= 1'b1;

        if (operationCode[0] == 1'b0) begin
          // J
          regFileWriteEnable <= 1'b0;
        end
        else begin
          // JAL
          regFileWriteEnable <= 1'b1;
        end
      end
    end
  end

endmodule

//// Control Signals
// selectNewPC = 1'b;
// extensionCtrl = 1'b;
// regFileWriteEnable = 1'b;
// regFileDestSel = 1'b;
// ALUInstructionCode = 6'b;
// regFileDinSel_1 = 1'b;
// regFileDinSel_2 = 1'b;
// oprnd1Sel = 1'b;
// oprnd2Sel = 1'b;
// memoryReadCtrl = 1'b;
