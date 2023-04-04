`timescale 1ns / 1ps

module DataConvert (
  /****** Inputs ******/
  signExtend,  // 0 - unsigned extension, 1 - signed extension
  dataSize,  // 00 - byte, 01 - halfword, 10 - word
  memoryOut,  // data read from the memory

  /****** Outputs ******/
  dataOut
);

  input [31:0] memoryOut;
  input signExtend;
  input [1:0] dataSize;
  output reg [31:0] dataOut;

  always @(signExtend, dataSize, memoryOut) begin
    if(dataSize[1] == 1'b1) begin // word
      dataOut <= memoryOut;
    end
    else begin // byte or halfword
      case({ signExtend, dataSize[0] })
        2'b00: dataOut <= {24'b0, memoryOut[7:0]};
        2'b01: dataOut <= {16'b0, memoryOut[15:0]};
        2'b10: dataOut <= {{24{memoryOut[7]}}, memoryOut[7:0]};
        2'b11: dataOut <= {{16{memoryOut[15]}}, memoryOut[15:0]};
      endcase
    end
  end

endmodule
