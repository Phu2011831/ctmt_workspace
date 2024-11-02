`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// University: HCMUT
// Subject: Computer Architecture
//
// Create Date: 10/12/2024
// Design Name: 
// Module Name: brc
// Project Name: Single Cycle RISC-V Processor 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 1.1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module brc (
			input logic [31 : 0] 	i_rs1_data, 
			input logic [31 : 0] 	i_rs2_data,
			input logic 				i_br_un,
			output logic 				o_br_less, 
			output logic 				o_br_equal
);
			logic [31 : 0]				cal_i_a;
			logic [31 : 0]				cal_i_b;
			
			logic				uns_flag_rs1_lt_rs2; 
			logic				uns_flag_rs1_eq_rs2;
			logic 			s_flag_rs1_lt_rs2; 
			logic				s_flag_rs1_eq_rs2;
			
			unsigned_32bit_comparator  u1(
								.i_a(i_rs1_data), 
								.i_b(i_rs2_data), 
								.i_a_gt_b( 1'b0 ), 
								.i_a_eq_b( 1'b0 ), 
								.i_a_lt_b( 1'b0 ), 
								.a_eq_b(uns_flag_rs1_eq_rs2), 
								.a_lt_b(uns_flag_rs1_lt_rs2)
								);
			
			assign cal_i_a = (~i_rs1_data) + 1'b1;
		
			assign cal_i_b = (~i_rs2_data) + 1'b1;
			
			unsigned_32bit_comparator  u2(
								.i_a(cal_i_a), 
								.i_b(cal_i_b), 
								.i_a_gt_b( 1'b0 ), 
								.i_a_eq_b( 1'b1 ), 
								.i_a_lt_b( 1'b0 ), 
								.a_gt_b(s_flag_rs1_lt_rs2),
								.a_eq_b(s_flag_rs1_eq_rs2)
								);
								
			always@(*)
			begin
					o_br_equal <= uns_flag_rs1_eq_rs2;
					if (i_br_un == 1'b0)
					begin
							if ((i_rs1_data[31] == 1'b1) && (i_rs2_data[31] == 1'b1))
							begin
									o_br_less   <=  s_flag_rs1_lt_rs2;
							end
							if ((i_rs1_data[31] == 1'b1) && (i_rs2_data[31] == 1'b0))
							begin
									o_br_less <= 1'b1;
							end
							if ((i_rs1_data[31] == 1'b0) && (i_rs2_data[31] == 1'b1))
							begin
									o_br_less <= 0;
							end
							if ((i_rs1_data[31] == 1'b0) && (i_rs2_data[31] == 1'b0))
							begin
									o_br_less <= uns_flag_rs1_lt_rs2;
							end
					end
					else 			
					begin
							o_br_equal <= uns_flag_rs1_eq_rs2;
							o_br_less  <= uns_flag_rs1_lt_rs2;
					end		
			end			
endmodule: brc

//////////////////////////////////////////////////////////////////////////////////
// Module Name: unsigned_4bit_comparator 
//
// Description: Compare 2 unsigned 4-bit number
//////////////////////////////////////////////////////////////////////////////////

module unsigned_4bit_comparator(
			input logic [3:0] 			i_a,
			input logic [3:0]				i_b,
			
			output logic 					a_gt_b,
			output logic					a_eq_b,
			output logic					a_lt_b
);

			logic [3:0]			xor_invert;
			
			assign xor_invert = i_a ~^ i_b; //xnor
			
			assign a_eq_b = xor_invert[3] & xor_invert [2] & xor_invert[1] & xor_invert[0];
			
			assign a_gt_b = (i_a[3] & (~i_b[3])) | (xor_invert[3] & i_a[2] & (~i_b[2])) | (xor_invert[3] & xor_invert[2] & i_a[1] & (~i_b[1])) | (xor_invert[3] & xor_invert[2] & xor_invert[1] & i_a[0] & (~i_b[0])) ;
			
			assign a_lt_b = (i_b[3] & (~i_a[3])) | (xor_invert[3] & i_b[2] & (~i_a[2])) | (xor_invert[3] & xor_invert[2] & i_b[1] & (~i_a[1])) | (xor_invert[3] & xor_invert[2] & xor_invert[1] & i_b[0] & (~i_a[0])) ;

endmodule: unsigned_4bit_comparator

//////////////////////////////////////////////////////////////////////////////////
// Module Name: unsigned_4bit_comparator_w_prev
//
// Description: Compare the 4-bit unsigned number, then compare it with flag (the adjacent previous 4-bit comparison result)
//////////////////////////////////////////////////////////////////////////////////

module unsigned_4bit_comparator_w_prev(
			input logic [3:0] 			i_a,
			input logic [3:0]				i_b,
			
			input logic 					i_a_gt_b,
			input logic 					i_a_eq_b,
			input logic 					i_a_lt_b,
			
			output logic 					o_a_gt_b,
			output logic					o_a_eq_b,
			output logic					o_a_lt_b
);
			
			logic cal_a_eq_b, cal_a_gt_b, cal_a_lt_b;
			
			unsigned_4bit_comparator comp(.i_a(i_a) , .i_b(i_b), .a_gt_b(cal_a_gt_b), .a_eq_b(cal_a_eq_b), .a_lt_b(cal_a_lt_b));
			
			assign o_a_gt_b = cal_a_gt_b | (cal_a_gt_b & i_a_gt_b);
		
			assign o_a_eq_b = cal_a_eq_b & i_a_eq_b;

			assign o_a_lt_b = cal_a_lt_b | (cal_a_lt_b & i_a_lt_b); 

endmodule: unsigned_4bit_comparator_w_prev

//////////////////////////////////////////////////////////////////////////////////
// Module Name: unsigned_32bit_comparator 
//
// Description: Compare 2 unsigned 32-bit number
//					 = 4bit_comparator_w_prev [7:0] 
//////////////////////////////////////////////////////////////////////////////////

module unsigned_32bit_comparator(
			input logic [31: 0]			i_a,
			input logic [31: 0]			i_b,
			
			input logic 					i_a_gt_b,
			input logic 					i_a_eq_b,
			input logic 					i_a_lt_b,
			
			output logic 					a_gt_b,
			output logic					a_eq_b,
			output logic					a_lt_b
);

			logic flag_a_gt_b_0, flag_a_eq_b_0, flag_a_lt_b_0;
			logic flag_a_gt_b_1, flag_a_eq_b_1, flag_a_lt_b_1;
			logic flag_a_gt_b_2, flag_a_eq_b_2, flag_a_lt_b_2;
			logic flag_a_gt_b_3, flag_a_eq_b_3, flag_a_lt_b_3;
			logic flag_a_gt_b_4, flag_a_eq_b_4, flag_a_lt_b_4;
			logic flag_a_gt_b_5, flag_a_eq_b_5, flag_a_lt_b_5;
			logic flag_a_gt_b_6, flag_a_eq_b_6, flag_a_lt_b_6;
			logic flag_a_gt_b_7, flag_a_eq_b_7, flag_a_lt_b_7;
			
			unsigned_4bit_comparator_w_prev  comp_4bit_03_00(.i_a(i_a[3:0]),   .i_b(i_b[3:0]),   .i_a_gt_b(i_a_gt_b),      .i_a_eq_b(i_a_eq_b),      .i_a_lt_b(i_a_lt_b),      .o_a_gt_b(flag_a_gt_b_0), .o_a_eq_b(flag_a_eq_b_0), .o_a_lt_b(flag_a_lt_b_0));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_07_04(.i_a(i_a[7:4]),   .i_b(i_b[7:4]),   .i_a_gt_b(flag_a_gt_b_0), .i_a_eq_b(flag_a_eq_b_0), .i_a_lt_b(flag_a_lt_b_0), .o_a_gt_b(flag_a_gt_b_1), .o_a_eq_b(flag_a_eq_b_1), .o_a_lt_b(flag_a_lt_b_1));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_11_08(.i_a(i_a[11:8]),  .i_b(i_b[11:8]),  .i_a_gt_b(flag_a_gt_b_1), .i_a_eq_b(flag_a_eq_b_1), .i_a_lt_b(flag_a_lt_b_1), .o_a_gt_b(flag_a_gt_b_2), .o_a_eq_b(flag_a_eq_b_2), .o_a_lt_b(flag_a_lt_b_2));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_15_12(.i_a(i_a[15:12]), .i_b(i_b[15:12]), .i_a_gt_b(flag_a_gt_b_2), .i_a_eq_b(flag_a_eq_b_2), .i_a_lt_b(flag_a_lt_b_2), .o_a_gt_b(flag_a_gt_b_3), .o_a_eq_b(flag_a_eq_b_3), .o_a_lt_b(flag_a_lt_b_3));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_19_16(.i_a(i_a[19:16]), .i_b(i_b[19:16]), .i_a_gt_b(flag_a_gt_b_3), .i_a_eq_b(flag_a_eq_b_3), .i_a_lt_b(flag_a_lt_b_3), .o_a_gt_b(flag_a_gt_b_4), .o_a_eq_b(flag_a_eq_b_4), .o_a_lt_b(flag_a_lt_b_4));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_23_20(.i_a(i_a[23:20]), .i_b(i_b[23:20]), .i_a_gt_b(flag_a_gt_b_4), .i_a_eq_b(flag_a_eq_b_4), .i_a_lt_b(flag_a_lt_b_4), .o_a_gt_b(flag_a_gt_b_5), .o_a_eq_b(flag_a_eq_b_5), .o_a_lt_b(flag_a_lt_b_5));
			
			unsigned_4bit_comparator_w_prev  comp_4bit_27_24(.i_a(i_a[27:24]), .i_b(i_b[27:24]), .i_a_gt_b(flag_a_gt_b_5), .i_a_eq_b(flag_a_eq_b_5), .i_a_lt_b(flag_a_lt_b_5), .o_a_gt_b(flag_a_gt_b_6), .o_a_eq_b(flag_a_eq_b_6), .o_a_lt_b(flag_a_lt_b_6));
			
			unsigned_4bit_comparator  			comp_4bit_31_28(.i_a(i_a[31:28]), .i_b(i_b[31:28]), .a_gt_b(flag_a_gt_b_7),        .a_eq_b(flag_a_eq_b_7),        .a_lt_b(flag_a_lt_b_7));
						
			assign a_gt_b = (flag_a_eq_b_7 == 1'b1) ? flag_a_gt_b_6 : flag_a_gt_b_7;
			
			assign a_lt_b = (flag_a_eq_b_7 == 1'b1) ? flag_a_lt_b_6 : flag_a_lt_b_7;
			
			assign a_eq_b = flag_a_eq_b_6 & flag_a_eq_b_7;
			
endmodule: unsigned_32bit_comparator

			


			