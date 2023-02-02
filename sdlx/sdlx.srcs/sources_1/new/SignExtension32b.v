module SignExtension32b (
	inputValue_16b,  // immediate value from instruction
	immediateValue_32b,  // operand to ALU
);
	input [15:0] inputValue_16b;
	output [31:0] immediateValue_32b;
	
	assign immediateValue_32b = {{16{inputValue_16b[15]}}, inputValue_16b};
endmodule