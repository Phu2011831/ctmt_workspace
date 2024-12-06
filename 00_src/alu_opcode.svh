`ifndef ALU_OPCODE_SVH
`define ALU_OPCODE_SVH

package alu_opcode;

  typedef enum logic [3:0] {
    ADD  = 4'b0000,
    SUB  = 4'b1000,
    SLT  = 4'b0010,
    SLTU = 4'b0011,
    XOR  = 4'b0100,
    OR   = 4'b0110,
    AND  = 4'b0111,
    SLL  = 4'b0001,
    SRL  = 4'b0101,
    SRA  = 4'b1101,
    LUI  = 4'b1011
  } alu_op_e;   

endpackage : alu_opcode 
`endif
