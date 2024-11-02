module pc_reg (
    input  logic          i_clk,     // Tin hieu dong bo
    input  logic          i_rst,     // Tin hieu reset, kich hoat muc thap
    input  logic          i_pc_wren,    // Tin hieu cho phep ghi
    input  logic [31:0]   i_pc_next, // Gia tri con tro PC ke tiep
    output logic [31:0]   o_pc      // Gia tri con tro PC hien tai
);

    // Lay canh len xung clock hoac tin hieu reset
    always_ff @(posedge i_clk) begin
        // Neu reset bat, tra PC ve 0
        if (!i_rst) begin 
            o_pc <= 32'd0;
        // Neu tin hieu cho phep ghi bat, cap nhat PC voi gia tri moi
        end else if (i_pc_wren) begin
            o_pc <= i_pc_next;
        // Khong thay doi gia tri cua PC neu i_wren tat
        end
    end
endmodule: pc_reg
