module regfile (
	input	 logic 		  i_clk,			//Tin hieu clock
   input	 logic        i_rst,			//Tin hieu reset
   input  logic 		  i_rd_wren,	//Tin hieu cho phep ghi
   input  logic [4:0]  i_rd_addr,	//Dia chi ghi rd
   input  logic [4:0]  i_rs1_addr,	//Dia chi doc rs1
   input  logic [4:0]  i_rs2_addr,	//Dia chi doc rs2
	input  logic [31:0] i_rd_data,	//Du lieu ghi theo rd
	output logic [31:0] o_rs1_data,	//Du lieu doc theo rs1
   output logic [31:0] o_rs2_data	//Du lieu doc theo rs2
);

	//Tap thanh ghi gom 32 thanh ghi, moi thanh ghi co do rong 32bit
   logic [31:0] register_file [31:0];

   //Khoi doc khong dong bo
	always_comb begin
		o_rs1_data = (|i_rs1_addr) ? register_file[i_rs1_addr] : 32'd0;
		o_rs2_data = (|i_rs2_addr) ? register_file[i_rs2_addr] : 32'd0;
	end
	
   //Khoi ghi dong bo
   always_ff @(posedge i_clk) begin
		if (!i_rst) begin
			//Dat lai cac thanh ghi tu 1 den 31 ve 0
         for (int i = 1; i < 32; i++) begin
				register_file[i] <= 32'd0;
         end
		end else if (i_rd_wren && (|i_rd_addr)) begin
			//Ghi du lieu vao tap thanh ghi neu i_rd_wren duoc bat va i_rd_addr khac 0
			register_file[i_rd_addr] <= i_rd_data;
		end
	end
endmodule: regfile
