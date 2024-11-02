module singlecycle (
	input	logic		 	 i_clk,
	input  logic        i_rst_n,
	input  logic [31:0] i_io_sw,
	input  logic [31:0] i_io_btn,
	output logic [31:0] o_io_lcd,
	output logic [31:0] o_io_ledg,
	output logic [31:0] o_io_ledr,
	output logic [6:0]  o_io_hex0,
	output logic [6:0]  o_io_hex1,
	output logic [6:0]  o_io_hex2,
	output logic [6:0]  o_io_hex3,
	output logic [6:0]  o_io_hex4,
	output logic [6:0]  o_io_hex5,
	output logic [6:0]  o_io_hex6,
	output logic [6:0]  o_io_hex7,
	output logic [31:0] o_pc_debug,
	output logic        o_insn_vld
);

	logic [31:0]  alu_data;
	logic [31:0]  pc;
	logic [31:0]  pc_four;
	logic [31:0]  pc_next;
	logic [31:0]  instr;
	logic [31:0]  rs1_data;
	logic [31:0]  rs2_data;
	logic [31:0]  wb_data;
	logic [31:0]  operand_a;
	logic [31:0]  operand_b;
	logic [31:0]  ld_data;
	logic [31:0]  imm_data;
	logic [4:0]   rs1_addr;
	logic [4:0]   rs2_addr;
	logic [4:0]   rd_addr;
	logic [3:0]   alu_op;
	logic [1:0]   wb_sel;
	logic         pc_sel;
	logic         br_un;
	logic         br_less;
	logic         br_equal;
	logic         rd_wren;
	logic         mem_wren;
	logic         opa_sel;
	logic         opb_sel;
	logic         pc_debug_wren;
	logic         insn_vld;
  
	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];
	assign rd_addr = instr[11:7];
  
	// PC Register
	pc_reg PCRegister (
		.i_clk 	  (i_clk),
		.i_rst     (i_rst_n),
		.i_pc_wren (pc_wren),
		.i_pc_next (pc_next),
		.o_pc     (pc)
	);

	// Instruction Memory
	instr_mem InstructionMemory (
		.i_pc    (pc),
		.o_instr (instr)
	);

	// Immediate Generator
	immgen ImmediateGenerator (
		.i_instr		(instr),
		.o_imm_data (imm_data)
	);

	// Branch Comparator
	brc BranchComparator (
		.i_rs1_data (rs1_data),
		.i_rs2_data (rs2_data),
		.i_br_un    (br_un),
		.o_br_less  (br_less),
		.o_br_equal (br_equal)
	);

	// Control Unit
	ctrlu ControlUnit (
		.i_instr    (instr),
		.i_br_less  (br_less),
		.i_br_equal(br_equal),
		.o_pc_sel(pc_sel),
		.o_rd_wren (rd_wren),
		.o_insn_vld (insn_vld),
		.o_br_un(br_un),
		.o_alu_op (alu_op),
		.o_mem_wren  (mem_wren),
		.o_opa_sel (opa_sel),
		.o_opb_sel(opb_sel),
		.o_wb_sel (wb_sel),
		.o_pc_wren (pc_wren)
	);

	// Register File
	regfile RegisterFile (
		.i_clk      (i_clk),
		.i_rst      (i_rst_n),
		.i_rd_wren  (rd_wren),
		.i_rd_addr  (rd_addr),
		.i_rs1_addr (rs1_addr),
		.i_rs2_addr (rs2_addr),
		.i_rd_data  (wb_data),
		.o_rs1_data (rs1_data),
		.o_rs2_data (rs2_data)
	);

	// ALU
	alu ALU (
		.i_operand_a (operand_a),
		.i_operand_b (operand_b),
		.i_alu_op    (alu_op),
		.o_alu_data  (alu_data)
	);

	// Operand A 
	opa_mux OperandAMux (
		.i_opa_sel   (opa_sel),
		.i_rs1_data  (rs1_data),
		.i_pc        (pc),
		.o_operand_a (operand_a)
	);

  // Operand B 
  opb_mux OperandBMux (
    .i_opb_sel   (opb_sel),
    .i_rs2_data  (rs2_data),
    .i_imm_data  (imm_data),
    .o_operand_b (operand_b)
  );

  // LSU
  lsu LoadStoreUnit (
    .i_clk      (i_clk),
    .i_rst      (i_rst_n),
    .i_lsu_wren (mem_wren),
    .i_st_data  (rs2_data),
    .i_io_sw    (i_io_sw),
    .i_io_btn   (i_io_btn),
    .o_ld_data  (ld_data),
    .o_io_ledg  (o_io_ledg),
    .o_io_ledr  (o_io_ledr),
    .o_io_lcd   (o_io_lcd),
    .o_io_hex0  (o_io_hex0),
    .o_io_hex1  (o_io_hex1),
    .o_io_hex2  (o_io_hex2),
    .o_io_hex3  (o_io_hex3),
    .o_io_hex4  (o_io_hex4),
    .o_io_hex5  (o_io_hex5),
    .o_io_hex6  (o_io_hex6),
    .o_io_hex7  (o_io_hex7)
  );

	// Write Back Multiplexer
	wb_mux WriteBackMultiplexer (
		.i_wb_sel   (wb_sel),
		.i_alu_data (alu_data),
		.i_pc_four  (pc_four),
		.i_ld_data  (ld_data),
		.o_wb_data  (wb_data)
	);

	// PC + 4 
	pc_four PCfour (
		.i_pc      (pc),
		.o_pc_four (pc_four)
	);

	// PC Multiplexer
	pc_mux PCMultiplexer (
		.i_pc_sel   (pc_sel),
		.i_alu_data (alu_data),
		.i_pc_four  (pc_four),
		.o_pc_next  (pc_next)
	  );

	// PC Debug Register
	pc_debug_reg PCDebugRegister (
		.i_clk           (i_clk),
	   .i_rst      	  (i_rst_n),  
	   .i_pc      		 (pc),
	   .o_pc_debug    (o_pc_debug)
	);

	// Instruction Valid
	insn_vld_reg InstructionValidRegister (
	   .i_clk       (i_clk),
	   .i_rst       (i_rst_),
	   .i_insn_vld (insn_vld),
	   .o_insn_vld (o_insn_vld)
	);

endmodule: singlecycle
