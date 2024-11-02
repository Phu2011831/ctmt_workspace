module wb_mux (
	input  logic [1:0]  i_wb_sel,      // Tin hieu select cho Write-Back
	input  logic [31:0] i_alu_data,  // Du lieu tu ALU
	input  logic [31:0] i_ld_data,    // Du lieu tu Memory
	input  logic [31:0] i_pc_four,    // Gia tri PC + 4 (neu can)
	output logic [31:0] o_wb_data      // Du lieu ghi vao thanh ghi (Write-Back Data)
);

	// Lua chon du lieu Write-Back dua vao i_wb_sel:
	always_comb begin
		case (i_wb_sel)
			2'b01: o_wb_data = i_ld_data;		// Chon ket qua ALU
			2'b10: o_wb_data = i_alu_data; // Chon du lieu Memory
			2'b11: o_wb_data = i_pc_four;   // Chon gia tri PC + 4
			default: o_wb_data = 32'b0;      // Gia tri mac dinh neu khong co lua chon hop le
		endcase
	end

endmodule : wb_mux
