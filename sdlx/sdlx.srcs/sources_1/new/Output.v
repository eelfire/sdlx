module Output (
	/****** Inputs ******/
	clk, // 100 MHz
	ALUOut, // output after ALU computation

	/****** Outputs ******/
	leds, // onboard leds
);

	input clk;
	input [31:0] ALUOut;
	output [15:0] leds;

	reg [28:0] counter;

	always @(posedge clk) begin
		counter <= counter + 1;
	end

	// alters b/w displaying MSB and LSB bits in ~2.7s
	assign leds = (counter[27] == 1'b1) ? ALUOut[31:16] ? ALUOut[15:0];
endmodule
