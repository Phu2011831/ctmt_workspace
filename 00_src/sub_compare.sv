`include "timescale.svh"

module sub_compare (
  input  logic [31:0] a     ,
  input  logic [31:0] b     ,
  output logic [32:0] data_s,
  output logic [32:0] data_us
);

  assign data_s = {(a[31]),a[31:0]} + ((~{b[31],b[31:0]}) + 1'b1); // signed a - signed b
  assign data_us = {1'b0,a[31:0]} + ~({1'b0,b[31:0]}) + 1'b1; // unsigned a - b

endmodule : sub_compare  
