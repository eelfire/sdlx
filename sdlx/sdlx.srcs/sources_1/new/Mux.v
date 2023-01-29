module mux (
  input sel, A, B,
  ouput O
);
  assign O = sel ? A : B;
endmodule

module mux_op (
  input sel,
  input [5:0] Func, Op,
  ouput [5:0] o
);
  genvar i; 
  generate
    for (i = 0; i < 6; i = i + 1)   
      begin:select
        mux stage(sel, Func[i], Op[i], o[i]);
      end
  endgenerate
endmodule

module mux_data (
  input sel,
  input [31:0] X, Y,
  ouput [31:0] Out
);
  genvar k; 
  generate
    for (k = 0; k < 31; k = k + 1)   
      begin:select
        mux stage(sel, X[k], Y[k], Out[k]);
      end
  endgenerate 
endmodule

