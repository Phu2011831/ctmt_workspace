`include "timescale.svh" 

module brc_tb ();
  logic clk;
  logic [31:0] rs1_data, rs2_data;
  logic 	     br_un;
  logic 	     br_less, br_equal;
  
  // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, brc_dut);
  end

  // Clock generator
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end
	
  brc brc_dut (
     .rs1_data (rs1_data),
     .rs2_data (rs2_data),
     .br_un    (br_un)   ,
     .br_less  (br_less) ,
	   .br_equal (br_equal)
  );

  // Task compare
  task compare_check (
    input [31:0] a, 
    input [31:0] b,
    input        unsigned_signal // 1 if signed, 0 if unsigned
  );
  
  logic less_expt, equal_expt;

  // Expected processing
  if (unsigned_signal) less_expt = ($signed(a) < $signed(b));
  else less_expt = ($unsigned(a) < $unsigned(b));

  equal_expt = (a == b);

  // Assert check 
  assert (br_less == less_expt) $display ("PASSED less");
  else $error ("FAILED less: a = %h, b = %h, br_un = %b, less_expected = %b, less_test = %b ", a, b, unsigned_signal, less_expt, br_less);
  assert (br_equal == equal_expt) $display ("PASSED equal");
  else $error ("FAILED equal: a = %h, b = %h, br_un = %b, equal_expected = %b, equal_test = %b", a, b, unsigned_signal, equal_expt, br_equal);
  
  endtask

  // Start checking
  initial begin 
    $display ("Start testing BRC ...");
    
    // Repeat value
    repeat (500) begin 
      rs1_data = $random;
      rs2_data = $random;
      /* verilator lint_off WIDTHTRUNC */	
	    br_un = $random;
     /* verilator lint_on WIDTHTRUNC */
	  @(posedge clk);
      // task
      compare_check (rs1_data, rs2_data, br_un);
    end
    $display ("Test BRC sucessful");
    $finish;
  end

endmodule : brc_tb
