`timescale 1ns/1ps

module op_mem
(
	input  logic 		  i_clk,
	input  logic 		  i_rst,
	input  logic 		  i_lsu_wren,
	
	//input  logic [3:0]		  i_num_byte;	//select bytes for instruction	
	
	//input  logic 	  i_sig_uns;		//signal for unsigned num
	input  logic [31:0] i_lsu_addr,
	input  logic [31:0] i_op_data,
	input  logic [31:0] i_io_sw,
	input  logic [3:0]  i_io_btn,
	
	output logic [31:0] o_io_lcd,
	output logic [31:0] o_io_ledg,
	output logic [31:0] o_io_ledr,
  
	output logic [ 6:0] o_io_hex0,
	output logic [ 6:0] o_io_hex1,
	output logic [ 6:0] o_io_hex2,
	output logic [ 6:0] o_io_hex3,
	output logic [ 6:0] o_io_hex4,
	output logic [ 6:0] o_io_hex5,
	output logic [ 6:0] o_io_hex6,
	output logic [ 6:0] o_io_hex7,
	
	output logic [31:0] o_op_data
);

	logic [2:0] addr_sel;	
	
	logic [3:0][7:0] op_mem     [0:2**5 -1]; // 7000..703F : 0111_0000_0xxx_xx'xx : (7-2)-bit address: addr_i[6:2]
  
	assign addr_sel = {i_lsu_addr[14:13], i_lsu_addr[11]};

	always_ff @(posedge i_clk) begin
	// Output-peripherals Memory - LSU:
		 if ((i_lsu_addr[15:11]==5'b0111_0 ) && (i_lsu_wren)) begin  // opmem_addr = 0111_0000_0'xxx_xx'xx			- 70(00->7f)
			//if (i_num_byte[0]) begin
				op_mem[i_lsu_addr[6:2]][0] <= i_op_data[ 7: 0];
			//end
			//if (i_num_byte[1]) begin
				op_mem[i_lsu_addr[6:2]][1] <= i_op_data[15: 8];
			//end
			//if (i_num_byte[2]) begin
				op_mem[i_lsu_addr[6:2]][2] <= i_op_data[23:16];
			//end
			//if (i_num_byte[3]) begin
				op_mem[i_lsu_addr[6:2]][3] <= i_op_data[31:24];
			//end
   end
	if (!i_rst) begin
     for (int i = 0; i < (2**5); i++) begin
        op_mem[i] <= 32'h0;
      end
    end

	$writememh("C:/New folder/ctmt_workspace/mem/out_perinst_mem.mem", op_mem);
	end
	 
	// Output-Peripheral connects directly ( with opmem_addr: 0111_1000_0[xxx_xxxx] )
	assign  o_io_ledr =  op_mem[5'b000_00];       // op_mem.ledr = x7000 = 0111_0000_0'000_0000'
	assign  o_io_ledg =  op_mem[5'b001_00];       // op_mem.ledg = x7010 = 0111_0000_0'001_0000'
  
	assign  o_io_hex7 =  op_mem[5'b010_01][3][6:0];  // op_mem.hex7 = x7024 = 0111_0000_0'010_0111'
	assign  o_io_hex6 =  op_mem[5'b010_01][2][6:0];  // op_mem.hex6 = x7024 = 0111_0000_0'010_0110'
	assign  o_io_hex5 =  op_mem[5'b010_01][1][6:0];  // op_mem.hex5 = x7024 = 0111_0000_0'010_0101'
	assign  o_io_hex4 =  op_mem[5'b010_01][0][6:0];  // op_mem.hex4 = x7024 = 0111_0000_0'010_0100'
  
	assign  o_io_hex3 =  op_mem[5'b010_00][3][6:0];  // op_mem.hex3 = x7020 = 0111_0000_0'010_0011'
	assign  o_io_hex2 =  op_mem[5'b010_00][2][6:0];  // op_mem.hex2 = x7020 = 0111_0000_0'010_0010'
	assign  o_io_hex1 =  op_mem[5'b010_00][1][6:0];  // op_mem.hex1 = x7020 = 0111_0000_0'010_0001'
	assign  o_io_hex0 =  op_mem[5'b010_00][0][6:0];  // op_mem.hex0 = x7020 = 0111_0000_0'010_0000'

	assign  o_io_lcd  =  op_mem[5'b101_00];       // op_mem.lcd  = x7030 = 0111_0000_0'101_0000'
 
	 
	assign op_data =(addr_sel == 3'b110) ? op_mem[i_lsu_addr[6:2]] : 32'b0;
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
									 .i_data (op_data),
									 .o_data (o_op_data)
									);
	
endmodule: op_mem
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
