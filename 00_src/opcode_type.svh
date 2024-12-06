`ifndef OPCODE_TYPE_COMMAND
`define OPCODE_TYPE_COMMAND

package opcode_type;

  typedef enum logic [6:0] {
    LUI    = 7'b0110111,
    AUIPC  = 7'b0010111,
    JAL    = 7'b1101111,
    JALR   = 7'b1100111,
    B_type = 7'b1100011,
    Load   = 7'b0000011,
    Store  = 7'b0100011,
    I_type = 7'b0010011,
    R_type = 7'b0110011
  } opcode_type_e;

  typedef enum logic [2:0] {
    BEQ_LB_SB_ADDI     = 3'b000,
    BNE_LH_SH_SLLI     = 3'b001,
    BLT_LBU_XORI       = 3'b100,
    BGE_LHU_SRLI_SRAI  = 3'b101,
    BLTU_ORI           = 3'b110,
    BGEU_ANDI          = 3'b111,
    LW_SW_SLTI         = 3'b010,
    SLTIU              = 3'b011
  } funct3_e;

endpackage : opcode_type
`endif
