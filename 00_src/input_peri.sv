`include "timescale.svh"
/* verilator lint_off WIDTHEXPAND */
module input_peri (
    input  logic        rst,
    input  logic [ 7:0] addr,
    input  logic [31:0] io_sw,
    input  logic [ 3:0] io_btn,
    output logic [31:0] rdata
);

// Write data

  always_comb begin
    if (rst) begin 
   	  rdata = 32'h0;
    end else begin 
      case (addr) 
        8'h00: rdata = io_sw;
        8'h10: rdata = io_btn;
        default: rdata = 32'h0;
      endcase 
    end
  end

endmodule: input_peri 


