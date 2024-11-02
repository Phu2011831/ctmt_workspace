module alu_sll (
    input logic [31:0] i_sll_data,   // Dau vao 32 bit
    input logic [4:0] i_sll_shift,   // So bit can dich (tu 0 den 31)
    output logic [31:0] o_sll_result   // Dau ra sau khi dich
);

    logic [31:0] temp_data;

    always_comb begin
        temp_data = i_sll_data;       // Gan gia tri ban dau cho bien trung gian
        // Vong lap dich trai
        for (int i = 0; i < i_sll_shift; i++) begin
            temp_data = {temp_data[30:0], 1'b0};  // Dich trai 1 bit trong moi vong lap
        end
        o_sll_result = temp_data;       // Gan gia tri ket qua cuoi cung vao o_data
    end

endmodule: alu_sll
