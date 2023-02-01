`timescale 1ns / 1ps

module ControlUnit (
    currentInstruction,  // input instruction from IR
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
    
    assign regSourceSelect_1 = currentInstruction[21+:5];
    assign regSourceSelect_2 = currentInstruction[16+:5];

    Mux (#BIT_WIDTH = 5) (selectRegDest, currentInstruction[20:16], currentInstruction[15:11], regDestSelect); // Destination Register Select


    // ALU Control Signals
    output [5:0] ALUInstructionCode;

    reg selectFunctionCode; // mux select line for func | opcode
    wire functionCode;
    wire operationCode;
    
    assign functionCode = currentInstruction[0+:6];
    assign operationCode = currentInstruction[25+:6];

    Mux (#BIT_WIDTH = 6) (selectFunctionCode, functionCode, operationCode, ALUInstructionCode); // Function Code Select


    // Immediate Value Control Signals
    output reg selectImmediate;


    always @(currentInstruction) begin
    	regFileReset = 0;
    	regFileWriteEnable = 1;

    	if(currentInstruction[31:25] == 6'b0) begin
    		selectImmediate = 0;
    		selectFunctionCode = 1;
    	end
    	else begin
    		selectImmediate = 1;
    		selectFunctionCode = 0;
    	end
    end
endmodule