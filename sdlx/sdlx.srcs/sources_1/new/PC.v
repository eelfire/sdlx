`timescale 1ns / 1ps

module PC (
  /****** Inputs ******/
  clk,
  PCReset,
  newPC,

  /****** Outputs ******/
  currentPC
);
  input clk;
  input PCReset;
  input [29:0] newPC;

  output reg currentPC;

  always @(posedge clk or posedge PCReset) begin
    if (PCReset) 
      currentPC = 29'b0;
    else begin
      currentPC <= newPC;
    end
  end

endmodule