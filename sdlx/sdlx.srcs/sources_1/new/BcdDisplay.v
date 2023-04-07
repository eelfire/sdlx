`timescale 1ns / 1ps

module BcdDisplay(
	/****** Inputs ******/
	input clk, // 100 MHz
	input [13:0] binNumber,

	/****** Outputs ******/
	output [7:0] Segments,
	output [3:0] Digit_En
);

	reg [16:0] count;
	always @(posedge clk) begin
		count <= count + 1;
	end

	reg [1:0] Sel;
	always @(posedge count[10]) begin
		Sel <= Sel + 1;
	end
	
	Decoder A1(Sel, Digit_En);
	
	wire i_Start = count[6];
	wire [15:0] o_BCD;
	wire o_DV;
	
	Binary_to_BCD #(.INPUT_WIDTH(14), .DECIMAL_DIGITS(4)) A2(clk, binNumber, i_Start, o_BCD, o_DV);

	reg [15:0] r_BCD;

	always @(posedge o_DV) begin
		if(o_DV) begin
			r_BCD <= o_BCD;
		end
		// else begin
		// 	r_BCD <= r_BCD;
		// end
	end

	wire [3:0] BCD_Digit;

	Mux_4to1 A3(Sel, r_BCD, BCD_Digit);
	
	Bin_7Segment_Display A4(BCD_Digit, Segments);

endmodule

module Decoder(
	input [1:0] Sel,
	output reg [3:0] Out
);
		
	always @(Sel) begin
		case(Sel)
			2'b00: Out <= 4'b1110;
			2'b01: Out <= 4'b1101;
			2'b10: Out <= 4'b1011;
			2'b11: Out <= 4'b0111;
		endcase
	end

endmodule

module Mux_4to1(
	input [1:0] Sel,
	input [15:0] In,
	output reg [3:0] Out
);
		
	always @(Sel, In) begin
		case(Sel)
			2'b00: Out <= In[0+:4];
			2'b01: Out <= In[4+:4];
			2'b10: Out <= In[8+:4];
			2'b11: Out <= In[12+:4];
		endcase
	end

endmodule

module Bin_7Segment_Display(
	input [3:0] Bin,
	output reg [7:0] Segments
);
		
	always @(Bin) begin
		case(Bin)
			4'b0000: Segments <= 8'b11000000; // MSB: Decimal Dot; // LSB : Segment A; Common anode leds; 
			4'b0001: Segments <= 8'b11111001;
			4'b0010: Segments <= 8'b10100100;
			4'b0011: Segments <= 8'b10110000;
			4'b0100: Segments <= 8'b10011001;
			4'b0101: Segments <= 8'b10010010;
			4'b0110: Segments <= 8'b10000010;
			4'b0111: Segments <= 8'b11111000;
			4'b1000: Segments <= 8'b10000000;
			4'b1001: Segments <= 8'b10010000;
		endcase
	end
		
endmodule
