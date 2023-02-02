module Input (
	/****** Inputs ******/
	clk, // 100 MHz
	pushButtons,

	/****** Outputs ******/
	pushButtonsDebounced
);

	input clk;
	input [3:0] pushButtons;
	output [3:0] pushButtonsDebounced;
	
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
