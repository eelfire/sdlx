`timescale 1ns / 1ps

module Main (
  clk,  // input clock (100 MHz)
  reset,  // input reset
);

wire [31:0] currentInstruction;
wire [31:0] instructionImmediateValue;

RegFile()

ControlUnit()

InstructionRegister(currentInstruction)

SignExtension32b(currentInstruction[15:0], instructionImmediateValue);

// Second Operand Select for ALU
Mux (#BIT_WIDTH = 32) (selectImmediate, instructionImmediateValue, dataOut_2, operand_2)