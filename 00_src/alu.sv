`include "timescale.svh"
`include "alu_opcode.svh"

module alu
import alu_opcode::*;
(
  input  logic [31:0] operand_a		 ,
  input  logic [31:0] operand_b		 ,	
  input 			[ 3:0] alu_op,
  output logic [31:0] alu_data
);
/* verilator lint_off UNUSEDSIGNAL */
  logic [32:0] data_s,
               data_us;
  logic [31:0] sll_data, 
               srl_data,
               sra_data;
/* verilator lint_on UNUSEDSIGNAL */
  
  alu_op_e alu_op_t;
  
  sub_compare compare (
    .a       (operand_a),
    .b       (operand_b),
    .data_s  (data_s)   ,
    .data_us (data_us)
  );

  shift_reg shift (
    .a   (operand_a)     ,
    .b   (operand_b[4:0]),
    .sll (sll_data)      ,
    .srl (srl_data)      ,
    .sra (sra_data)
  );

  always_comb begin 
	 alu_op_t = alu_op_e'(alu_op[3:0]);
 
    case (alu_op_t) 
      ADD : alu_data = operand_a + operand_b; 
      SUB : alu_data = data_s[31:0];
      SLT : alu_data = (data_s[32]) ? 32'h1 : 32'h0;
      SLTU: alu_data = (data_us[32]) ? 32'h1 : 32'h0;
      XOR : alu_data = operand_a ^ operand_b;
      OR  : alu_data = operand_a | operand_b;
      AND : alu_data = operand_a & operand_b;
      SLL : alu_data = sll_data;
      SRL : alu_data = srl_data;
      SRA : alu_data = sra_data;
      LUI : alu_data = operand_b;
      default: alu_data = 0;
    endcase 
  end

  endmodule : alu 
