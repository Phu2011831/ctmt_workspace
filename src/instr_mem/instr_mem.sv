module instr_mem
(
  input  logic [31:0]  i_pc,
  output logic [31:0]  o_instr
);

  reg [3:0][7:0] i_mem [2**(11)-1:0];

  //initial $readmemh(".mem", i_mem);
	
  always_comb begin
    o_instr <= i_mem [i_pc[12:2]][3:0];
  end
endmodule : instr_mem