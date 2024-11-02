module insn_vld_reg (
	input logic i_clk,
	input logic i_rst,
	input logic i_insn_vld,
	output logic o_insn_vld
);

	always_ff @(posedge i_clk) begin
		if (!i_rst) begin
			o_insn_vld = 1'b0;
		end else begin
			o_insn_vld = i_insn_vld;
		end
	end
endmodule: insn_vld_reg