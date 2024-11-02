module brc (
	input logic [31 : 0] i_rs1_data, // Dữ liệu từ thanh ghi đầu tiên
	input logic [31 : 0] i_rs2_data, // Dữ liệu từ thanh ghi thứ hai
	input logic i_br_un,             // Chế độ so sánh (1 nếu có dấu, 0 nếu không có dấu)
	output logic o_br_less,          // Kết quả là 1 nếu rs1 < rs2
	output logic o_br_equal          // Kết quả là 1 nếu rs1 = rs2
);
	logic [31 : 0] rs1_neg;          // Giá trị âm của rs1
	logic [31 : 0] rs2_neg;          // Giá trị âm của rs2
	logic u_flag_lt;                 // Cờ cho so sánh không có dấu
	logic u_flag_eq;                 // Cờ cho so sánh bằng không có dấu
	logic s_flag_lt;                 // Cờ cho so sánh có dấu
	logic s_flag_eq;                 // Cờ cho so sánh bằng có dấu
	
	// So sánh không có dấu
	unsigned_32bit_comparator u1(
		.i_a(i_rs1_data), 
		.i_b(i_rs2_data), 
		.i_a_gt_b( 1'b0 ), 
		.i_a_eq_b( 1'b0 ), 
		.i_a_lt_b( 1'b0 ), 
		.a_eq_b(u_flag_eq), 
		.a_lt_b(u_flag_lt)
	);
	
	assign rs1_neg = (~i_rs1_data) + 1'b1; // Tính giá trị âm của rs1
	assign rs2_neg = (~i_rs2_data) + 1'b1; // Tính giá trị âm của rs2
	
	// So sánh có dấu
	unsigned_32bit_comparator u2(
		.i_a(rs1_neg), 
		.i_b(rs2_neg), 
		.i_a_gt_b( 1'b0 ), 
		.i_a_eq_b( 1'b1 ), 
		.i_a_lt_b( 1'b0 ), 
		.a_gt_b(s_flag_lt),
		.a_eq_b(s_flag_eq)
	);
	
	// Xử lý kết quả so sánh
	always@(*) begin
		o_br_equal <= u_flag_eq; // Gán kết quả so sánh bằng
		if (i_br_un == 1'b0) begin
			if ((i_rs1_data[31] == 1'b1) && (i_rs2_data[31] == 1'b1)) begin
				o_br_less <= s_flag_lt; // So sánh có dấu
			end 
			if ((i_rs1_data[31] == 1'b1) && (i_rs2_data[31] == 1'b0)) begin
				o_br_less <= 1'b1; // rs1 < rs2
			end 
			if ((i_rs1_data[31] == 1'b0) && (i_rs2_data[31] == 1'b1)) begin
				o_br_less <= 0; // rs1 >= rs2
			end 
			if ((i_rs1_data[31] == 1'b0) && (i_rs2_data[31] == 1'b0)) begin
				o_br_less <= u_flag_lt; // So sánh không có dấu
			end
		end else begin
			o_br_equal <= u_flag_eq; // Gán kết quả so sánh bằng
			o_br_less <= u_flag_lt;  // Gán kết quả so sánh nhỏ hơn
		end		
	end			
endmodule: brc

module unsigned_4bit_comparator(
	input logic [3:0] i_a, // Dữ liệu đầu vào a (4 bit)
	input logic [3:0] i_b, // Dữ liệu đầu vào b (4 bit)
	output logic a_gt_b,   // Kết quả là a > b
	output logic a_eq_b,   // Kết quả là a = b
	output logic a_lt_b    // Kết quả là a < b
);
	
	logic [3:0] xor_invert; // Biến lưu trữ kết quả XNOR
	
	assign xor_invert = i_a ~^ i_b; // Tính XNOR giữa a và b
	
	// Kiểm tra xem a và b có bằng nhau hay không
	assign a_eq_b = xor_invert[3] & xor_invert[2] & xor_invert[1] & xor_invert[0];
	
	// Kiểm tra a > b
	assign a_gt_b = (i_a[3] & (~i_b[3])) | (xor_invert[3] & i_a[2] & (~i_b[2])) | 
	                 (xor_invert[3] & xor_invert[2] & i_a[1] & (~i_b[1])) | 
	                 (xor_invert[3] & xor_invert[2] & xor_invert[1] & i_a[0] & (~i_b[0]));
	
	// Kiểm tra a < b
	assign a_lt_b = (i_b[3] & (~i_a[3])) | (xor_invert[3] & i_b[2] & (~i_a[2])) | 
	                 (xor_invert[3] & xor_invert[2] & i_b[1] & (~i_a[1])) | 
	                 (xor_invert[3] & xor_invert[2] & xor_invert[1] & i_b[0] & (~i_a[0]));

endmodule: unsigned_4bit_comparator

module unsigned_4bit_comparator_w_prev(
	input logic [3:0] i_a, // Dữ liệu đầu vào a (4 bit)
	input logic [3:0] i_b, // Dữ liệu đầu vào b (4 bit)
	input logic i_a_gt_b,  // Kết quả a > b từ lần so sánh trước
	input logic i_a_eq_b,  // Kết quả a = b từ lần so sánh trước
	input logic i_a_lt_b,  // Kết quả a < b từ lần so sánh trước
	output logic o_a_gt_b, // Kết quả a > b
	output logic o_a_eq_b, // Kết quả a = b
	output logic o_a_lt_b  // Kết quả a < b
);
	
	logic cal_a_eq_b, cal_a_gt_b, cal_a_lt_b; // Các biến lưu trữ kết quả so sánh
	
	// Sử dụng bộ so sánh 4 bit để tính toán
	unsigned_4bit_comparator comp(.i_a(i_a) , .i_b(i_b), .a_gt_b(cal_a_gt_b), .a_eq_b(cal_a_eq_b), .a_lt_b(cal_a_lt_b));
	
	// Gán kết quả cho đầu ra
	assign o_a_gt_b = cal_a_gt_b | (cal_a_gt_b & i_a_gt_b);
	assign o_a_eq_b = cal_a_eq_b & i_a_eq_b;
	assign o_a_lt_b = cal_a_lt_b | (cal_a_lt_b & i_a_lt_b); 

endmodule: unsigned_4bit_comparator_w_prev

module unsigned_32bit_comparator(
	input logic [31: 0] i_a, // Dữ liệu đầu vào a (32 bit)
	input logic [31: 0] i_b, // Dữ liệu đầu vào b (32 bit)
	input logic i_a_gt_b,   // Kết quả a > b từ lần so sánh trước
	input logic i_a_eq_b,   // Kết quả a = b từ lần so sánh trước
	input logic i_a_lt_b,   // Kết quả a < b từ lần so sánh trước
	output logic a_gt_b,    // Kết quả a > b
	output logic a_eq_b,    // Kết quả a = b
	output logic a_lt_b     // Kết quả a < b
);
	
	// Các cờ tạm để lưu trữ kết quả so sánh
	logic flag_a_gt_b_0, flag_a_eq_b_0, flag_a_lt_b_0;
	logic flag_a_gt_b_1, flag_a_eq_b_1, flag_a_lt_b_1;
	logic flag_a_gt_b_2, flag_a_eq_b_2, flag_a_lt_b_2;
	logic flag_a_gt_b_3, flag_a_eq_b_3, flag_a_lt_b_3;
	logic flag_a_gt_b_4, flag_a_eq_b_4, flag_a_lt_b_4;
	logic flag_a_gt_b_5, flag_a_eq_b_5, flag_a_lt_b_5;
	logic flag_a_gt_b_6, flag_a_eq_b_6, flag_a_lt_b_6;
	logic flag_a_gt_b_7, flag_a_eq_b_7, flag_a_lt_b_7;
	
	// Tiếp tục thực hiện so sánh từng nhóm 4 bit
	unsigned_4bit_comparator_w_prev comp_4bit_03_00(
		.i_a(i_a[3:0]), 
		.i_b(i_b[3:0]), 
		.i_a_gt_b(i_a_gt_b), 
		.i_a_eq_b(i_a_eq_b), 
		.i_a_lt_b(i_a_lt_b), 
		.o_a_gt_b(flag_a_gt_b_0), 
		.o_a_eq_b(flag_a_eq_b_0), 
		.o_a_lt_b(flag_a_lt_b_0)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_07_04(
		.i_a(i_a[7:4]), 
		.i_b(i_b[7:4]), 
		.i_a_gt_b(flag_a_gt_b_0), 
		.i_a_eq_b(flag_a_eq_b_0), 
		.i_a_lt_b(flag_a_lt_b_0), 
		.o_a_gt_b(flag_a_gt_b_1), 
		.o_a_eq_b(flag_a_eq_b_1), 
		.o_a_lt_b(flag_a_lt_b_1)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_11_08(
		.i_a(i_a[11:8]), 
		.i_b(i_b[11:8]), 
		.i_a_gt_b(flag_a_gt_b_1), 
		.i_a_eq_b(flag_a_eq_b_1), 
		.i_a_lt_b(flag_a_lt_b_1), 
		.o_a_gt_b(flag_a_gt_b_2), 
		.o_a_eq_b(flag_a_eq_b_2), 
		.o_a_lt_b(flag_a_lt_b_2)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_15_12(
		.i_a(i_a[15:12]), 
		.i_b(i_b[15:12]), 
		.i_a_gt_b(flag_a_gt_b_2), 
		.i_a_eq_b(flag_a_eq_b_2), 
		.i_a_lt_b(flag_a_lt_b_2), 
		.o_a_gt_b(flag_a_gt_b_3), 
		.o_a_eq_b(flag_a_eq_b_3), 
		.o_a_lt_b(flag_a_lt_b_3)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_19_16(
		.i_a(i_a[19:16]), 
		.i_b(i_b[19:16]), 
		.i_a_gt_b(flag_a_gt_b_3), 
		.i_a_eq_b(flag_a_eq_b_3), 
		.i_a_lt_b(flag_a_lt_b_3), 
		.o_a_gt_b(flag_a_gt_b_4), 
		.o_a_eq_b(flag_a_eq_b_4), 
		.o_a_lt_b(flag_a_lt_b_4)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_23_20(
		.i_a(i_a[23:20]), 
		.i_b(i_b[23:20]), 
		.i_a_gt_b(flag_a_gt_b_4), 
		.i_a_eq_b(flag_a_eq_b_4), 
		.i_a_lt_b(flag_a_lt_b_4), 
		.o_a_gt_b(flag_a_gt_b_5), 
		.o_a_eq_b(flag_a_eq_b_5), 
		.o_a_lt_b(flag_a_lt_b_5)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_27_24(
		.i_a(i_a[27:24]), 
		.i_b(i_b[27:24]), 
		.i_a_gt_b(flag_a_gt_b_5), 
		.i_a_eq_b(flag_a_eq_b_5), 
		.i_a_lt_b(flag_a_lt_b_5), 
		.o_a_gt_b(flag_a_gt_b_6), 
		.o_a_eq_b(flag_a_eq_b_6), 
		.o_a_lt_b(flag_a_lt_b_6)
	);
	
	unsigned_4bit_comparator_w_prev comp_4bit_31_28(
		.i_a(i_a[31:28]), 
		.i_b(i_b[31:28]), 
		.i_a_gt_b(flag_a_gt_b_6), 
		.i_a_eq_b(flag_a_eq_b_6), 
		.i_a_lt_b(flag_a_lt_b_6), 
		.o_a_gt_b(flag_a_gt_b_7), 
		.o_a_eq_b(flag_a_eq_b_7), 
		.o_a_lt_b(flag_a_lt_b_7)
	);
	
	// Gán kết quả cuối cùng
	assign a_gt_b = flag_a_gt_b_7;
	assign a_eq_b = flag_a_eq_b_7;
	assign a_lt_b = flag_a_lt_b_7;
	
endmodule: unsigned_32bit_comparator
