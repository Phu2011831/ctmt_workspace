module pc_four (
	input logic [31:0] i_pc,
	output logic [31:0] o_pc_four
);

	//Lay con tro pc + 4
	assign o_pc_four = i_pc +4;
endmodule: pc_four
	