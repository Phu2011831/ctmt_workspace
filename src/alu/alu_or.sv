module alu_or (
    input logic [31:0] i_or_a,  // Toán hạng A
    input logic [31:0] i_or_b,  // Toán hạng B
    output logic [31:0] o_or_result  // Kết quả OR
);
    // Thực hiện phép OR bitwise
    always_comb begin
        o_or_result = 32'b0; // Khởi tạo kết quả
        for (int i = 0; i < 32; i++) begin
            o_or_result[i] = i_or_a[i] | i_or_b[i]; // OR từng bit
        end
    end
endmodule: alu_or
