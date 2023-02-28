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

    wire [31:0] dataOut_1;
    wire [31:0] dataOut_2;
    wire carryOut;
    wire [31:0] aluOut;
    
    wire [4:0] regDest;
    wire [4:0] regSource_1;
    wire [4:0] regSource_2;
    assign regDest = userInstruction[15:11];
    assign regSource_1 = userInstruction[25:21];
    assign regSource_2 = userInstruction[20:16];
    
    assign processorClk = pushButtonsDebounced[2];
    assign globalReset = pushButtonsDebounced[3];
    assign outputToggle = pushButtonsDebounced[4];

    Input in(clk, switches, pushButtons, pushButtonsDebounced, userInstruction);

    RegFile regFile(processorClk, globalReset, 1'b1, regDest, regSource_1, regSource_2, aluOut, dataOut_1, dataOut_2);
    
    ALU alu(dataOut_1, dataOut_2, userInstruction[5:0], carryOut, aluOut);

    Output out(aluOut, outputToggle, leds);
    
endmodule
