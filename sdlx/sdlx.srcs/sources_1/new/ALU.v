`timescale 1ns / 1ps

module ALU(
        A,
        B,
        opCode,
        carryOut,
        out
    );

    parameter ADD = 6'b000000;
    parameter SUB = 6'b000001;
    parameter AND = 6'b000010;
    parameter OR  = 6'b000011;
    parameter XOR = 6'b000100;
    parameter SLL = 6'b000101;
    parameter SRL = 6'b000110;
    parameter SRA = 6'b000111;
    parameter ROL = 6'b001000;
    parameter ROR = 6'b001001;
    parameter SLT = 6'b001010;
    parameter SGT = 6'b001011;
    parameter SLE = 6'b001100;
    parameter SGE = 6'b001101;
    parameter UGT = 6'b001110;
    parameter ULT = 6'b001111;
    parameter UGE = 6'b010000;
    parameter ULE = 6'b010001;

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
            ROL: tmpOut = {A[31], A[30:0]} << B[4:0];
            ROR: tmpOut = {A[0], A[31:1]} >> B[4:0];
            SLT: case({A[31], B[31]})
                            2'b00: tmpOut = A[30:0] < B[30:0];
                            2'b01: tmpOut = 0;
                            2'b10: tmpOut = 1;
                            2'b11: tmpOut = A[30:0] > B[30:0];
                          endcase
            SGT: case({A[31], B[31]})
                            2'b00: tmpOut = A[30:0] > B[30:0];
                            2'b01: tmpOut = 1;
                            2'b10: tmpOut = 0;
                            2'b11: tmpOut = A[30:0] < B[30:0];
                          endcase
            SLE: case({A[31], B[31]})
                            2'b00: tmpOut = A[30:0] <= B[30:0];
                            2'b01: tmpOut = 0;
                            2'b10: tmpOut = 1;
                            2'b11: tmpOut = A[30:0] >= B[30:0];
                          endcase
            SGE: case({A[31], B[31]})
                            2'b00: tmpOut = A[30:0] >= B[30:0];
                            2'b01: tmpOut = 1;
                            2'b10: tmpOut = 0;
                            2'b11: tmpOut = A[30:0] <= B[30:0];
                          endcase
            UGT: tmpOut = A > B;
            ULT: tmpOut = A < B;
            UGE: tmpOut = A >= B;
            ULE: tmpOut = A <= B;
            default: tmpOut = 0;
        endcase
    end

endmodule
