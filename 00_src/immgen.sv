`include "timescale.svh"
`include "opcode_type.svh"

module immgen 
import opcode_type::*;
(
  input  logic [31:0] instr,
  output logic [31:0] imm
); 
  
  opcode_type_e opcode;
  funct3_e funct3;
  
  always_comb begin 
  	 opcode = opcode_type_e'(instr[6:0]);
    funct3 = funct3_e'(instr[14:12]);
    case (opcode) 
      LUI   : imm = {instr[31:12], 12'h0};
      AUIPC : imm = {instr[31:12], 12'h0};
      JAL   : imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
      JALR  : imm = {{20{instr[31]}}, instr[31:20]};
      B_type: imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};  
      Load  : imm = {{20{instr[31]}}, instr[31:20]};
      Store : imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      I_type: begin 
        case (funct3)
          BEQ_LB_SB_ADDI   : imm = {{20{instr[31]}}, instr[31:20]};
		  LW_SW_SLTI       : imm = {{20{instr[31]}}, instr[31:20]};
		  SLTIU            : imm = {{20{instr[31]}}, instr[31:20]};
		  BLT_LBU_XORI     : imm = {{20{instr[31]}}, instr[31:20]};
		  BLTU_ORI         : imm = {{20{instr[31]}}, instr[31:20]};
		  BGEU_ANDI        : imm = {{20{instr[31]}}, instr[31:20]};
		  BNE_LH_SH_SLLI   : imm = {27'h0, instr[24:20]};
		  BGE_LHU_SRLI_SRAI: imm = {27'h0, instr[24:20]};
	      default          : imm = 0;
        endcase
      end
      default: imm = 0;
    endcase
  end

endmodule : immgen
