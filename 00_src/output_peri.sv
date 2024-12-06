`include "timescale.svh"

/* verilator lint_off WIDTHTRUNC */
module output_peri (
  input  logic        clk    ,
  input  logic        rst    ,
  input  logic [ 7:0] addr   ,
  input  logic [31:0] w_data ,
  input  logic        wr_en  ,
  input  logic [ 3:0] bmask  ,
  output logic [31:0] rd_data,
  output logic [ 6:0] io_hex0,
  output logic [ 6:0] io_hex1,
  output logic [ 6:0] io_hex2,
  output logic [ 6:0] io_hex3,
  output logic [ 6:0] io_hex4,
  output logic [ 6:0] io_hex5,
  output logic [ 6:0] io_hex6,
  output logic [ 6:0] io_hex7,
  output logic [31:0] io_ledr,
  output logic [31:0] io_ledg,
  output logic [31:0] io_lcd 

);
  
  always_ff @(posedge clk) begin 
    if (rst) begin 
      io_ledr <= 0;
      io_ledg <= 0;
      io_hex0 <= 0;
      io_hex1 <= 0;
      io_hex2 <= 0;
      io_hex3 <= 0;
      io_hex4 <= 0;
      io_hex5 <= 0;
      io_hex6 <= 0;
      io_hex7 <= 0;
      io_lcd  <= 0;
    end else if (wr_en) begin 
      case (addr)
	  // ledr
      8'h00: begin
        if (bmask[3]) io_ledr[31:24] <= w_data[31:24];
        if (bmask[2]) io_ledr[23:16] <= w_data[23:16];
        if (bmask[1]) io_ledr[15: 8] <= w_data[15: 8];
        if (bmask[0]) io_ledr[ 7: 0] <= w_data[ 7: 0];
      end
      // ledg
      8'h10: begin
        if (bmask[3]) io_ledg[31:24] <= w_data[31:24];
        if (bmask[2]) io_ledg[23:16] <= w_data[23:16];
        if (bmask[1]) io_ledg[15: 8] <= w_data[15: 8];
        if (bmask[0]) io_ledg[ 7: 0] <= w_data[ 7: 0];
      end
      // hex3, hex2, hex1, hex0
      8'h20: begin
        if (bmask[3]) io_hex3 <= w_data[30:24];
        if (bmask[2]) io_hex2 <= w_data[22:16];
        if (bmask[1]) io_hex1 <= w_data[14: 8];
        if (bmask[0]) io_hex0 <= w_data[ 6: 0];
      end
      // hex7, hex6, hex5, hex4
      8'h24: begin
        if (bmask[3]) io_hex7 <= w_data[30:24];
        if (bmask[2]) io_hex6 <= w_data[22:16];
        if (bmask[1]) io_hex5 <= w_data[14: 8];
        if (bmask[0]) io_hex4 <= w_data[ 6: 0];
      end
      // lcd
      8'h30: begin
        if (bmask[3]) io_lcd[31:24] <= w_data[31:24];
        if (bmask[2]) io_lcd[23:16] <= w_data[23:16];
        if (bmask[1]) io_lcd[15: 8] <= w_data[15: 8];
        if (bmask[0]) io_lcd[ 7: 0] <= w_data[ 7: 0];
      end
      default: begin 
        io_ledr <= io_ledr;
        io_ledg <= io_ledg;
        io_hex0 <= io_hex0;
        io_hex1 <= io_hex1;
        io_hex2 <= io_hex2;
        io_hex3 <= io_hex3;
        io_hex4 <= io_hex4;
        io_hex5 <= io_hex5;
        io_hex6 <= io_hex6;
        io_hex7 <= io_hex7;
        io_lcd  <= io_lcd;
      end
      endcase
    end
  end

  always_comb begin 
  case (addr)
    8'h00: rd_data = io_ledr;
    8'h10: rd_data = {{24{1'b0}},io_ledg};
    /* 8'h20: begin
      rd_data[30:24] = io_hex3;  // 
      rd_data[22:16] = io_hex2;  // 
      rd_data[14: 8] = io_hex1;
      rd_data[ 6: 0] = io_hex0;
    end
    8'h24: begin
      rd_data[30:24] = io_hex7;  // 
      rd_data[22:16] = io_hex6;  // 
      rd_data[14: 8] = io_hex5;
      rd_data[ 6: 0] = io_hex4;
    end
	*/
	 8'h20: rd_data = {1'b0, io_hex3, 1'b0, io_hex2, 1'b0, io_hex1, 1'b0, io_hex0};
	 8'h24: rd_data = {1'b0, io_hex7, 1'b0, io_hex6, 1'b0, io_hex5, 1'b0, io_hex4};
    8'h30: rd_data = io_lcd;
    default: rd_data = 0;
  	endcase 
  end

endmodule : output_peri
