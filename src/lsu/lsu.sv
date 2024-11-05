`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// University: HCMUT
// Subject: Computer Architecture
//
// Create Date: 10/12/2024
// Design Name: 
// Module Name: lsu
// Project Name: Single Cycle RISC-V Processor 
// Target Devices: 
// Tool Versions: 
// Description: LOAD-STORE UNIT and LOAD/STORE INSTRUCTION
// 
// Dependencies: 
// 
// Revision:
// Revision 1.1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lsu
(
  input  logic i_clk,
  input  logic i_rst,
  
  input  logic i_lsu_wren,  // write/store enable
  
  input  logic i_ld_uns,  			  // bonus signal for unsigned load/store instructions
  
  
  input  logic [ 3:0] i_num_byte,  // bonus signal for byte/half-word/word load/store instructions
  input  logic [31:0] i_lsu_addr,
  
  input  logic [31:0] i_st_data,
  input  logic [31:0] i_io_sw,
  input  logic [ 3:0] i_io_btn,
  
  output logic [31:0] o_ld_data,
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
  output logic [ 6:0] o_io_hex7
 );
  // Arrays; mem[1:0] = byte_address (4Byte), assign by [3:0] of mem
  logic [3:0][7:0] inst_mem   [0:2**12-1]; // 0000..1FFF : 000x_xxxx_xxxx_xx'xx : 8KB = (2**11).(4B): 11-bit addr
  logic [3:0][7:0] data_mem   [0:2**12-1]; // 2000..3FFF : 001x_xxxx_xxxx_xx'xx : 8KB = (2**11).(4B): 9-bit addr 
  logic [3:0][7:0] op_mem  [0:2**5 -1]; // 7000..703F : 0111_0000_0xxx_xx'xx : (7-2)-bit address: i_lsu_addr[6:2]
  logic [3:0][7:0] ip_mem  [0:2**3 -1]; // 7800..781F : 0111_1000_000x_xx'xx : (5-2)-bit address: i_lsu_addr[4:2]
  
  // Temp logics
  logic [31:0] ld_data_im;
  logic [31:0] ld_data_d ;
  logic [31:0] o_ld_datap;
  logic [31:0] ld_data_ip;
  logic [31:0] ld_data_ue;
  
  logic [31:0] io_sw_prev;
  logic [ 3:0] io_push_prev;
  
  logic [2:0] addr_sel;
  assign addr_sel = {i_lsu_addr[14:13],i_lsu_addr[11]} ;
  
  // Instruction Memory - LSU:
  //initial begin $readmemh("../02_test/dump/mem.dump", inst_mem);
  //end
  // LOAD-STORE UNIT
  always_ff @(posedge i_clk) begin : STORE_TO_MEMS
  // Data Memory - LSU:
  if ( (i_lsu_addr[15:13]==3'b001 )  && i_lsu_wren) begin  // dmem_addr = 001'x_xxxx_xxxx_xx'xx
      if (i_num_byte[0]) begin
        data_mem[i_lsu_addr[11:2]][0] <= i_st_data[ 7: 0];
      end
      if (i_num_byte[1]) begin
        data_mem[i_lsu_addr[11:2]][1] <= i_st_data[15: 8];
      end
      if (i_num_byte[2]) begin
        data_mem[i_lsu_addr[11:2]][2] <= i_st_data[23:16];
      end
      if (i_num_byte[3]) begin
        data_mem[i_lsu_addr[11:2]][3] <= i_st_data[31:24];
      end
    end
  // Output-peripherals Memory - LSU:
   if ((i_lsu_addr[15:11]==5'b0111_0 ) && (i_lsu_wren)) begin  // opmem_addr = 0111_0000_0'xxx_xx'xx			- 70(00->7f)
      if (i_num_byte[0]) begin
        op_mem[i_lsu_addr[6:2]][0] <= i_st_data[ 7: 0];
      end
      if (i_num_byte[1]) begin
        op_mem[i_lsu_addr[6:2]][1] <= i_st_data[15: 8];
      end
      if (i_num_byte[2]) begin
        op_mem[i_lsu_addr[6:2]][2] <= i_st_data[23:16];
      end
      if (i_num_byte[3]) begin
        op_mem[i_lsu_addr[6:2]][3] <= i_st_data[31:24];
      end
    end
   if (!i_rst) begin
     for (int i = 0; i < (2**11); i++) begin
         data_mem[i] <= 32'h0;
    end
     for (int i = 0; i < (2**5); i++) begin
        op_mem[i] <= 32'h0;
      end
    end
  $writememh("../.../data_mem.mem"    ,  data_mem);
  $writememh("../.../out_perinst_mem.mem", op_mem);
  end
  always_ff @(posedge i_clk) begin
  /* <note>: input peripherals_reg_directly-connected: the first register of each peripheral-mem ranges */
  // Input-peripherals Memory - LSU:
    if (i_io_sw !== io_sw_prev) begin         // continuous get data from switches  // ipmem_addr = 0111_1000_000'x_xxxx'
      ip_mem[3'b0_00][0] <= i_io_sw[ 7: 0];  // ipmem_addr.switch = x7800 : 0111_1000_000'0_00'00
      ip_mem[3'b0_00][1] <= i_io_sw[15: 8];
      ip_mem[3'b0_00][2] <= i_io_sw[23:16];
      ip_mem[3'b0_00][3] <= i_io_sw[31:24];
      $writememh("../.../in_perinst_mem.mem", ip_mem);
      io_sw_prev <= i_io_sw; 
    end
    if (i_io_btn !== io_push_prev) begin       // continuous get data from buttons  // ipmem_addr = 0111_1000_000'x_xxxx'
      ip_mem[3'b1_00][0][3:0] <= i_io_btn[3:0];  // ipmem_addr.button = x7810 : 0111_1000_000'1_00'00
      ip_mem[3'b1_00][0][7:4] <= 4'b0;
      ip_mem[3'b1_00][1] <= 8'b0;
      ip_mem[3'b1_00][2] <= 8'b0;
      ip_mem[3'b1_00][3] <= 8'b0;
      $writememh("../.../in_perinst_mem.mem", ip_mem);
      io_push_prev <= i_io_btn; 
    end
    if (!i_rst) begin
      for (int i = 0; i < (2**3); i++) begin
        ip_mem[i] <= 32'h0;
      end
    end
  end

  // Output-Peripheral connects directly ( with opmem_addr: 0111_1000_0[xxx_xxxx] )
  assign  o_io_ledr =  op_mem[7'b000_0000];       // op_mem.ledr = x7000 = 0111_0000_0'000_0000'
  assign  o_io_ledg =  op_mem[7'b001_0000];       // op_mem.ledg = x7010 = 0111_0000_0'001_0000'
  assign  o_io_hex7 =  op_mem[7'b010_0111][6:0];  // op_mem.hex7 = x7027 = 0111_0000_0'010_0111'
  assign  o_io_hex6 =  op_mem[7'b010_0110][6:0];  // op_mem.hex6 = x7026 = 0111_0000_0'010_0110'
  assign  o_io_hex5 =  op_mem[7'b010_0101][6:0];  // op_mem.hex5 = x7025 = 0111_0000_0'010_0101'
  assign  o_io_hex4 =  op_mem[7'b010_0100][6:0];  // op_mem.hex4 = x7024 = 0111_0000_0'010_0100'
  assign  o_io_hex3 =  op_mem[7'b010_0011][6:0];  // op_mem.hex3 = x7023 = 0111_0000_0'010_0011'
  assign  o_io_hex2 =  op_mem[7'b010_0010][6:0];  // op_mem.hex2 = x7022 = 0111_0000_0'010_0010'
  assign  o_io_hex1 =  op_mem[7'b010_0001][6:0];  // op_mem.hex1 = x7021 = 0111_0000_0'010_0001'
  assign  o_io_hex0 =  op_mem[7'b010_0000][6:0];  // op_mem.hex0 = x7020 = 0111_0000_0'010_0000'
  assign  o_io_lcd  =  op_mem[7'b101_0000];       // op_mem.lcd  = x7030 = 0111_0000_0'101_0000'

  // Load-out:
  assign  ld_data_d   =   data_mem[i_lsu_addr[11:2]];
  assign  ld_data_im  =   inst_mem[i_lsu_addr[11:2]];
  assign  o_ld_datap  =  op_mem[i_lsu_addr[ 6:2]];
  assign  ld_data_ip  =  ip_mem[i_lsu_addr[ 4:2]];

  lsu_mux3to1_32b LD_Sel (
                           .sel_i ( addr_sel   ),
                           .inm_i ( ld_data_im ),
                           .dam_i ( ld_data_d  ),
                           .opm_i ( o_ld_datap ),
                           .ipm_i ( ld_data_ip ),
                           .data_o( ld_data_ue ));
  
  ld_data     LD_Ext (
                           .i_ld_uns   ( i_ld_uns     ),
                           .mem_num_i ( i_num_byte  ),
                           .data_i    ( ld_data_ue  ),
                           .data_ext_o( o_ld_data )
									);

endmodule: lsu

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lsu_data_mux3to1( // select data to execute
  input  logic [ 2:0]  sel_i,
  input  logic [31:0]  inm_i,
  input  logic [31:0]  dam_i,
  input  logic [31:0]  opm_i,
  input  logic [31:0]  ipm_i,
  output logic [31:0]  data_o
);
  assign data_o = (sel_i[2:1] == 2'b00  ) ? inm_i :
                  (sel_i[2:1] == 2'b01  ) ? dam_i :
                  (sel_i      == 3'b110 ) ? opm_i :
                  (sel_i      == 3'b111 ) ? ipm_i : 32'b0;

endmodule: lsu_data_mux3to1
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ld_data( // execute data
  input  logic i_ld_uns,
  input  logic [ 3:0] mem_num_i,
  input  logic [31:0] data_i,
  output logic [31:0] data_ext_o
);
  always @ (*) begin
    case (mem_num_i)
     4'b0001: data_ext_o <= ( i_ld_uns ) ? { {24'b0}, data_i[ 7: 0] } : { {24{data_i[ 7]}}, data_i[ 7: 0] };
     4'b0011: data_ext_o <= ( i_ld_uns ) ? { {16'b0}, data_i[15: 0] } : { {16{data_i[15]}}, data_i[15: 0] };
     4'b1111: data_ext_o <= data_i ;
          default: data_ext_o = 32'bx;
    endcase
  end
endmodule: ld_data

