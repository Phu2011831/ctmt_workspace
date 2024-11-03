module opa_mux (
	input  logic		  i_opa_sel,	// Tin hieu select A
	input  logic [31:0] i_rs1_data,	// Du lieu tu thanh ghi rs1
	input  logic [31:0] i_pc,			// Gia tri cua con tro PC
	output logic [31:0] o_operand_a	// Ngo ra operand A
);

	//Chon tin hieu ngo vao dua theo i_opa_sel:
	// Neu i_opa_sel = 1, chon i_pc lam gia tri cua o_operand_a
	// Neu i_opa_sel = 0, chon i_rs1_data lam gia tri cua o_operand_a
	assign o_operand_a = (i_opa_sel) ? i_pc : i_rs1_data;
endmodule: opa_mux