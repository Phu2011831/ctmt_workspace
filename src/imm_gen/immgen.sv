module imm_gen (
	input logic [31:0] i_instr,      // Dau vao lenh 32-bit
	output logic [31:0] o_imm_data	// Dau ra immediate mo rong 32-bit
);

	always @(*) begin
		case (i_instr[6:0])
			// R-TYPE (51): Khong su dung immediate, tra ve 0
			7'b0110011: o_imm_data <= 32'b0;
			
			// I-TYPE (3:Load, 19:Immediate): Lay cac bit [31:20] va mo rong dau thanh 32-bit
			7'b0000011, 7'b0010011: o_imm_data <= {{20{i_instr[31]}}, i_instr[31:20]};
			
			// S-TYPE (35): Ghep cac bit tu [31:25] va [11:7] va mo rong dau thanh 32-bit
			7'b0100011: o_imm_data <= {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};
			
			// B-TYPE (99): Ghep cac bit tu [31], [7], [30:25], [11:8] va mo rong dau thanh 32-bit
			7'b1100011: o_imm_data <= {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};
			
			// J-TYPE(111): Ghep cac bit tu [31], [19:12], [20], [30:21] va mo rong dau thanh 32-bit
			7'b1101111: o_imm_data <= {{12{i_instr[31]}}, i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0};
			
			// U-TYPE(23: AUIPC, 55: LUI): Lay cac bit [31:12] va them 12 bit `0` vao ben phai
			7'b0110111, 7'b0010111: o_imm_data <= {i_instr[31:12], 12'b0};
			
			// Truong hop ngoai le
			default: o_imm_data <= 32'b0;
		endcase
	end
endmodule: imm_gen
