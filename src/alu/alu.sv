module alu (
    input logic [31:0] i_operand_a, // Ngo vao tuong ung voi rs1
    input logic [31:0] i_operand_b, // Ngo vao tuong ung voi rs2 hoac imm
    input alu_op_e i_alu_op,        // Ngo vao chon che do hoat dong
    output logic [31:0] o_alu_data   // Ngo ra data
);

    // Dinh nghia enum
    typedef enum logic [3:0] {
        ADD  = 4'b0000,
        SUB  = 4'b1000,
        SLL  = 4'b0001,
        SLT  = 4'b0010,
        SLTU = 4'b0011,
        XOR  = 4'b0100,
        SRL  = 4'b0101,
        SRA  = 4'b1101,
        OR   = 4'b0110,
        AND  = 4'b0111
    } alu_op_e;

    // Wire ket noi cac module phu
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
    
    // Lay carry in la bit thu 4 cua i_alu_op
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
            ADD  : o_alu_data = add_sub_result;  // ADD
            SUB  : o_alu_data = add_sub_result;  // SUB
            SLL  : o_alu_data = sll_result;      // SLL
            SLT  : o_alu_data = slt_result;      // SLT
            SLTU : o_alu_data = sltu_result;     // SLTU
            XOR  : o_alu_data = xor_result;      // XOR
            SRL  : o_alu_data = srl_result;      // SRL
            SRA  : o_alu_data = sra_result;      // SRA
            OR   : o_alu_data = or_result;       // OR
            AND  : o_alu_data = and_result;      // AND
            default: o_alu_data = 32'd0;         // Mac dinh
        endcase
    end

endmodule : alu
