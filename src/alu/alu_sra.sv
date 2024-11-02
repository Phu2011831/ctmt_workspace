module alu_sra (
   input logic [31:0] i_sra_data,   // Toan hang A
   input logic [4:0] i_sra_shift,   // So bit de dich
   output logic [31:0] o_sra_result // Ket qua
);

   logic [31:0] temp_data; // Bien tam thoi luu ket qua sau moi lan dich
	logic sign_bit;         // Bien luu tru bit dau (MSB)

   // Luu bit dau (MSB cua i_sra_data)
   assign sign_bit = i_sra_data[31]; 

   always_comb begin
		// Gan gia tri ban dau cho bien tam
		temp_data = i_sra_data;
		
      // Thuc hien dich phai tung bit
      for (int i = 0; i < i_sra_shift; i++) begin
			// Dich phai, giu nguyen bit dau
         temp_data = {sign_bit, temp_data[31:1]}; 
      end
		
      // Gan ket qua cho output
      o_sra_result = temp_data;
    end
endmodule: alu_sra
