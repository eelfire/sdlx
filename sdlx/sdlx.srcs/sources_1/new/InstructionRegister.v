module InstructionRegister (
	/****** Inputs ******/
	inputHalfInstr, // 16 bit user entered data through switches
	latchSignal_1, // signal for updating LSB bits
	latchSignal_2, // signal for updating MSB bits
	
	/****** Outputs ******/
	currentInstruction
);

	input [15:0] inputHalfInstr;
	input latchSignal_1;
	input latchSignal_2;
	output reg [31:0] currentInstruction;

	always @(posedge latchSignal_1 or posedge latchSignal_2) begin
		if(latchSignal_1) begin
			currentInstruction[15:0] <= inputHalfInstr;
		end
		else begin
			currentInstruction[31:16] <= inputHalfInstr;
		end
	end
	
endmodule
