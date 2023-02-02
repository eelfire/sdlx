module Input (
	/****** Inputs ******/
	clk, // 100 MHz
	pushButtons,

	/****** Outputs ******/
	pushButtonsDebounced
);

	input clk;
	input [2:0] pushButtons;
	output [2:0] pushButtonsDebounced;

	PushBtnDebounce pb0 (clk, pushButtons[0], pushButtonsDebounced[0]);
	PushBtnDebounce pb1 (clk, pushButtons[1], pushButtonsDebounced[1]);
	PushBtnDebounce pb2 (clk, pushButtons[2], pushButtonsDebounced[2]);
	
endmodule

module PushBtnDebounce (
	/****** Inputs ******/
	clk, // 100 MHz
	buttonSignal,

	/****** Outputs ******/
	debouncedSignal
);
	input clk;
	input buttonSignal;
	output debouncedSignal;

	reg [23:0] counter;
	wire slowerClk;
	wire Q1;
	wire Q2;

	// generating a slower clock (~6 Hz)
	always @(posedge clk) begin
		counter <= counter + 1;
	end

	assign slowerClk = counter[23];

	DFF d1 (slowerClk, buttonSignal, Q1);
	DFF d2 (slowerClk, Q1, Q2);

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
