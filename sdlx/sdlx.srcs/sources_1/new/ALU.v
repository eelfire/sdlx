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
            SLT: tmpOut = A < B;
            SGT: tmpOut = A > B;
            SLE: tmpOut = A <= B;
            SGE: tmpOut = A >= B;
            UGT: tmpOut = A > B;
            ULT: tmpOut = A < B;
            UGE: tmpOut = A >= B;
            ULE: tmpOut = A <= B;

            // 5'b01000: tmpOut = A < B;
            // 5'b01001: tmpOut = A > B;
            // 5'b01010: tmpOut = A == B;
            // 5'b01011: tmpOut = A != B;
            // 5'b01100: tmpOut = A <= B;
            // 5'b01101: tmpOut = A >= B;
            // 5'b01110: tmpOut = A && B;
            // 5'b01111: tmpOut = A || B;
            // 5'b10000: tmpOut = A * B;
            // 5'b10001: tmpOut = A / B;
            // 5'b10010: tmpOut = A % B;
            // 5'b10011: tmpOut = A << 1;
            // 5'b10100: tmpOut = A >> 1;
            // 5'b10101: tmpOut = A >>> 1;
            // 5'b10110: tmpOut = A << 2;
            // 5'b10111: tmpOut = A >> 2;
            // 5'b11000: tmpOut = A >>> 2;
            // 5'b11001: tmpOut = A << 3;
            // 5'b11010: tmpOut = A >> 3;
            // 5'b11011: tmpOut = A >>> 3;
            // 5'b11100: tmpOut = A << 4;
            // 5'b11101: tmpOut = A >> 4;
            // 5'b11110: tmpOut = A >>> 4;
            // 5'b11111: tmpOut = A;
            default: tmpOut = 0;
        endcase
    end

endmodule
