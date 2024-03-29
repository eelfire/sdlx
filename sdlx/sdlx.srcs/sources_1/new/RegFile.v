`timescale 1ns / 1ps

module RegFile (
 /****** Inputs ******/
 clk,  // input clock
 reset,  // active high reset the regFile
 writeEnable, // write enable
 regDest, // destination address
 regSource_1,  // Source address 1
 regSource_2,  // Source address 2
 dataIn,

 /****** Outputs ******/
 dataOut_1,
 dataOut_2
);

 input clk;
 input reset;
 input writeEnable;
 input [4:0] regDest;
 input [4:0] regSource_1;
 input [4:0] regSource_2;
 input [31:0] dataIn;
 output [31:0] dataOut_1;
 output [31:0] dataOut_2;

 reg [31:0] regFile [0:31];

 assign dataOut_1 = regFile[regSource_1];
 assign dataOut_2 = regFile[regSource_2];

 integer i;
  
 always @(posedge clk, posedge reset) begin
   if(reset) begin
     for (i = 0; i < 32; i = i + 1) begin
       regFile[i] <= i;
     end
   end
   else begin
     if(writeEnable) begin
       regFile[regDest] <= dataIn;
     end
   end
 end

endmodule
