module InstructionRegister (
	/****** Inputs ******/
	clk, // processor clock
	reset,
	nextInstruction, // fetched from memory

	/****** Outputs ******/
	currentInstruction
);
	
	input clk;
	input reset;
	input [31:0] nextInstruction;
	output reg [31:0] currentInstruction;

	always @(posedge clk) begin
		if(reset) begin
			currentInstruction <= 32'b0;
		end
		else begin
			currentInstruction <= nextInstruction;
		end
	end
	
endmodule
