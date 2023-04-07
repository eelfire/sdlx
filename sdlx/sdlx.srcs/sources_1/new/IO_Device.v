`timescale 1ns / 1ps

module IODevice(
	/****** Inputs ******/
	clk,
	address,
	dataIn,

	/****** Outputs ******/
	segments,
	digitEn
);

	input clk;
	input [31:0] address;
	input [31:0] dataIn;
	output [7:0] segments;
	output [3:0] digitEn;

	wire writeEn = (address == 32'h80054338);

	reg [13:0] io_out;
	
	always @(posedge clk) begin
		if(writeEn) begin
			io_out <= dataIn[13:0];
		end
	end

	BcdDisplay bcd(clk, io_out, segments, digitEn);

endmodule
