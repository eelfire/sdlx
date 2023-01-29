module Mux (
  sel,
  A, 
  B,
  out
);
  input sel;
  input A;
  input B;
  output out;
  
  assign out = sel ? A : B;

endmodule

module MuxParallel (
  sel,
  A,
  B,
  out
);
  parameter n = 6;
  
  input sel;
  input [n - 1:0] A;
  input [n - 1:0] B;
  output [n - 1:0] out

  genvar i; 
  generate
    for (i = 0; i < n; i = i + 1)   
      begin:select
        Mux stage(sel, A[i], B[i], out[i]);
      end
  endgenerate
endmodule


