/* verilator lint_off UNUSEDSIGNAL */
module output_peri_tb;
  // Tín hiệu testbench
  logic clk;
  logic rst;
  logic [7:0] addr;
  logic [31:0] w_data;
  logic wr_en;
  logic [3:0] bmask;
  logic [31:0] rd_data;
  logic [6:0] io_hex0, io_hex1, io_hex2, io_hex3;
  logic [6:0] io_hex4, io_hex5, io_hex6, io_hex7;
  logic [31:0] io_ledr, io_ledg, io_lcd, io_keypad;

  // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, peri_dut);
  end

  // Khởi tạo module output_peri
  output_peri peri_dut (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .w_data(w_data),
    .wr_en(wr_en),
    .bmask(bmask),
    .rd_data(rd_data),
    .io_hex0(io_hex0),
    .io_hex1(io_hex1),
    .io_hex2(io_hex2),
    .io_hex3(io_hex3),
    .io_hex4(io_hex4),
    .io_hex5(io_hex5),
    .io_hex6(io_hex6),
    .io_hex7(io_hex7),
    .io_ledr(io_ledr),
    .io_ledg(io_ledg),
    .io_lcd(io_lcd),
    .io_keypad(io_keypad)
  );

  // Tạo xung clock
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end

  // Quá trình kiểm tra
  initial begin
    // Khởi động tín hiệu
    rst = 1;
    wr_en = 0;
    addr = 0;
    w_data = 0;
    bmask = 4'b0011;
    #1 rst = 0; 

    // Ghi dữ liệu vào io_ledr
    addr = 8'h00;
    w_data = 32'h00001234;
    wr_en = 1;
    @(posedge clk);
	wr_en = 0;
	@(posedge clk);
    // Ghi dữ liệu vào io_hex0, io_hex1, io_hex2, io_hex3
    addr = 8'h20;
    w_data = 32'hCAFEBABE;
    wr_en = 1;
    @(posedge clk);
	wr_en = 0;
	@(posedge clk);
    // Ghi dữ liệu vào io_hex4, io_hex5, io_hex6, io_hex7
    addr = 8'h24;
    w_data = 32'hB0BACAFE;
    wr_en = 1;
    @(posedge clk);
 	wr_en = 0;
	@(posedge clk);
    // Đọc lại dữ liệu từ các địa chỉ để kiểm tra
    addr = 8'h20;
    @(posedge clk);
    addr = 8'h24;
    @(posedge clk);
    addr = 8'h00;
    @(posedge clk);

	
	#10;
    $finish; // Dừng mô phỏng
  end
endmodule

