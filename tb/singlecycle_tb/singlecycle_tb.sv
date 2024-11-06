`timescale 1ns/1ps

module singlecycle_tb;

  // Inputs
  reg i_clk;
  reg i_rst_n;
  reg [31:0] i_io_sw;
  reg [31:0] io_push_i;

  // Outputs
  wire [31:0] o_io_lcd;
  wire [31:0] o_io_ledg;
  wire [31:0] o_io_ledr;
  wire [31:0] o_io_hex0;
  wire [31:0] o_io_hex1;
  wire [31:0] o_io_hex2;
  wire [31:0] o_io_hex3;
  wire [31:0] o_io_hex4;
  wire [31:0] o_io_hex5;
  wire [31:0] o_io_hex6;
  wire [31:0] o_io_hex7;
  wire [31:0] o_pc_debug;

  // Instantiate the singlecycle module
  single_cycle_rv32i dut (
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_io_sw(i_io_sw),
    .io_push_i(io_push_i),
    .o_io_lcd(o_io_lcd),
    .o_io_ledg(o_io_ledg),
    .o_io_ledr(o_io_ledr),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_pc_debug(o_pc_debug)
  );
  
  // Clock generation
  always #10 i_clk = ~i_clk;

  // Reset generation
/*  initial begin
    i_clk = 0;
    i_rst_n = 1'b0;
    #55;
    i_rst_n = 1'b1;
    #250000000;//;
    i_rst_n = 1'b0;
    #55;
    i_rst_n = 1'b1;
    #150000;//0000;
    $finish;
  end*/
  initial begin
    i_clk = 0;
    i_io_sw = 18'b0; // i_rst_n = 1'b0;
    #55;
    i_io_sw = 18'b10_0000_0000_0000_0000; // i_rst_n = 1'b1;
    #15;
    i_io_sw = 18'b10_1010_1011_1100_1101;
    #15;
    i_io_sw = 18'b11_1010_1011_1100_1111;
    #10000;
    i_io_sw = 18'b10_1010_1010_1010_1010;
    #300;
    i_io_sw = 18'b10_1010_1011_1100_1101;
    #15;
    i_io_sw = 18'b11_1111_1010_1111_1010;
    #10000;
    i_io_sw = 18'b0; // i_rst_n = 1'b0;
    #55;
    i_io_sw = 18'b11_0000_0001_0010_0011; // i_rst_n = 1'b1;
    #10000;
    $finish;
  end
  // Stimulus
  /*initial begin
    // Initialize inputs
    i_io_sw = 32'h0000_0000;
    io_push_i = 32'h0000_0000;
    // Wait for some time before starting clock
    #5000;
    
    $finish;
  end*/

endmodule