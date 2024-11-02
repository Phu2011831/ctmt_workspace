`timescale 1ns / 1ps


module brc_tb;

		logic[31 : 0] 			i_rs1_data;
		logic[31 : 0]			i_rs2_data;
		logic 					i_br_un;
		logic 					o_br_less;
		logic						o_br_equal;
		logic						t_br_less;
		logic						t_br_equal;
		
		brc uut (
		.i_rs1_data(i_rs1_data),
		.i_rs2_data(i_rs2_data),
		.i_br_un(i_br_un),
		.o_br_less(o_br_less),
		.o_br_equal(o_br_equal)
		);
		
		
		
		task tk_expect(input logic t_br_less, input logic t_br_equal);
				$display("[%3d] i_rs1_data = %10h, i_rs2_data = %10h,  i_br_un = %7d, o_br_less = %10h, o_br_equal = %10h, t_br_less = %10h, t_br_equal = %10h", 
										$time, 
										i_rs1_data, 
										i_rs2_data, 
										i_br_un, 
										o_br_less, 
										o_br_equal,
										t_br_less,
										t_br_equal
										);
				assert ((o_br_less == t_br_less) && (o_br_equal == t_br_equal))
				else begin
						$display("TEST FAILED");
				end
		 endtask
		
		initial begin
				
				repeat (100) begin
				i_rs1_data = $urandom;
				//#10
				i_rs2_data = $urandom;
				i_br_un = 1;
				t_br_equal = (i_rs1_data ~^ i_rs2_data) ? 0 : 1;
				t_br_less  = ($unsigned(i_rs1_data) < $unsigned(i_rs2_data)) ? 1 : 0;
				#1 tk_expect(t_br_less, t_br_equal);
				#49;
				end
				
				repeat (100) begin
				i_rs1_data = $random;
				//#10
				i_rs2_data = $random;
				i_br_un = 0;
				t_br_equal = (i_rs1_data ~^ i_rs2_data) ? 0 : 1;
				t_br_less  = ($signed(i_rs1_data) < $signed(i_rs2_data)) ? 1 : 0;
				#1 tk_expect(t_br_less, t_br_equal);
				#49;
				end
				
		 $display("TEST PASSED");
		 $stop;
		 $finish;
				end
endmodule


