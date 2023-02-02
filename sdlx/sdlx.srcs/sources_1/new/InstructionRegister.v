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
	output [31:0] currentInstruction;
	reg [15:0] currentHalfInstruction_1;
	reg [15:0] currentHalfInstruction_2;
	
	assign currentInstruction = {currentHalfInstruction_1, currentHalfInstruction_2};

	always @(posedge latchSignal_1) begin
		if (latchSignal_1) begin
			currentHalfInstruction_1 <= inputHalfInstr;
		end
	end
	
	always @(posedge latchSignal_2) begin
        if (latchSignal_2) begin
            currentHalfInstruction_2 <= inputHalfInstr;
        end
    end
	
endmodule
