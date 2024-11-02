module ctrlu(
	input logic [31:0] i_instr,
   input logic i_br_less,
   input logic i_br_equal,
	output logic o_pc_sel,
	output logic o_br_un,
   output logic o_opa_sel,
   output logic o_opb_sel,
   output logic [3:0] o_alu_op,
	output logic [1:0] o_wb_sel,
	output logic o_pc_wren,
   output logic o_rd_wren,
   output logic o_mem_wren,
	output logic o_insn_vld
);

	logic [6:0] opcode;
	logic [2:0] funct3;
	logic [6:0] funct7;
	
   // Tach opcode, funct3, funct7 tu ngo vao i_instr 32 bit
	always_comb begin
		opcode = i_instr[6:0];
		funct3 = i_instr[14:12];
		funct7 = i_instr[31:25];
	end

	// Dinh nghia cac gia tri cho o_alu_op bang parameter
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
   
	assign o_pc_wren 		  =  o_insn_vld;
	
	// Dieu khien cac module dua vao tin hieu opcode
   always_comb begin
		// Kiem tra opcode de xac dinh loai lenh
      case (opcode)
			// I_type (load): opcode = 3
			7'b0000011: begin
				o_pc_sel     = 1'b0;    // Chon dia chi tu PC
				o_br_un      = 1'b0;    // Khong dung cho lenh load
				o_opa_sel    = 1'b0;    // Operand A tu thanh ghi (rs1)
				o_opb_sel    = 1'b0;    // Operand B la immediate
				o_wb_sel     = 2'b01;   // Ghi du lieu tu bo nho vao thanh ghi dich
				o_rd_wren    = 1'b1;    // Cho phep ghi vao thanh ghi dich
				o_mem_wren   = 1'b0;    // Khong ghi vao bo nho
				 
				// Kiem tra gia tri funct3
				case (funct3)
					// Lenh hop le (funct3 = 010)
					3'b010: begin
						o_alu_op    = ADD;      // ALU thuc hien phep cong
						o_insn_vld = 1'b1;     // Lenh hop le
					end
					  
					// Lenh khong hop le
					default: begin
						o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
						o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
					end
				endcase
			end

			// I_type (logic immediate): opcode = 19
			7'b0010011: begin
				o_pc_sel    = 1'b0;    // Chon dia chi tu PC
				o_br_un     = 1'b0;    // Khong dung cho cac lenh logic
				o_opa_sel   = 1'b0;    // Operand A tu thanh ghi (rs1)
				o_opb_sel   = 1'b0;    // Operand B la immediate
				o_wb_sel    = 2'b01;   // Ghi ket qua ALU vao thanh ghi dich
				o_rd_wren   = 1'b1;    // Cho phep ghi vao thanh ghi dich
				o_mem_wren  = 1'b0;    // Khong ghi vao bo nho
				case (funct3)
					// ADDI (phep cong)
					3'b000: begin
						o_alu_op    = ADD;      // ALU thuc hien phep cong
						o_insn_vld = 1'b1;     // Lenh hop le
					end
					  
					// SLLI (shift left logical immediate)
					3'b001: begin
						// Kiem tra funct7 hop le
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								o_alu_op    = SLL;  // ALU thuc hien phep dich trai
								o_insn_vld = 1'b1;
							end
							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					  
					// SLTI (set less than immediate)
					3'b010: begin
						o_alu_op    = SLT;      // ALU thuc hien set less than
						o_insn_vld = 1'b1;
					end
					  
					// SLTIU (set less than immediate unsigned)
					3'b011: begin
						o_alu_op    = SLTU;     // ALU thuc hien set less than unsigned
						o_insn_vld = 1'b1;
					end
					  
					// XORI (xor immediate)
					3'b100: begin
						o_alu_op    = XOR;      // ALU thuc hien phep XOR
						o_insn_vld = 1'b1;
					end
					  
					// SRLI, SRAI (shift right logical/arith immediate)
					3'b101: begin
						// Kiem tra funct7 hop le
						case (funct7)
							// SRLI hop le
							7'b0000000: begin 
								o_alu_op    = SRL;  // ALU thuc hien phep dich phai logic
								o_insn_vld = 1'b1;
							end
								 
							// SRAI hop le
							7'b0100000: begin 
								o_alu_op    = SRA;  // ALU thuc hien phep dich phai so hoc
								o_insn_vld = 1'b1;
							end
								 
							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					  
					// ORI (or immediate)
					3'b110: begin
						o_alu_op    = OR;       // ALU thuc hien phep OR
						o_insn_vld = 1'b1;
					end
					  
					// ANDI (and immediate)
					3'b111: begin
						o_alu_op    = AND;      // ALU thuc hien phep AND
						o_insn_vld = 1'b1;
					end
				endcase
			end
						
			// U_type (add upper immediate to PC): opcode = 23
			7'b0010111: begin
				o_pc_sel     = 1'b0;
				o_br_un      = 1'b0;
				o_opa_sel    = 1'b1;
				o_opb_sel    = 1'b0;
				o_wb_sel     = 2'b10;
				o_rd_wren    = 1'b1;
				o_mem_wren   = 1'b0;
				o_alu_op     = ADD;
				o_insn_vld  = 1'b1;
			end
			
			//S_type (store): opcode = 35
			7'b0100011: begin
				o_pc_sel		= 1'b0;
				o_br_un		= 1'b0;
				o_opa_sel	= 1'b0;
				o_opb_sel	= 1'b0;
				o_wb_sel		= 2'b00;
				o_rd_wren	= 1'b0;
				o_mem_wren	= 1'b1;
				// Kiem tra funct3 = 010
				case (funct3)
					// Hop le
					3'b010: begin
						o_alu_op = ADD;
						o_insn_vld = 1'b1;
					end
					
					// Lenh khong hop le
					default: begin
						o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
						o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
					end
				endcase
			end
			
			//R_type (logic register): opcode = 51
			7'b0110011: begin
				o_pc_sel = 1'b0;
				o_br_un = 1'b0;
				o_opa_sel = 1'b0;
				o_opb_sel = 1'b1;
				o_wb_sel = 2'b01;
				o_rd_wren = 1'b1;
				o_mem_wren = 1'b0;
				case (funct3)
					//ADD, SUB
					3'b000: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// ADD hop le
							7'b0000000: begin 
								o_alu_op = ADD;
								o_insn_vld = 1;
							end
							
							// SUB hop le
							7'b0100000: begin 
								o_alu_op = SUB;
								o_insn_vld = 1;
							end
							
							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//SLL
					3'b001: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								o_alu_op 	= SLL;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//SLT
					3'b010: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								o_alu_op 	= SLT;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//SLTU
					3'b011: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								o_alu_op 	= SLTU;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//XOR
					3'b100: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Lenh hop le
							7'b0000000: begin 
								o_alu_op 	= XOR;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//SRL, SRA
					3'b101: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// SRLI hop le
							7'b0000000: begin 
								o_alu_op = SRL;
								o_insn_vld = 1;
							end
							
							// SRAI hop le
							7'b0100000: begin 
								o_alu_op = SRA;
								o_insn_vld = 1;
							end
							
							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase
					end
					
					//OR
					3'b110: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Hop le
							7'b0000000: begin 
								o_alu_op = OR;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase;
					end
					
					//ANDI
					3'b111: begin
						// Kiem tra funct7 co hop le khong
						case (funct7)
							// Hop le
							7'b0000000: begin 
								o_alu_op = AND;
								o_insn_vld = 1;
							end

							// Lenh khong hop le
							default: begin
								o_alu_op    = ADD;      // Dat mac dinh cho o_alu_op
								o_insn_vld = 1'b0;     // Danh dau lenh khong hop le
							end
						endcase;
					end
				endcase
			end
			
			// U_type (load upper immediate): opcode = 55
			7'b0110111: begin
				 o_pc_sel     = 1'b0;
				 o_br_un      = 1'b0;
				 o_opa_sel    = 1'b1;
				 o_opb_sel    = 1'b0;
				 o_wb_sel     = 2'b10;   // Ghi ket qua tu ALU vao thanh ghi dich
				 o_rd_wren    = 1'b1;    // Cho phep ghi vao thanh ghi dich
				 o_mem_wren   = 1'b0;    // Khong ghi vao bo nho
				 o_alu_op     = LUI;     // ALU thuc hien tai gia tri immediate len 20 bit cao
				 o_insn_vld  = 1'b1;
			end

			//B_type (branch): opcode = 99
			7'b1100011: begin
				o_opa_sel	= 1'b1;
				o_opb_sel	= 1'b0;
				o_wb_sel 	= 2'b10;
				o_rd_wren 	= 1'b0;
				o_mem_wren 	= 1'b0;
				o_alu_op = ADD;
				case (funct3)
					// BEQ
					3'b000: begin
						o_br_un = 0;
						o_pc_sel = (i_br_equal) ? 1'b1 : 1'b0;
						o_insn_vld = 1;
					end
					
					// BNE
					3'b001: begin
						o_br_un = 0;
						o_pc_sel = (i_br_equal) ? 1'b0 : 1'b1;
						o_insn_vld = 1;
					end
						
					// BLT
					3'b010: begin
						o_br_un = 0;
						o_pc_sel = (i_br_less) ? 1'b1 : 1'b0;
						o_insn_vld = 1;
					end
						
					// BGE
					3'b011: begin
						o_br_un = 0;
						o_pc_sel = (i_br_less) ? 1'b0 : 1'b1;
						o_insn_vld = 1;
					end
					
					// BLTU
					3'b100: begin
						o_br_un = 1;
						o_pc_sel = (i_br_less) ? 1'b1 : 1'b0;
						o_insn_vld = 1;
					end
						
					// BGEU
					3'b101: begin
						o_br_un = 1;
						o_pc_sel = (i_br_less) ? 1'b0 : 1'b1;
						o_insn_vld = 1;
					end
						
					//Khong hop le
					default: begin
						o_pc_sel = 1'b0;
						o_br_un = 1'b0;
						o_insn_vld = 1'b0;
					end
				endcase
			end
			
			// I_type (JALR - jump and link register): opcode = 103
			7'b1100111: begin
				 o_pc_sel     = 1'b1;
				 o_br_un      = 1'b0;
				 o_opa_sel    = 1'b0;
				 o_opb_sel    = 1'b0;
				 o_wb_sel     = 2'b11;
				 o_rd_wren    = 1'b1;
				 o_mem_wren   = 1'b0;
				 o_alu_op     = ADD;
				 o_insn_vld  = 1'b1;
			end

			// J_type (JAL - jump and link): opcode = 111
			7'b1101111: begin
				 o_pc_sel     = 1'b1;
				 o_br_un      = 1'b0;
				 o_opa_sel    = 1'b1;
				 o_opb_sel    = 1'b0;
				 o_wb_sel     = 2'b11;
				 o_rd_wren    = 1'b1;
				 o_mem_wren   = 1'b0;
				 o_alu_op     = ADD;
				 o_insn_vld  = 1'b1;
			end
			// Opcode khong hop le
			default: begin
				o_insn_vld = 1'b0;
				o_alu_op    = ADD;
				o_pc_sel    = 1'b0;
				o_br_un     = 1'b0;
				o_opa_sel   = 1'b0;
				o_opb_sel   = 1'b0;
				o_wb_sel    = 2'b00;
				o_rd_wren   = 1'b0;
				o_mem_wren  = 1'b0;
			end
		endcase
	end
endmodule: ctrlu
