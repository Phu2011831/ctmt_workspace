`include "timescale.svh"
/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off UNUSEDSIGNAL */
module lsu (
  input  logic        clk     ,
  input  logic        rst     ,
  input  logic [15:0] addr    ,
  input  logic [31:0] w_data  ,
  input  logic        wr_en   ,
  input  logic        rd_en   ,
  input  logic [ 3:0] bmask   ,
  input  logic [ 2:0] ld_sel  ,
  output logic [31:0] r_data  ,
  output logic [31:0] io_ledr ,
  output logic [31:0] io_ledg ,
  output logic [ 6:0] io_hex0 ,
  output logic [ 6:0] io_hex1 ,
  output logic [ 6:0] io_hex2 ,
  output logic [ 6:0] io_hex3 ,
  output logic [ 6:0] io_hex4 ,
  output logic [ 6:0] io_hex5 ,
  output logic [ 6:0] io_hex6 ,
  output logic [ 6:0] io_hex7 ,
  output logic [31:0] io_lcd  ,
  output logic        ack     ,
  input  logic [31:0] io_sw   ,
  input  logic [ 3:0] io_btn  , 

  output logic [17:0]   SRAM_ADDR,
  inout        [15:0]   SRAM_DQ  ,
  output logic          SRAM_CE_N,
  output logic          SRAM_WE_N,
  output logic          SRAM_LB_N,
  output logic          SRAM_UB_N,
  output logic          SRAM_OE_N
);
  
  logic [31:0] rdata_dmem, rd_peri_in, rd_peri, data_rd_temp; 
  logic 	      wr_en_outperi, wr_en_dmem;
  
  assign wr_en_dmem = wr_en && ~addr[14];
  assign wr_en_outperi = wr_en && addr[14] && (addr[11:8] == 4'b0000);

  sram_IS61WV25616_controller_32b_3lr dmem (
    .i_clk   (clk)       ,
    .i_reset (!rst)      ,
    .i_ADDR  (addr[12:0]),
    .i_WDATA (w_data)    ,
    .i_BMASK (bmask)     ,
    .i_WREN  (wr_en_dmem),
    .i_RDEN  (rd_en)     ,
    .o_RDATA (rdata_dmem),
    .o_ACK   (ack)       , 

    .SRAM_ADDR (SRAM_ADDR),
    .SRAM_DQ   (SRAM_DQ)  ,
    .SRAM_CE_N (SRAM_CE_N),
    .SRAM_WE_N (SRAM_WE_N),
    .SRAM_LB_N (SRAM_LB_N),
    .SRAM_UB_N (SRAM_UB_N),
    .SRAM_OE_N (SRAM_OE_N)
  );

  output_peri peri_out (
    .clk       (clk)          ,
    .rst       (rst)          ,
    .addr      (addr[7:0])    ,
    .w_data    (w_data)       ,
    .wr_en     (wr_en_outperi),
    .bmask     (bmask)        ,
    .rd_data   (rd_peri)	    ,	
    .io_ledr   (io_ledr)	  ,
    .io_ledg   (io_ledg)      ,
    .io_hex0   (io_hex0) 	    ,
    .io_hex1   (io_hex1)      ,
    .io_hex2   (io_hex2)      ,
    .io_hex3   (io_hex3)      ,
    .io_hex4   (io_hex4)      ,
    .io_hex5   (io_hex5)      ,
    .io_hex6   (io_hex6)      ,
    .io_hex7   (io_hex7)      ,
    .io_lcd    (io_lcd)          
  );

  input_peri per_in (
    .rst    (rst)      ,
    .addr   (addr[7:0]),
    .io_sw  (io_sw)    ,
    .io_btn (io_btn)   ,
    .rdata  (rd_peri_in)
  );

  assign data_rd_temp = (~addr[14]) ? rdata_dmem : (addr[11:8] == 4'b0000) ? rd_peri : (addr[11:8] == 4'b1000) ? rd_peri_in : 32'h0;
  
  always_comb begin 
    case (ld_sel) 
      3'b000: r_data = {{24{data_rd_temp[7]}},data_rd_temp[7:0]};   // lb
      3'b001: r_data = {{16{data_rd_temp[15]}},data_rd_temp[15:0]}; // lh
      3'b010: r_data = data_rd_temp;                                // lw
      3'b011: r_data = {24'h0,data_rd_temp[7:0]};                   // lbu 
      3'b100: r_data = {16'h0,data_rd_temp[15:0]};                  // lhu
      default: r_data = 32'h0; 
    endcase 
  end 

endmodule : lsu
