`include "timescale.svh"
`include "opcode_type.svh"

module control_unit 
import opcode_type::*;
(
  input  logic [31:0] instr    ,
  input  logic        br_less  ,
  input  logic        br_equal ,
  input  logic        ack      , 
  output logic [ 1:0] pc_sel   , // 00 if pc_four, 01 if pc_bru, 10 if pc_current
  output logic        reg_wr_en,
  output logic        rd_en    , // read enable from SRAM 
  output logic        br_un    , // 1 if signed, 0 if unsigned
  output logic        a_sel    , // 0 if rs1_data, 1 if pc
  output logic        b_sel    , // 0 if rs2_data, 1 if imm
  output logic [ 3:0] alu_sel  ,
  output logic        wr_en    , // write enable from SRAN/LSU
  output logic [ 2:0] ld_sel   , // select byte load
  output logic [ 3:0] bmask    , // select byte store
  output logic [ 1:0] wb_sel   , // 00 if alu_data, 01 if pc_four, 10 if ld_data
  output logic        insn_vld 
);
  
  opcode_type_e opcode_type;
  funct3_e funct3_type;
  
  logic [20:0] other_signal;

  assign {pc_sel, 
          a_sel,
          b_sel,
          reg_wr_en,
          br_un,
          wr_en,
          alu_sel,
          rd_en,
          bmask,
          ld_sel,
          wb_sel} = other_signal;

  always_comb begin 
	 opcode_type = opcode_type_e'(instr[6:0]);
    funct3_type = funct3_e'(instr[14:12]);
	 
    case (opcode_type) 
    LUI   : other_signal = 21'b00_1_1_1_1_0_1011_0_1111_111_00; // lui
    AUIPC : other_signal = 21'b00_1_1_1_1_0_0000_0_1111_111_00; // auipc
    JAL   : other_signal = 21'b01_1_1_1_1_0_0000_0_1111_111_10; // jal
    JALR  : other_signal = 21'b01_0_1_1_1_0_0000_0_1111_111_10; // jalr
    B_type: begin 
      case (funct3_type) 
      BEQ_LB_SB_ADDI   : other_signal = br_equal ?  21'b01_1_1_0_1_0_0000_0_1111_111_00 : 21'b00_1_1_0_1_0_0000_0_1111_111_00;               // beq
      BNE_LH_SH_SLLI   : other_signal = ~br_equal ? 21'b01_1_1_0_1_0_0000_0_1111_111_00 : 21'b00_1_1_0_1_0_0000_0_1111_111_00;               // bne
      BLT_LBU_XORI     : other_signal = br_less ?   21'b01_1_1_0_1_0_0000_0_1111_111_00 : 21'b00_1_1_0_1_0_0000_0_1111_111_00;               // blt
      BGE_LHU_SRLI_SRAI: other_signal = (~br_less || br_equal) ?  21'b01_1_1_0_1_0_0000_0_1111_111_00 : 21'b00_1_1_0_1_0_0000_0_1111_111_00; // bge
      BLTU_ORI         : other_signal = br_less ?   21'b01_1_1_0_0_0_0000_0_1111_111_00 : 21'b00_1_1_0_0_0_0000_0_1111_111_00;               // bltu
      BGEU_ANDI        : other_signal = (~br_less || br_equal) ?  21'b01_1_1_0_0_0_0000_0_1111_111_00 : 21'b00_1_1_0_0_0_0000_0_1111_111_00; // bgeu
      default          : other_signal = 21'd0;
      endcase
    end 
    I_type: begin 
      case (funct3_type)
      BEQ_LB_SB_ADDI   : other_signal = 21'b00_0_1_1_1_0_0000_0_1111_111_00; // addi
      LW_SW_SLTI       : other_signal = 21'b00_0_1_1_1_0_0010_0_1111_111_00; // slti
      SLTIU            : other_signal = 21'b00_0_1_1_0_0_0011_0_1111_111_00; // sltiu
      BLT_LBU_XORI     : other_signal = 21'b00_0_1_1_1_0_0100_0_1111_111_00; // xori
      BLTU_ORI         : other_signal = 21'b00_0_1_1_1_0_0110_0_1111_111_00; // ori
      BGEU_ANDI        : other_signal = 21'b00_0_1_1_1_0_0111_0_1111_111_00; // andi
      BNE_LH_SH_SLLI   : other_signal = 21'b00_0_1_1_1_0_0001_0_1111_111_00; // slli
      BGE_LHU_SRLI_SRAI: other_signal = (~instr[30]) ? 21'b00_0_1_1_1_0_0101_0_1111_111_00 : 21'b00_0_1_1_1_0_1101_0_1111_111_00; // srli, srai
      default          : other_signal = 21'd0;
      endcase 
    end
    R_type: begin 
      case (funct3_type)
      BEQ_LB_SB_ADDI   : other_signal = (~instr[30]) ? 21'b00_0_0_1_1_0_0000_0_1111_111_00 : 21'b00_0_0_1_1_0_1000_0_1111_111_00; // add, sub
      LW_SW_SLTI       : other_signal = 21'b00_0_0_1_1_0_0010_0_1111_111_00; // slt
      SLTIU            : other_signal = 21'b00_0_0_1_0_0_0011_0_1111_111_00; // sltu
      BLT_LBU_XORI     : other_signal = 21'b00_0_0_1_1_0_0100_0_1111_111_00; // xor
      BLTU_ORI         : other_signal = 21'b00_0_0_1_1_0_0110_0_1111_111_00; // or
      BGEU_ANDI        : other_signal = 21'b00_0_0_1_1_0_0111_0_1111_111_00; // and
      BNE_LH_SH_SLLI   : other_signal = 21'b00_0_0_1_1_0_0001_0_1111_111_00; // sll
      BGE_LHU_SRLI_SRAI: other_signal = (~instr[30]) ? 21'b00_0_0_1_1_0_0101_0_1111_111_00 : 21'b00_0_0_1_1_0_1101_0_1111_111_00; // srl, sra
      default          : other_signal = 21'd0;
      endcase 
    end
    Load: begin
      case (funct3_type)
      BEQ_LB_SB_ADDI   : other_signal = (~ack) ? 21'b10_0_1_1_0_0_0000_1_1111_000_01 : 21'b00_0_1_1_0_0_0000_1_1111_000_01; // lb
      BNE_LH_SH_SLLI   : other_signal = (~ack) ? 21'b10_0_1_1_0_0_0000_1_1111_001_01 : 21'b00_0_1_1_0_0_0000_1_1111_001_01; // lh
      BLT_LBU_XORI     : other_signal = (~ack) ? 21'b10_0_1_1_0_0_0000_1_1111_011_01 : 21'b00_0_1_1_0_0_0000_1_1111_011_01; // lbu
      BGE_LHU_SRLI_SRAI: other_signal = (~ack) ? 21'b10_0_1_1_0_0_0000_1_1111_100_01 : 21'b00_0_1_1_0_0_0000_1_1111_100_01; // lhu
      LW_SW_SLTI       : other_signal = (~ack) ? 21'b10_0_1_1_0_0_0000_1_1111_010_01 : 21'b00_0_1_1_0_0_0000_1_1111_010_01; // lw
      default          : other_signal = 21'd0;
      endcase 
    end
    Store: begin 
      case (funct3_type)
      BEQ_LB_SB_ADDI: other_signal = (~ack) ? 21'b10_0_1_0_0_1_0000_0_0001_000_00 : 21'b00_0_1_0_0_1_0000_0_0001_000_00; // sb 
      BNE_LH_SH_SLLI: other_signal = (~ack) ? 21'b10_0_1_0_0_1_0000_0_0011_000_00 : 21'b00_0_1_0_0_1_0000_0_0011_000_00; // sh
      LW_SW_SLTI    : other_signal = (~ack) ? 21'b10_0_1_0_0_1_0000_0_1111_000_00 : 21'b00_0_1_0_0_1_0000_0_1111_000_00; // sw
      default       : other_signal = 21'd0;
      endcase
    end
    default: other_signal = 21'd0;
    endcase
  end

endmodule : control_unit




