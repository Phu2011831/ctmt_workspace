module pc_debug_reg (
	input logic i_clk,
	input logic i_rst,
	input logic [31:0] i_pc,
	output logic [31:0] o_pc_debug
);
	
	always_ff @(posedge i_clk) begin
		if (!i_rst) begin
			o_pc_debug = 32'b0;
		end else begin
			o_pc_debug = i_pc;
		end
	end
endmodule: pc_debug_reg
	