
`include "opcode_type.svh"

module immgen_tb;

  // Khai báo tín hiệu
  logic clk;
  logic [31:0] instr;
  logic [31:0] imm;

    // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, dut);
  end

  // Clock generator
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end

  // Khởi tạo instance của module immgen
  immgen dut (
    .instr (instr),
    .imm   (imm)
  );

  // Task để kiểm tra kết quả
  task check_imm(input [31:0] expected_imm);
    if (imm === expected_imm)
      $display("PASS: instr = %h, imm = %h", instr, imm);
    else
      $display("FAIL: instr = %h, imm = %h, expected = %h", instr, imm, expected_imm);
  endtask

  initial begin
    $display("Starting immgen testbench...");
    // Test AUIPC
    instr = 32'h10000297; // opcode = AUIPC
    #1 check_imm (32'h10000000);
    // Test LW
    #1 instr = 32'hFFC32303;
    #1 check_imm (-32'd4);
    // Test BEQ 
	# 1instr = 32'h00030C63;
	#1 check_imm (32'd24);
	// Test BLT
	#1 instr = 32'h00534663;
	#1 check_imm (32'd12);
	// Test JAL
	#1 instr = 32'hFEDFF06F;
	#1 check_imm (-32'd20);
    $display("Testbench completed.");
    $finish;
  end
endmodule

