`timescale 1ns / 1ps

module SignExtension32b (
	inputValue_16b,  // immediate value from instruction
	inputValue_26b,  // immediate value from instruction
	ExtnCtrl,  // control signal for the type of extension [0 for Extn16, 1 for Extn26]
	immediateValue_32b  // operand to ALU
);
	input [15:0] inputValue_16b;
	input [25:0] inputValue_26b;
	input ExtnCtrl;
	output [31:0] immediateValue_32b;
	
	assign immediateValue_32b = (ExtnCtrl == 1'b0) ? {{16{inputValue_16b[15]}}, inputValue_16b} : {{6{inputValue_16b[15]}}, inputValue_26b};
endmodule