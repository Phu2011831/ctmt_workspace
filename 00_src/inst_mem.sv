`include "timescale.svh"

/* verilator lint_off UNUSEDSIGNAL */
module inst_mem(
  input  logic [12:0] raddr,
  output logic [31:0] rdata
);

  logic [3:0][7:0] imem [2**11-1:0];

  initial begin
    $readmemh("E:/Lecture/ComputerArchitecture/single_cycle_team/02_test/dump/mem.dump", imem);
  end

  assign rdata = imem[raddr[12:2]];

endmodule : inst_mem
