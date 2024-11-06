module instr_mem (
    input logic i_clk,         // tin hieu dong bo
    input logic i_rst,         // tin hieu reset
    input logic [31:0] i_pc,   // dia chi bo nho chuong trinh
    output logic [31:0] o_instr // du lieu bo nho chuong trinh
);

    // Mang chua du lieu lenh tu file (8KB bo nho lenh, moi dong la 32-bit)
    logic [31:0] instr_data [0:2047]; // 8KB = 2048 x 32-bit

    // Nap du lieu tu file "mem.txt" vao mang instr_data
    initial begin
        $readmemh("C:\\altera\\13.0sp1\\milestone2\\02_test\\dump\\mem.txt", instr_data);
    end

    // Doc lenh tu bo nho theo dia chi PC
    always_ff @(posedge i_clk) begin
        if (!i_rst) begin
            // Khoi tao gia tri cua mang instr_data ve 0 khi reset
            for (int i = 0; i < 2048; i++) begin
                instr_data[i] = 32'b0;
            end
            o_instr <= 32'b0; // Dat gia tri output instruction ve 0 khi reset
        end 
        else begin
            o_instr <= instr_data[i_pc[12:2]]; // Lay du lieu tu bo nho dua tren dia chi PC
        end
    end
endmodule : instr_mem
