`include "timescale.svh" 

module alu_tb ();
  logic clk;
  logic [31:0] operand_a, operand_b;
  logic [ 3:0] alu_op;
  logic [31:0] alu_data;
	
  // Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, alu_dut);
  end

  // Clock generator
  initial begin
    clk = 0;
    forever #1 clk = ~clk; 
  end

  alu alu_dut (
     .alu_op    (alu_op)   ,
     .operand_a (operand_a),
     .operand_b (operand_b),
     .alu_data  (alu_data)
  );
  
  task check_ADD ();
     logic [31:0] a, b, c_equal;
     logic [ 3:0]  sel;
     begin 
      a       = $random();
      b       = $random();
      c_equal = a + b;
      sel     = 4'h0;
  
      operand_a = a;
      operand_b = b;
      alu_op    = sel;
      @(posedge clk);
      assert (alu_dut.alu_data == c_equal)
      $display ("PASSED add: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", alu_op, operand_a, operand_b, alu_data, c_equal); else 
      $display ("FAILED add: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel, a, b, alu_data, c_equal);
     end
  endtask 

  task check_SUB ();
     logic [31:0] a, b, c_equal;
     logic [ 3:0] sel;
     begin 
      a       = $random();
      b       = $random();
      c_equal = a - b;
      sel     = 4'h8;

      operand_a = a;
      operand_b = b;
      alu_op    = sel;
      @(posedge clk);
      assert (alu_dut.alu_data == c_equal)
      $display ("PASSED sub: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", alu_op, operand_a, operand_b, alu_data,c_equal); else 
      $display ("FAILED sub: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data,c_equal);
     end
  endtask

  task check_SLT ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = ($signed(a) < $signed(b)) ? 1 : 0;
     sel     = 4'h2;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED slt: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
     $display ("FAIELD slt: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
    end
  endtask

  task check_SLTU ();
     logic [31:0] a, b, c_equal;
     logic [ 3:0] sel;
     begin 
      a       = $random();
      b       = $random();
      c_equal = ($unsigned(a) < $unsigned(b)) ? 1 : 0;
      sel     = 4'h3;

      operand_a = a;
      operand_b = b;
      alu_op    = sel;
      @(posedge clk);
      assert (alu_dut.alu_data == c_equal)
      $display ("PASSED sltu: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
      $display ("FAILED sltu: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask

  task check_XOR ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = a ^ b;
     sel     = 4'h4;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED xor: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
     $display ("FAILED xor: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
    end
  endtask

  task check_OR ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = a | b;
     sel     = 4'h6;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED or: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
     $display ("FAILED or: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
    end
  endtask

  task check_AND ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = a & b;
     sel     = 4'h7;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED and: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal);else 
     $display ("FAILED and: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask

  task check_SLL ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = a << b[4:0];
     sel     = 4'h1;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED sll: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
     $display ("FAILED sll: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask

  task check_SRL ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = a >> b[4:0];
     sel     = 4'h5;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED srl: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else 
     $display ("FAILED srl: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask

  task check_SRA ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = (a >> b[4:0]) | ~(32'hFFFFFFFF >> (a[31] ? b[4:0] : 0)); // arthematic shift right
     sel     = 4'hd;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED sra: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else  
     $display ("FAILED sra: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask

  task check_LUI ();
    logic [31:0] a, b, c_equal;
    logic [ 3:0] sel;
    begin 
     a       = $random();
     b       = $random();
     c_equal = b;
     sel     = 4'hb;

     operand_a = a;
     operand_b = b;
     alu_op    = sel;
     @(posedge clk);
     assert (alu_dut.alu_data == c_equal)
     $display ("PASSED lui: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h ", alu_op, operand_a, operand_b, alu_data,c_equal); else  
     $display ("FAILED lui: alu_op = %h, operand_a = %h, operand_b = %h, alu_data_expect = %h, data_test = %h", sel ,a, b, alu_data, c_equal);
     end
  endtask
 
  // Test cases
  initial begin 
  //repeat (100) check_ADD;
  //repeat (100) check_SUB;
  //repeat (100) check_SLT;
  //repeat (100) check_SLTU;
  //repeat (100) check_XOR;
  //repeat (100) check_OR;
  //repeat (100) check_AND;
  //repeat (100) check_SLL;
  //repeat (100) check_SRL;
  //repeat (100) check_SRA;
  //repeat (100) check_LUI;


     #50 $finish; 
  end

endmodule : alu_tb 
    
