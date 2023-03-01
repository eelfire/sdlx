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

    wire [4:0] pushButtonsDebounced;
    wire [31:0] userInstruction;

    wire processorClk;
    wire globalReset;
    wire outputToggle;

    wire [31:0] dataIn;
    wire [31:0] dataOut_1;
    wire [31:0] dataOut_2;
    wire carryOut;
    wire [31:0] aluOut;
    
    wire regFileReset;
    wire regFileWriteEnable;
    wire [4:0] regDest;
    wire [4:0] regSource_1;
    wire [4:0] regSource_2;
    
    assign processorClk = pushButtonsDebounced[2];
    assign globalReset = pushButtonsDebounced[3];
    assign outputToggle = pushButtonsDebounced[4];

    wire ExtnCtrl;
    wire [15:0] Extn16;
    wire [25:0] Extn26;
    wire [31:0] immediateValue_32b;

    assign Extn16 = userInstruction[15:0];
    assign Extn26 = userInstruction[25:0];

    wire PCReset;
    wire [29:0] currentPC;
    wire [29:0] newPC;

    wire RDctrl;
    wire [31:0] memoryOutput;
    
    wire [5:0] ALUInstructionCode;
    wire [31:0] ALUOperand1;
    wire [31:0] ALUOperand2;

    Input in(clk, switches, pushButtons, pushButtonsDebounced, userInstruction);

    SignExtension32b ext(Extn16, Extn26, ExtnCtrl, immediateValue_32b);

    ControlUnit cu(processorClk, globalReset, userInstruction, aluOut, memoryOutput, dataOut_1, dataOut_2,immediateValue_32b, currentPC, regFileReset, PCReset, regFileWriteEnable, regDest, regSource_1, regSource_2, dataIn, ALUInstructionCode, ALUOperand1, ALUOperand2, ExtnCtrl, RDctrl, newPC);

    RegFile regFile(processorClk, regFileReset, regFileWriteEnable, regDest, regSource_1, regSource_2, dataIn, dataOut_1, dataOut_2);

    PC pc(processorClk, PCReset, newPC, currentPC);
    
    ALU alu(ALUOperand1, ALUOperand2, ALUInstructionCode, carryOut, aluOut);

    Output out(aluOut, outputToggle, leds);
    
endmodule
