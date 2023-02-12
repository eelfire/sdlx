module Input (
	/****** Inputs ******/
	clk, // 100 MHz
	switches,
	pushButtons,

	/****** Outputs ******/
	pushButtonsDebounced,
	userInstruction
);

	input clk;
	input [15:0] switches;
	input [3:0] pushButtons;
	output [3:0] pushButtonsDebounced;
	output [31:0] userInstruction;
	
	reg [23:0] counter;
	wire slowerClk;
	
	// generating a slower clock (~6 Hz)
	always @(posedge clk) begin
		counter <= counter + 1;
	end

	assign slowerClk = counter[23];

	PushBtnDebounce pb0 (slowerClk, pushButtons[0], pushButtonsDebounced[0]);
	PushBtnDebounce pb1 (slowerClk, pushButtons[1], pushButtonsDebounced[1]);
	PushBtnDebounce pb2 (slowerClk, pushButtons[2], pushButtonsDebounced[2]);
	PushBtnDebounce pb3 (slowerClk, pushButtons[3], pushButtonsDebounced[3]);

	ProcessUserInstruction pui (switches, pushButtonsDebounced[0], pushButtonsDebounced[1], userInstruction);
	
endmodule

module ProcessUserInstruction (
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
			currentHalfInstruction_1[15:0] <= inputHalfInstr[15:0];
		end
	end
	
	always @(posedge latchSignal_2) begin
		if (latchSignal_2) begin
			currentHalfInstruction_2[15:0] <= inputHalfInstr[15:0];
		end
	end
	
endmodule

module PushBtnDebounce (
	/****** Inputs ******/
	clk, // slower clock
	buttonSignal,

	/****** Outputs ******/
	debouncedSignal
);
	input clk;
	input buttonSignal;
	output debouncedSignal;

	wire Q1;
	wire Q2;

	DFF d1 (clk, buttonSignal, Q1);
	DFF d2 (clk, Q1, Q2);

	assign debouncedSignal = Q1 & ~Q2;

endmodule

module DFF (
	/****** Inputs ******/
	clk,
	in,

	/****** Outputs ******/
	out
);
	
	input clk;
	input in;
	output reg out;

	always @(posedge clk) begin
		out <= in;
	end

endmodule
