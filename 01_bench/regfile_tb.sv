`include "timescale.svh"

module regfile_tb(); 
  /* verilator lint_off WIDTHTRUNC */
  /* verilator lint_off UNDRIVEN */
  /* verilator lint_off UNUSEDSIGNAL */
  
  localparam number_occur = 100;
  logic clk, rst, rd_wren;
  logic [ 4:0] rs1_addr, rs2_addr, rd_addr;
  logic [31:0] rd_data, rs1_data, rs2_data;

 // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, regfile_dut);
  end

  // Clock generator
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end
  
  regfile regfile_dut (
    .clk      (clk)     ,
    .rst      (rst)     ,
    .rs1_addr (rs1_addr),
    .rs2_addr (rs2_addr),
    .rd_addr  (rd_addr) ,
    .rd_wren  (rd_wren) ,
    .rd_data  (rd_data) ,
    .rs1_data (rs1_data),
    .rs2_data (rs2_data)
  );

  // Task write data
  task write_data ( input [ 4:0] address_wr, 
                    input [31:0] data_wr   , 
                    input        is_wr );
    rd_wren = is_wr;
    @(posedge clk);
    if (rd_wren) begin
    @(posedge clk);  
      if (regfile_dut.register_array[address_wr] == data_wr) $display ("Write PASSED");
      else $display ("Write FAILED at adress = %b, data = %h, data in reg = %h", address_wr, data_wr, regfile_dut.register_array[address_wr]); 
    end
    rd_wren = 0; 
   
  endtask 
  
  // Task read data
  task read_data (input [ 4:0] rs1_addr_ex,
                  input [ 4:0] rs2_addr_ex);
	
	@(posedge clk);    
    if (regfile_dut.rs1_data == regfile_dut.register_array[rs1_addr_ex]) $display ("Read Rs1 PASSED");
    else $error;
    if (regfile_dut.rs2_data == regfile_dut.register_array[rs2_addr_ex]) $display ("Read Rs2 PASSED");
    else $error;

  endtask

  
  // test case 
  initial begin 
    rst = 1;
    @(posedge clk);
    rst = 0;
    @(posedge clk);
    
    repeat (number_occur) begin
      rd_data = $random;
      rd_addr = $urandom_range (0,31);

      write_data(rd_addr, rd_data, 1);
    end
	
	  repeat (number_occur) begin
      rs1_addr = $urandom_range (0,31);
      rs2_addr = $urandom_range (0,31);
    
      read_data(rs1_addr, rs2_addr);
    end  

    #50 $finish;
  end

endmodule : regfile_tb


