module Mux (
  sel,
  A,
  B,
  out
);
  input sel;
  input [BIT_WIDTH-1:0] A;
  input [BIT_WIDTH-1:0] B;
  output [BIT_WIDTH-1:0] out;
  
  assign out = sel ? A : B;
endmodule

// module MuxParallel (
//   sel,
//   A,
//   B,
//   out
// );
//   parameter BIT_WIDTH = 6;
  
//   input sel;
//   input [BIT_WIDTH-1:0] A;
//   input [BIT_WIDTH-1:0] B;
//   output [BIT_WIDTH-1:0] out;

//   genvar i;
//   generate
//     for (i = 0; i < BIT_WIDTH; i = i + 1) begin:select
//       Mux stage(sel, A[i], B[i], out[i]);
//     end
//   endgenerate
// endmodule
