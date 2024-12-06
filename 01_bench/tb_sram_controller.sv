`timescale 1ns/1ns
module tb_sram_controller;
  /* verilator lint_off WIDTHTRUNC */
  /* verilator lint_off UNDRIVEN */
  /* verilator lint_off UNUSEDSIGNAL */
  
  // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, sram_dut);
  end
  
  // Tín hiệu đầu vào cho DUT
  logic [17:0] i_ADDR;
  logic [31:0] i_WDATA;
  logic [3:0]  i_BMASK;
  logic        i_WREN;
  logic        i_RDEN;
  logic        i_clk;
  logic        i_reset;

  // Tín hiệu đầu ra từ DUT
  logic [31:0] o_RDATA;
  logic        o_ACK;
  logic [17:0] SRAM_ADDR;
  logic [15:0] SRAM_DQ;
  logic        SRAM_CE_N;
  logic        SRAM_WE_N;
  logic        SRAM_LB_N;
  logic        SRAM_UB_N;
  logic        SRAM_OE_N;

  // DUT instance
  sram_IS61WV25616_controller_32b_5lr sram_dut (
    .i_ADDR(i_ADDR),
    .i_WDATA(i_WDATA),
    .i_BMASK(i_BMASK),
    .i_WREN(i_WREN),
    .i_RDEN(i_RDEN),
    .o_RDATA(o_RDATA),
    .o_ACK(o_ACK),
    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_DQ(SRAM_DQ),
    .SRAM_CE_N(SRAM_CE_N),
    .SRAM_WE_N(SRAM_WE_N),
    .SRAM_LB_N(SRAM_LB_N),
    .SRAM_UB_N(SRAM_UB_N),
    .SRAM_OE_N(SRAM_OE_N),
    .i_clk(i_clk),
    .i_reset(i_reset)
  );

  // Clock generation
  initial begin
    i_clk = 0;
    forever #1 i_clk = ~i_clk; // Tạo xung clock 100MHz
  end

  // Test sequence
  initial begin
    // Reset ban đầu
    i_reset = 0;
    i_ADDR = 0;
    i_WDATA = 0;
    i_BMASK = 4'b0000;
    i_WREN = 0;
    i_RDEN = 0;
    SRAM_OE_N = 1;

   @(posedge i_clk);
    i_reset = 1; // Bật reset
    @(posedge i_clk); // Đợi một chút sau khi reset

    // Kiểm tra ghi dữ liệu
    i_ADDR = 18'h00000;
    i_WDATA = 32'h12345678;
    i_BMASK = 4'b1111;
    i_WREN = 1;  // Bật WREN
    i_RDEN = 0;  // Đảm bảo RDEN là 0
	@(posedge i_clk);
    i_WREN = 0;  // Ngừng ghi
	repeat(2) @(posedge i_clk);

    // Kiểm tra đọc dữ liệu
    i_ADDR = 18'h00000;
    i_WREN = 0;  // Đảm bảo WREN là 0
    i_RDEN = 1;  // Bật RDEN
    @(posedge i_clk);         // Đợi 1 chu kỳ
    i_RDEN = 0;  // Ngừng đọc

    // Đợi xác nhận
    @(posedge i_clk); // Đợi một chút sau khi nhận xác nhận

	#20;
		
    $stop; // Dừng mô phỏng
  end

endmodule
