`timescale 1ns / 1ps

module lsu_tb;

  logic i_clk;
  logic i_rst;
  logic i_lsu_wren;
  //logic //i_ld_uns;
  //logic [ 3:0] //i_num_byte;
  logic [31:0] i_lsu_addr;
  logic [31:0] i_st_data;
  logic [31:0] i_io_sw;
  logic [ 3:0] i_io_btn;
  logic [31:0] o_ld_data;
  logic [31:0] o_io_lcd;
  
  logic [31:0] o_io_ledg;
  logic [31:0] o_io_ledr;
  
  logic [ 6:0] o_io_hex0;
  logic [ 6:0] o_io_hex1;
  logic [ 6:0] o_io_hex2;
  logic [ 6:0] o_io_hex3;
  logic [ 6:0] o_io_hex4;
  logic [ 6:0] o_io_hex5;
  logic [ 6:0] o_io_hex6;
  logic [ 6:0] o_io_hex7;

  // Instantiate the LSU module
  lsu dut (
    .i_clk( i_clk  ),
    .i_rst( i_rst  ),
    .i_lsu_wren( i_lsu_wren  ),
    //.//i_ld_uns( //i_ld_uns  ),
    //.//i_num_byte( //i_num_byte ),
    .i_lsu_addr( i_lsu_addr  ),
    .i_st_data( i_st_data ),
    .i_io_sw( i_io_sw ),
    .i_io_btn( i_io_btn ),
    .o_ld_data ( o_ld_data ),
    .o_io_lcd ( o_io_lcd ),
    .o_io_ledg ( o_io_ledg ),
    .o_io_ledr ( o_io_ledr ),
    .o_io_hex0 ( o_io_hex0 ),
    .o_io_hex1 ( o_io_hex1 ),
    .o_io_hex2 ( o_io_hex2 ),
    .o_io_hex3 ( o_io_hex3 ),
    .o_io_hex4 ( o_io_hex4 ),
    .o_io_hex5 ( o_io_hex5 ),
    .o_io_hex6 ( o_io_hex6 ),
    .o_io_hex7 ( o_io_hex7 )
  );
  
  // Clock generation
  initial begin
    i_clk = 0;
    forever #5 i_clk = ~i_clk;
  end
  
  // Task to perform store operation
  task LSU_result () ;
    $display("- Address: 0x%h \n Data_store: %h ;\n Data_load : %h ;\n -- -- -- --", i_lsu_addr, i_st_data, o_ld_data);
 #50;
  endtask
  
  initial begin
   #100;
   i_rst = 0;
   #10;
   i_rst = 1;
   #100;

  // WORD - DMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // halfWORD - DMEM
  repeat(10) begin
  //i_num_byte = 4'b0011;
  //i_ld_uns    = 1'b1;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b0011;
  //i_ld_uns    = 1'b0;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  // BYTE - DMEM
  repeat(10) begin
  //i_num_byte = 4'b0001;
  //i_ld_uns    = 1'b1;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b0001;
  //i_ld_uns    = 1'b0;
  i_lsu_addr[15:13] = 3'b001;
  i_lsu_addr[12: 0] = $random;
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
///////////////////////////////////////////////////////////////////////////////////////////////////////
  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7000; // op_mem.ledr = x7000 = 0111_0000_0'000_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7000; // op_mem.ledr = x7000 = 0111_0000_0'000_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7010;  // op_mem.ledg = x7010 = 0111_0000_0'001_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7010;  // op_mem.ledg = x7010 = 0111_0000_0'001_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM  
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7027;  // op_mem.hex7 = x7027 = 0111_0000_0'010_0111'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7024;  // op_mem.hex7 = x7027 = 0111_0000_0'010_0111'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM  
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7024;  // op_mem.hex6 = x7026 = 0111_0000_0'010_0111'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7024;  // op_mem.hex6 = x7026 = 0111_0000_0'010_0110'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM  
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7025;  // op_mem.hex5 = x7025 = 0111_0000_0'010_0101'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7025;  // op_mem.hex5 = x7025 = 0111_0000_0'010_0101'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM  
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7024;  // op_mem.hex4 = x7024 = 0111_0000_0'010_0100'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7024;  // op_mem.hex4 = x7024 = 0111_0000_0'010_0100'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM  
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7023;  // op_mem.hex3 = x7023 = 0111_0000_0'010_0011'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7023;  // op_mem.hex3 = x7023 = 0111_0000_0'010_0011'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7022;  // op_mem.hex2 = x7020 = 0111_0000_0'010_0010'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7022;  // op_mem.hex2 = x7020 = 0111_0000_0'010_0010'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7021;  // op_mem.hex1 = x7021 = 0111_0000_0'010_0001'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7021;  // op_mem.hex1 = x7021 = 0111_0000_0'010_0001'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7020;  // op_mem.hex0 = x7020 = 0111_0000_0'010_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7020;  // op_mem.hex0 = x7020 = 0111_0000_0'010_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end

  // OPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7030;  // op_mem.lcd  = x7030 = 0111_0000_0'101_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7030;  // op_mem.lcd  = x7030 = 0111_0000_0'101_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end 
///////////////////////////////////////////////////////////////////////////////////////////////////////
  // IPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7800;   // ipmem_addr.switch = x7800 : 0111_1000_000'0_0000'
  i_st_data  = $random;
  i_io_sw    = i_st_data;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7800;   // ipmem_addr.switch = x7800 : 0111_1000_000'0_0000'
  i_st_data  = $random;
  i_io_sw    = i_st_data;
  i_io_btn  = 32'hFFFFFFFF;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  // IPMEM
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b0;
  i_lsu_addr     = 32'h7810;  // ipmem_addr.button = x7810 : 0111_1000_000'1_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = i_st_data;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  repeat(10) begin
  //i_num_byte = 4'b1111;
  //i_ld_uns    = 1'b1;
  i_lsu_addr     = 32'h7811;  // ipmem_addr.button = x7810 : 0111_1000_000'1_0000'
  i_st_data  = $random;
  i_io_sw    = 32'hFFFFFFFF;
  i_io_btn  = i_st_data;
  i_lsu_wren = 1;
  #20;
  LSU_result();
  #20;
  i_lsu_wren = 0;
  #10;
  end
  $stop;
  $finish;
  end
  
endmodule
