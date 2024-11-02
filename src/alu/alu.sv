module alu (
	input  logic [3:0] i_alu_op,        // Ngo vao chon che do hoat dong
	input  logic [31:0] i_operand_a,    // Ngo vao tuong ung voi rs1
	input  logic [31:0] i_operand_b,    // Ngo vao tuong ung voi rs2 hoac imm
   output logic [31:0] o_alu_data      // Ngo ra data
);

	// Dinh nghia cac gia tri cho i_alu_op bang parameter
	parameter [3:0] ADD      = 4'b0000;  // Cong
	parameter [3:0] SUB      = 4'b1000;  // Tru
	parameter [3:0] SLL      = 4'b0001;  // Dich trai logic
	parameter [3:0] SLT      = 4'b0010;  // So sanh nho hon
	parameter [3:0] SLTU     = 4'b0011;  // So sanh nho hon khong dau
	parameter [3:0] XOR      = 4'b0100;  // XOR
	parameter [3:0] SRL      = 4'b0101;  // Dich phai logic
	parameter [3:0] SRA      = 4'b1101;  // Dich phai so hoc
	parameter [3:0] OR       = 4'b0110;  // OR
	parameter [3:0] AND      = 4'b0111;  // AND
	parameter [3:0] LUI      = 4'b1111;  // Lay dia chi cao

	// Tao wire ket noi cac module phu
   logic ci;
   logic [31:0] add_sub_result;
   logic [31:0] sll_result;
   logic [31:0] slt_result;
   logic [31:0] sltu_result;
   logic [31:0] xor_result;
   logic [31:0] srl_result;
   logic [31:0] sra_result;
   logic [31:0] or_result;
   logic [31:0] and_result;

   assign ci = i_alu_op[3];

	// Module add sub
   alu_add_sub u_add_sub (.i_add_sub_a(i_operand_a), .i_add_sub_b(i_operand_b), .i_carry_in(ci), .o_add_sub_result(add_sub_result));
    
   // Module sll
   alu_sll u_sll (.i_sll_data(i_operand_a), .i_sll_shift(i_operand_b), .o_sll_result(sll_result));
    
   // Module slt
   alu_slt u_slt (.i_slt_a(i_operand_a), .i_slt_b(i_operand_b), .o_slt_result(slt_result));
   
   // Module sltu
   alu_sltu u_sltu (.i_sltu_a(i_operand_a), .i_sltu_b(i_operand_b), .o_sltu_result(sltu_result));

   // Module xor
   alu_xor u_xor (.i_xor_a(i_operand_a), .i_xor_b(i_operand_b), .o_xor_result(xor_result));

   // Module srl
   alu_srl u_srl (.i_srl_data(i_operand_a), .i_srl_shift(i_operand_b), .o_srl_result(srl_result));
    
   // Module sra
   alu_sra u_sra (.i_sra_data(i_operand_a), .i_sra_shift(i_operand_b), .o_sra_result(sra_result));
    
   // Module or
   alu_or u_or (.i_or_a(i_operand_a), .i_or_b(i_operand_b), .o_or_result(or_result));
    
   // Module and
   alu_and u_and (.i_and_a(i_operand_a), .i_and_b(i_operand_b), .o_and_result(and_result));
    
   // Lua chon operation cho alu
	always_comb begin
		case (i_alu_op)
			ADD  : o_alu_data = add_sub_result;		// ADD
			SUB  : o_alu_data = add_sub_result;		// SUB
			SLL  : o_alu_data = sll_result;			// SLL
			SLT  : o_alu_data = slt_result;			// SLT
			SLTU : o_alu_data = sltu_result;   		// SLTU
			XOR  : o_alu_data = xor_result;   		// XOR
			SRL  : o_alu_data = srl_result;   		// SRL
			SRA  : o_alu_data = sra_result;			// SRA
			OR   : o_alu_data = or_result;			// OR
			AND  : o_alu_data = and_result;			// AND
			LUI  : o_alu_data = i_operand_b;			// LUI
			default: o_alu_data = 32'b0;				// Mac dinh
		endcase
	end
endmodule : alu
