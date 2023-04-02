`timescale 1ns / 1ps

module PC (
  /****** Inputs ******/
  clk, // processor clk
  resetPC,
  selectNewPC, // signal to select increment or newPC
  newPC,

  /****** Outputs ******/
  incrementedPC,
  currentPC
);

  input clk;
  input resetPC;
  input selectNewPC; // 0 - increment, 1 - set from input data
  input [29:0] newPC;
  output [29:0] incrementedPC;
  output reg [29:0] currentPC;

  wire [29:0] nextPC;

  assign incrementedPC = currentPC + 1;

  Mux #(.BIT_WIDTH(30)) nxtPC(selectNewPC, incrementedPC, newPC, nextPC);

  always @(posedge clk, posedge resetPC) begin
    if (resetPC) begin
      currentPC <= 30'b0;
    end
    else begin
      currentPC <= nextPC;
    end
  end

endmodule
