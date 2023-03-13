`timescale 1ns / 1ps

module ALU(
  /****** Inputs ******/
  A,
  B,
  opCode,
  carryOut,

  /****** Outputs ******/
  out
);

  parameter ADD  = 6'b000001;
  parameter SUB  = 6'b000010;
  parameter AND  = 6'b000011;
  parameter OR   = 6'b000100;
  parameter XOR  = 6'b000101;
  parameter SLL  = 6'b000110;
  parameter SRL  = 6'b000111;
  parameter SRA  = 6'b001000;
  parameter ROL  = 6'b001001;
  parameter ROR  = 6'b001010;
  parameter SLT  = 6'b001011;
  parameter SGT  = 6'b001100;
  parameter SLE  = 6'b001101;
  parameter SGE  = 6'b001110;
  parameter UGT  = 6'b001111;
  parameter ULT  = 6'b010000;
  parameter UGE  = 6'b010001;
  parameter ULE  = 6'b010010;
  parameter ADD4 = 6'b100000;

  input [31:0] A;
  input [31:0] B;
  input [5:0] opCode;
  output carryOut;
  output [31:0] out;

  reg [32:0] tmpOut;

  assign carryOut = tmpOut[32];
  assign out = tmpOut[31:0];

  always @(*) begin
    case(opCode)
      ADD: tmpOut = A + B;
      SUB: tmpOut = A - B;
      AND: tmpOut = A & B;
      OR : tmpOut = A | B;
      XOR: tmpOut = A ^ B;
      SLL: tmpOut = A << B[4:0];
      SRL: tmpOut = A >> B[4:0];
      SRA: tmpOut = A >>> B[4:0];
      ROL: tmpOut = (A << B[4:0]) | (A >> (6'b100000 - B[4:0]));
      ROR: tmpOut = (A >> B[4:0]) | (A << (6'b100000 - B[4:0]));
      SLT: case({A[31], B[31]})
        2'b00: tmpOut = (A[30:0] < B[30:0]) ? {33{1'b1}} : 33'b0;
        2'b01: tmpOut = 0;
        2'b10: tmpOut = {33{1'b1}};
        2'b11: tmpOut = (A[30:0] < B[30:0]) ? {33{1'b1}} : 33'b0;
      endcase
      SGT: case({A[31], B[31]})
        2'b00: tmpOut = (A[30:0] > B[30:0]) ? {33{1'b1}} : 33'b0;
        2'b01: tmpOut = {33{1'b1}};
        2'b10: tmpOut = 0;
        2'b11: tmpOut = (A[30:0] > B[30:0]) ? {33{1'b1}} : 33'b0;
      endcase
      SLE: case({A[31], B[31]})
        2'b00: tmpOut = (A[30:0] <= B[30:0]) ? {33{1'b1}} : 33'b0;
        2'b01: tmpOut = 0;
        2'b10: tmpOut = {33{1'b1}};
        2'b11: tmpOut = (A[30:0] <= B[30:0]) ? {33{1'b1}} : 33'b0;
      endcase
      SGE: case({A[31], B[31]})
        2'b00: tmpOut = (A[30:0] >= B[30:0]) ? {33{1'b1}} : 33'b0;
        2'b01: tmpOut = {33{1'b1}};
        2'b10: tmpOut = 0;
        2'b11: tmpOut = (A[30:0] >= B[30:0]) ? {33{1'b1}} : 33'b0;
      endcase
      UGT: tmpOut = (A > B)  ? {33{1'b1}} : 33'b0;
      ULT: tmpOut = (A < B)  ? {33{1'b1}} : 33'b0;
      UGE: tmpOut = (A >= B) ? {33{1'b1}} : 33'b0;
      ULE: tmpOut = (A <= B) ? {33{1'b1}} : 33'b0;
      ADD4:tmpOut = (A + {B[29:0], 2'b00});
      default: tmpOut = 0;
    endcase
  end

endmodule
