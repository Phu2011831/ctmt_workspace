`include "timescale.svh"

module regfile (
  input  logic        clk     , 
  input  logic        rst     ,
  input  logic [ 4:0] rs1_addr,
  input  logic [ 4:0] rs2_addr,
  input  logic [ 4:0] rd_addr , 
  input  logic        rd_wren ,
  input  logic [31:0] rd_data ,
  output logic [31:0] rs1_data, 
  output logic [31:0] rs2_data
);

  logic [31:0] register_array [31:0];

  integer i; 

  always_ff @(posedge clk) begin 
    if (rst) begin 
      for (i = 0; i < 32; i = i + 1) begin
        register_array[i] <= 32'h0;
      end
    end else if (rd_wren && (rd_addr != 5'b00000)) begin 
      register_array[rd_addr] <= rd_data;
    end
  end

  assign rs1_data = (rs1_addr == 0) ? 32'h0 : register_array[rs1_addr];
  assign rs2_data = (rs2_addr == 0) ? 32'h0 : register_array[rs2_addr];

endmodule : regfile
