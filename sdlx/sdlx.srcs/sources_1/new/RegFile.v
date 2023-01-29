module Reg_File (
  clk,  // input clock
  reset,  // active high reset the regFile
  writeEnable, // Write enable
  enable, // read enable
  regDest, // destination address
  regSource_1,  // Source address 1
  regSource_2,  // Source address 2
  dataIn,
  dataOut_1,
  dataOut_2
);
  input clk;
  input reset;
  input writeEnable;
  input enable;
  input [4:0] regDest;
  input [4:0] regSource_1;
  input [4:0] regSource_2;
  input [31:0] dataIn;
  output [31:0] dataOut_1;
  output [31:0] dataOut_2;

  reg [31:0] regFile [0:7];

  assign dataOut_1 = regFile[regSource_1[2:0]];
  assign dataOut_2 = regFile[regSource_2[2:0]];

  always @(posedge clk , posedge reset) begin
    if(reset) begin
      for(i = 0; i < 8; i = i + 1) 
        regFile[i] <= 32'b0;
    end    
    else begin
      if(writeEnable) begin
        regFile[regDest] <= dataIn;
      end
    end
  end

endmodule
