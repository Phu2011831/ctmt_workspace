module alu_add_sub (
	input logic [31:0] i_add_sub_a,        // Toan hang A
   input logic [31:0] i_add_sub_b,        // Toan hang B
   input logic i_carry_in,        // Carry in (0 cho cong, 1 cho tru)
   output logic [31:0] o_add_sub_result,  // Ket qua
   output logic o_carry_out       // Carry out
);

   logic [31:0] temp;             // Bien trung gian cho phep toan B
	
   // Chon dau vao temp dua tren i_carry_in
   assign temp = i_carry_in ? ~i_add_sub_b : i_add_sub_b; // Neu i_carry_in = 1, lay ~i_add_sub_b (tru), nguoc lai lay i_add_sub_b
	
	//Su dung bo full_adder_32bit de tinh tong/hieu
	full_adder_32bit fa0 (.a(i_add_sub_a), .b(temp), .ci(i_carry_in), .s(o_add_sub_result), .co(o_carry_out));

endmodule: alu_add_sub

// Mo-dun full-adder 1 bit
module full_adder_1bit (
	input  logic a,   // Toan hang 1
   input  logic b,   // Toan hang 2
   input  logic ci,  // Carry in
   output logic s,   // Tong
   output logic co   // Carry out
);
   always_comb begin
       s = a ^ b ^ ci;                // Tong
       co = (a & b) | (ci & (a ^ b)); // Tinh toan carry out
   end
endmodule: full_adder_1bit

// Mo-dun full-adder 8 bit (ghep tu 8 full-adder 1 bit)
module full_adder_8bit (
   input  logic [7:0] a,  // Toan hang A
   input  logic [7:0] b,  // Toan hang B
   input  logic ci,       // Carry vao
   output logic [7:0] s,  // Tong 8 bit
   output logic co        // Carry ra
);
   logic [6:0] carry; // Bien trung gian carry giua cac bit

   // Ket noi cac full-adder 1 bit cho 8 bit du lieu
   full_adder_1bit fa0 (.a(a[0]), .b(b[0]), .ci(ci),       .s(s[0]), .co(carry[0]));
   full_adder_1bit fa1 (.a(a[1]), .b(b[1]), .ci(carry[0]), .s(s[1]), .co(carry[1]));
   full_adder_1bit fa2 (.a(a[2]), .b(b[2]), .ci(carry[1]), .s(s[2]), .co(carry[2]));
   full_adder_1bit fa3 (.a(a[3]), .b(b[3]), .ci(carry[2]), .s(s[3]), .co(carry[3]));
   full_adder_1bit fa4 (.a(a[4]), .b(b[4]), .ci(carry[3]), .s(s[4]), .co(carry[4]));
   full_adder_1bit fa5 (.a(a[5]), .b(b[5]), .ci(carry[4]), .s(s[5]), .co(carry[5]));
   full_adder_1bit fa6 (.a(a[6]), .b(b[6]), .ci(carry[5]), .s(s[6]), .co(carry[6]));
   full_adder_1bit fa7 (.a(a[7]), .b(b[7]), .ci(carry[6]), .s(s[7]), .co(co));
endmodule: full_adder_8bit

// Mo-dun full-adder 32 bit (ghep tu 4 bo full-adder 8 bit)
module full_adder_32bit (
    input  logic [31:0] a,      // Toan hang A
    input  logic [31:0] b,      // Toan hang B
    input  logic ci,            // Carry vao
    output logic [31:0] s,      // Tong 32 bit
    output logic co             // Carry ra
);
    logic [2:0] carry;          // Bien trung gian carry giua cac khoi 8 bit

   // Ket noi cac full-adder 8 bit
	// Bo cong 32 bit chia thanh 4 khoi 8 bit
   full_adder_8bit fa0 (.a(a[7:0]),   .b(b[7:0]),   .ci(ci), .s(s[7:0]),   .co(carry[0]));
   full_adder_8bit fa1 (.a(a[15:8]),  .b(b[15:8]),  .ci(carry[0]),   .s(s[15:8]),  .co(carry[1]));
   full_adder_8bit fa2 (.a(a[23:16]), .b(b[23:16]), .ci(carry[1]),   .s(s[23:16]), .co(carry[2]));
   full_adder_8bit fa3 (.a(a[31:24]), .b(b[31:24]), .ci(carry[2]),   .s(s[31:24]), .co(co));
endmodule: full_adder_32bit
