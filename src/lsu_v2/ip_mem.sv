`timescale 1ns/1ps

module ip_mem
(
	input  logic 		  i_clk,
	input  logic 		  i_rst,
	input  logic 		  i_lsu_wren,
	
	//input  logic [3:0]		  i_num_byte;	//select bytes for instruction	
	//input  logic 	  i_sig_uns;		//signal for unsigned num
	input  logic [31:0] i_lsu_addr,
	input  logic [31:0] i_st_data,
	input  logic [31:0] i_io_sw,
	input  logic [3:0]  i_io_btn,
	
	//output logic [31:0] o_ld_data
	output logic [31:0] o_ip_data
);

	logic [2:0] addr_sel;
	
	
	logic [3:0][7:0] ip_mem     [0:2**3 -1]; // 7800..781F : 0111_1000_000x_xx'xx : (5-2)-bit address: i_lsu_addr[4:2]
  
	logic [31:0] io_sw_prev;   // state of switch previous
	logic [3:0]  io_push_prev; // state of switch previous
	
	assign addr_sel = {i_lsu_addr[14:13], i_lsu_addr[11]};
	
	always_ff @(posedge i_clk) begin
	//case (i_lsu_addr)
	/* <note>: input peripherals_reg_directly-connected: the first register of each peripheral-mem ranges */
	// Input-peripherals Memory - LSU:
		if (i_io_sw !== io_sw_prev) begin         // continuous get data from switches  // ipmem_addr = 0111_1000_000'x_xxxx'
			ip_mem[3'b0_00][0] <= i_io_sw[ 7: 0];  // ipmem_addr.switch = x7800 : 0111_1000_000'0_00'00   0111_1000_000'0_11'11
			ip_mem[3'b0_00][1] <= i_io_sw[15: 8];
			ip_mem[3'b0_00][2] <= i_io_sw[23:16];
			ip_mem[3'b0_00][3] <= i_io_sw[31:24];
			//$writememh("../mem/in_peri_mem.mem", ip_mem);
			$writememh("C:/New folder/ctmt_workspace/mem/in_perinst_mem.mem", ip_mem);
			io_sw_prev <= i_io_sw; 
		end
		if (i_io_btn !== io_push_prev) begin       	 // continuous get data from buttons  // ipmem_addr = 0111_1000_000'x_xxxx'
			ip_mem[3'b1_00][0][3:0] <= i_io_btn[3:0];  // ipmem_addr.button = x7810 : 0111_1000_000'1_00'00
			ip_mem[3'b1_00][0][7:4] <= 4'b0;
			ip_mem[3'b1_00][1] <= 8'b0;
			ip_mem[3'b1_00][2] <= 8'b0;
			ip_mem[3'b1_00][3] <= 8'b0;
			$writememh("C:/New folder/ctmt_workspace/mem/in_perinst_mem.mem", ip_mem);
			// $writememh("../mem/in_perinst_mem.mem", ip_mem);
			io_push_prev <= i_io_btn; 
		end
		if (!i_rst) begin
			for (int i = 0; i < (2**3); i++) begin
				ip_mem[i] <= 32'h0;
			end
		end
	end

	assign ip_data =(addr_sel == 3'b111) ? ip_mem [i_lsu_addr[4:2]] : 32'b0;
	/*
	ex_ip_data IP_DATA_EXC (			// for lsu when implemented load/store inst
									 .i_num_byte (i_num_byte),
									 .i_sig_uns (i_sig_uns),
									 .i_data (ip_data),
									 .o_data (o_ip_data)
									);
	*/
	IP_DATA_EXC sel_data_o(
									 .i_num_byte (4'b1111),
									 .i_sig_uns (1'b1),
									 .i_data (ip_data),
									 .o_data (o_ip_data)
									);
	
endmodule: ip_mem
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IP_DATA_EXC (
	input logic [3:0] 	i_num_byte,
	input logic 			i_sig_uns,
	input logic [31:0]	i_data,
	output logic [31:0]	o_data
);

	always @(*) begin
		case (i_num_byte)
			4'b0001 : o_data <= (i_sig_uns) ? { {24'b0}, i_data[ 7: 0] } : { {24{i_data[ 7]}}, i_data[ 7: 0] };
			4'b0011 : o_data <= (i_sig_uns) ? { {16'b0}, i_data[15: 0] } : { {16{i_data[15]}}, i_data[15: 0] };
			4'b1111 : o_data <= i_data;
			
				default : o_data = 32'bx;
		endcase
	end
endmodule : IP_DATA_EXC
