`timescale 1ns / 1ps

module ControlUnit (
  /****** Inputs ******/
  clk,
  globalReset,
  currentInstruction,
  ALUOutput,
  memoryOutput,
  dataOut_1,
  dataOut_2,
  immediateValue_32b,
  currentPC,   

  /****** Outputs ******/
  regFileReset,
  PCReset,
  regFileWriteEnable,
  regDest,
  regSource_1,
  regSource_2,
  dataIn,
  ALUInstructionCode,
  ALUOperand1,
  ALUOperand2,
  ExtnCtrl,  // [0 for Extn16, 1 for Extn26]
  RDctrl,   // read data control to read data from memory
  newPC
);

  input clk;
  input globalReset;
  input [31:0] currentInstruction;

  // Reset Signals
  output regFileReset;
  output PCReset;

  assign regFileReset = globalReset;
  assign PCReset = globalReset;

  // RegFile
  input [31:0] ALUOutput;
  input [31:0] memoryOutput;

  output regFileWriteEnable;
  output [4:0] regDest;
  output [4:0] regSource_1;
  output [4:0] regSource_2;
  output [31:0] Din;

  wire [31:0] interDin;
  wire [29:0] addedPC;
  reg [1:0] RDSel;
  reg DinSel1;
  reg DinSel2;

  assign regSource_1 = currentInstruction[20:16];
  assign regSource_2 = currentInstruction[25:21];

  assign addedPC = currentPC + 1'b1;

  Mux_3x1 #(.BIT_WIDTH(5)) m_3x1 (RDSel, currentInstruction[15:11], currentInstruction[20:16], 5'b11111, regDest);
  Mux #(.BIT_WIDTH(32)) Din1 (DinSel1, ALUOutput, memoryOutput, interDin);
  Mux #(.BIT_WIDTH(32)) Din2 (DinSel2, interDin, {addedPC, 2'b00}, dataIn);

  // ALU 
  input [31:0] dataOut_1;
  input [31:0] dataOut_2;
  input [29:0] currentPC;
  input [31:0] immediateValue_32b;

  output [5:0] ALUInstructionCode;
  output [31:0] ALUOperand1;
  output [31:0] ALUOperand2;
  output reg ExtnCtrl;

  wire [5:0] functionCode;
  wire [5:0] operationCode;
  reg selectFunctionCode;
  reg Oprnd1Sel;
  reg Oprnd2Sel;

  assign functionCode = currentInstruction[5:0];
  assign operationCode = currentInstruction[31:26];

  Mux #(.BIT_WIDTH(6)) ALUinstr (selectFunctionCode, functionCode, operationCode, ALUInstructionCode);

  Mux #(.BIT_WIDTH(32)) Oprnd1 (Oprnd1Sel, dataOut_1, {currentPC,2'b00}, ALUOperand1);
  Mux #(.BIT_WIDTH(32)) Oprnd2 (Oprnd2Sel, dataOut_2, immediateValue_32b, ALUOperand2);

  // PC
  output [29:0] newPC;

  reg NextPC;

  Mux #(.BIT_WIDTH(29)) NextPC (NextPC, addedPC, ALUOutput[31:2], newPC);
 
  // RS1 = 0
  wire RS1is0; 

  assign RS1is0 = (|dataOut_1 == 1'b0);

  output reg RDctrl;

  // Control Signal generation
  always @(posedge clk) begin
    if (operationCode[5] ==  1'b0) begin
      if(|operationCode) begin
        // R-type triadic
        regFileWriteEnable = 1'b1;
        RDSel = 2'b00;
        DinSel1 = 1'b0;
        DinSel2 = 1'b0;
        selectFunctionCode = 1'b0;
        Oprnd1Sel = 1'b0;
        Oprnd2Sel = 1'b0;
        ExtnCtrl = 1'bz;
        RDctrl = 1'b0;
        NextPC = 1'b0;
      end
      else begin
        // R-I type triadic
        RDSel = 2'b01;
        DinSel1 = 1'b0;
        DinSel2 = 1'b0;
        selectFunctionCode = 1'b1;
        Oprnd1Sel = 1'b0;
        Oprnd2Sel = 1'b1;

        if (operationCode >= 6'd20) begin
          if (operationCode >= 6'd49) begin
            RDctrl = 1'b0;
            regFileWriteEnable = 1'b1;
          end
          else begin
            RDctrl = 1'b1;
            regFileWriteEnable = 1'b0;
          end
        end
        else begin
            RDctrl = 1'b0;
            regFileWriteEnable = 1'b1;
        end
        ExtnCtrl = 1'b0;
        NextPC = 1'b0;
      end
    end
    else begin
      if(operationCode[4] == 1'b0) begin
        // R type diadic
        // include RS1is0?

        if (operationCode >= 5'd35) begin
          Oprnd1Sel = 1'b0;
          NextPC = 1'b1;
          if(operationCode[2] == 1'b1) begin // JALR
            regFileWriteEnable = 1'b0;
            RDSel = 2'bzz;  
            DinSel2 = 1'bz;
          end
          else begin  // JR
            regFileWriteEnable = 1'b1;
            RDSel = 2'b10;
            DinSel2 = 1'bz;
          end
        end
        else begin  // BNEZ and BEQZ
          Oprnd1Sel = 1'b1;
          regFileWriteEnable = 1'b0;
          RDSel = 2'bzz;
          DinSel2 = 1'bz;
          
          if (operationCode[0] == 1'b0) begin // BEQZ
            if (RS1is0) 
              NextPC = 1'b1;
            else 
              NextPC = 1'b0;
          end
          else // BNEZ
            if (RS1is0) 
              NextPC = 1'b0;
            else 
              NextPC = 1'b1;
        end
        // Common Signals
        DinSel1 = 1'bz;
        selectFunctionCode = 1'b1;
        Oprnd2Sel = 1'b1;
        ExtnCtrl = 1'b0;
        RDctrl = 1'b0;
      end
      else begin
        // J type 
        
        if (operationCode[0] == 1'b0) begin  // J
          regFileWriteEnable = 1'b0;
          RDSel = 2'bzz;
        end
        else begin  // JAL
          regFileWriteEnable = 1'b1;
          RDSel = 2'b10;
        end
        // common signals
        DinSel1 = 1'bz;
        DinSel2 = 1'b1;
        selectFunctionCode = 1'b1;
        Oprnd1Sel = 1'bz;
        Oprnd2Sel = 1'b1;
        ExtnCtrl = 1'b1;
        RDctrl = 1'b0;
        NextPC = 1'b1;
      end
    end
  end  


  
endmodule

module Mux_3x1 #(parameter BIT_WIDTH = 6)(
  sel,
  A,
  B,
  out
);
  
//  parameter BIT_WIDTH = 6;
  
  input [1:0] sel;
  input [BIT_WIDTH-1:0] A;
  input [BIT_WIDTH-1:0] B;
  input [BIT_WIDTH-1:0] C;
  output [BIT_WIDTH-1:0] out;
  
  assign out = (sel = 2'b00) ? A : 1'bz;
  assign out = (sel = 2'b01) ? B : 1'bz;
  assign out = (sel = 2'b10) ? C : 1'bz;

endmodule