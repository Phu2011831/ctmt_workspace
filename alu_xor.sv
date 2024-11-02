module alu_xor (
    input logic [31:0] i_xor_a,  // Toán hạng A
    input logic [31:0] i_xor_b,  // Toán hạng B
    output logic [31:0] o_xor_result  // Kết quả XOR
);
    // Thực hiện phép XOR bitwise
    always_comb begin
        o_xor_result = 32'b0; // Khởi tạo kết quả
        for (int i = 0; i < 32; i++) begin
            o_xor_result[i] = i_xor_a[i] ^ i_xor_b[i]; // XOR từng bit
        end
    end
endmodule: alu_xor
