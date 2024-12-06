`include "timescale.svh"

module brc (
  input  logic [31:0] rs1_data,
  input  logic [31:0] rs2_data,
  input  logic        br_un   , // 1 if signed, 0 if unsigned
  output logic        br_less , // 1 if rs1 < rs2, otherwise
  output logic        br_equal  // 1 if rs1 = rs2, otherwise
);
  /* verilator lint_off UNUSEDSIGNAL */
  logic [32:0] data_s, data_us;
  /* verilator lint_on UNUSEDSIGNAL */


  sub_compare br_comp (
    .a       (rs1_data),
    .b       (rs2_data),
    .data_s  (data_s)  ,
    .data_us (data_us)
  );

  assign br_less  = (br_un) ? data_s[32] : data_us[32]; 
  assign br_equal = (rs1_data == rs2_data) ? 1 : 0;

endmodule : brc 
