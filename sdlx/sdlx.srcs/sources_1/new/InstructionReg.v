`timescale 1ns / 1ps

module InstructionRegister(
	/****** Inputs ******/
	clk, // processor clk
	resetIR, // sets IR to 32'b0: nop
	nextInstruction,

	/****** Outputs ******/
	currentInstruction
);
	
	input clk;
	input resetIR;
	input [31:0] nextInstruction;
	output reg [31:0] currentInstruction;

	always @(posedge clk, posedge resetIR) begin
		if(resetIR) begin
			currentInstruction <= 32'b0;
		end
		else begin
			currentInstruction <= nextInstruction;
		end
	end

endmodule
