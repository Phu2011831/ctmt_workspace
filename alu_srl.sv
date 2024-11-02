module alu_srl (
    input logic [31:0] i_srl_data,   // Dau vao 32 bit
    input logic [4:0] i_srl_shift,   // So bit can dich (tu 0 den 31)
    output logic [31:0] o_srl_result   // Dau ra sau khi dich
);
    logic [31:0] temp_data;

    always_comb begin
        temp_data = i_srl_data;       // Gan gia tri ban dau cho bien trung gian
        // Vong lap dich phai
        for (int i = 0; i < i_srl_shift; i++) begin
            temp_data = {1'b0, temp_data[31:1]};  // Dich phai 1 bit trong moi vong lap
        end
        o_srl_result = temp_data;       // Gan gia tri ket qua cuoi cung vao o_srl_data
    end

endmodule: alu_srl
