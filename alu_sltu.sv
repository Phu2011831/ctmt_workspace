module alu_sltu (
   input logic [31:0] i_sltu_a,  // Toan hang A
   input logic [31:0] i_sltu_b,  // Toan hang B
   output logic o_sltu_result    // Ket qua SLTU
);

   logic a_temp, b_temp; // Bien tam cho 1 bit cua A va B

   always_comb begin
      o_sltu_result = 1'b0; // Khoi tao ket qua mac dinh bang 0

      // So sanh tung bit tu MSB den LSB
      for (int i = 31; i >= 0; i--) begin
         a_temp = i_sltu_a[i];  // Lay bit thu i cua A
         b_temp = i_sltu_b[i];  // Lay bit thu i cua B

			//Neu gia tri bit i cua A = gia tri bit i cua B thi qua bit thu i-1
         if (a_temp != b_temp) begin //Neu khac nhau thi xet bit cua A
            if (a_temp) begin
               // Neu bit A = 1, bit B = 0 -> ket qua la 0
               o_sltu_result = 1'b0;
            end else begin
               // Neu bit A = 0, bit B = 1 -> ket qua la 1
               o_sltu_result = 1'b1;
            end
            break; // Thoat khoi vong lap khi da co ket qua
         end
      end
   end

endmodule: alu_sltu
