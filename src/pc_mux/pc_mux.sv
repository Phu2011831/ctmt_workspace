module pc_mux (
	input logic        i_pc_sel,    // Tin hieu chon PC
	input logic [31:0] i_alu_data,  // Du lieu dau ra tu ALU
	input logic [31:0] i_pc_four,   // Gia tri PC + 4
	output logic [31:0] o_pc_next   // Gia tri PC tiep theo
);

	// Lua chon gia tri PC tiep theo dua vao i_pc_sel:
	// Neu i_pc_sel = 1, chon gia tri tu ALU (i_alu_data)
	// Neu i_pc_sel = 0, chon gia tri PC + 4 (i_pc_four)
	assign o_pc_next = (i_pc_sel) ? i_alu_data : i_pc_four;
	
endmodule : pc_mux
