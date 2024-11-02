module opb_mux (
	input  logic		  i_opb_sel,	// Tin hieu select B
	input  logic [31:0] i_rs2_data,	// Du lieu tu thanh ghi rs2
	input  logic [31:0] i_imm_data,  // Du lieu immediate
	output logic [31:0] o_operand_b	// Ngo ra operand B
);

	// Chon tin hieu dau vao dua theo i_opb_sel:
	// Neu i_opb_sel = 1, chon i_rs2_data lam gia tri cua o_operand_b
	// Neu i_opb_sel = 0, chon i_imm_data lam gia tri cua o_operand_b
	assign o_operand_b = (i_opb_sel) ? i_rs2_data: i_imm_data  ;
endmodule: opb_mux