`timescale 1ns / 1ps

module MemLaneSwitch (
  /****** Inputs ******/
  laneControl, // memory address[1:0] bits
  memoryDataIn, // data from regFile
  memoryDataOut, // data read from memory
  
  /****** Outputs ******/
  alignedMemDataIn, // data for writing to memory
  alignedMemDataOut // data to be stored in regFile
);

  input [1:0] laneControl;
  input [31:0] memoryDataIn;
  input [31:0] memoryDataOut;
  output [31:0] alignedMemDataIn;
  output [31:0] alignedMemDataOut;

  // Memory Write Lane Controller
  wire dataInLane0 = memoryDataIn[7:0];
  wire dataInLane1 = memoryDataIn[15:8];
  wire dataInLane2 = memoryDataIn[23:16];
  wire dataInLane3 = memoryDataIn[31:24];

  assign alignedMemDataIn[7:0] = dataInLane0;
  Mux #(.BIT_WIDTH(8)) w_lane_1(laneControl[0], dataInLane1, dataInLane0, alignedMemDataIn[15:8]);
  Mux #(.BIT_WIDTH(8)) w_lane_2(laneControl[1], dataInLane2, dataInLane0, alignedMemDataIn[23:16]);
  Mux_4x1 #(.BIT_WIDTH(8)) w_lane_3(laneControl, dataInLane3, 8'b0, dataInLane1, dataInLane0, alignedMemDataIn[31:24]);

  // Memory Read Lane Controller
  wire dataOutLane0 = memoryDataOut[7:0];
  wire dataOutLane1 = memoryDataOut[15:8];
  wire dataOutLane2 = memoryDataOut[23:16];
  wire dataOutLane3 = memoryDataOut[31:24];

  Mux_4x1 #(.BIT_WIDTH(8)) r_lane_0(laneControl, dataOutLane0, dataOutLane1, dataOutLane2, dataOutLane3, alignedMemDataOut[7:0]);
  Mux #(.BIT_WIDTH(8)) r_lane_1(laneControl[1], dataOutLane1, dataOutLane3, alignedMemDataOut[15:8]);
  assign alignedMemDataOut[31:16] = {dataOutLane3, dataOutLane2};

endmodule
