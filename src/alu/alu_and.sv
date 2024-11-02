module alu_and (
   input logic [31:0] i_and_a,  // Toan hang A
   input logic [31:0] i_and_b,  // Toan hang B
   output logic [31:0] o_and_result  // Ket qua AND
);
	
   // Thuc hien phep AND bitwise
   always_comb begin
		o_and_result = 32'b0; // Khoi tao ket qua ve 0
      for (int i = 0; i < 32; i++) begin
			o_and_result[i] = i_and_a[i] & i_and_b[i]; // AND tung bit
      end
   end
endmodule: alu_and
