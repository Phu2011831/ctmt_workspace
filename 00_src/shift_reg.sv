`include "timescale.svh"

module shift_reg (
  input  logic [31:0] a  ,
  input  logic [ 4:0] b  , 
  output logic [31:0] sll,
  output logic [31:0] srl,
  output logic [31:0] sra
);

  always_comb begin 
 	case (b)
	5'd0: begin 
		sll = a;
		srl = a;
		sra = a;
	end
	5'd1: begin 
		sll = {a[30:0],1'b0};
		srl = {1'b0,a[31:1]};
		sra = {a[31],a[31:1]};
	end 
	5'd2: begin
		sll = {a[29:0],2'b00};
		srl = {2'b00,a[31:2]};
		sra = {{2{a[31]}},a[31:2]};
	end
	5'd3: begin 
		sll = {a[28:0],{3{1'b0}}};
		srl = {{3{1'b0}},a[31:3]};
		sra = {{3{a[31]}},a[31:3]};
	end
	5'd4: begin 
		sll = {a[27:0],{4{1'b0}}}; 
		srl = {{4{1'b0}},a[31:4]};
		sra = {{4{a[31]}},a[31:4]};
	end
	5'd5: begin 
		sll = {a[26:0],{5{1'b0}}};
		srl = {{5{1'b0}},a[31:5]};
		sra = {{5{a[31]}},a[31:5]};
	end 
	5'd6: begin 
		sll = {a[25:0],{6{1'b0}}};
		srl = {{6{1'b0}},a[31:6]};
		sra = {{6{a[31]}},a[31:6]};
	end
	5'd7: begin 
		sll = {a[24:0],{7{1'b0}}};
		srl = {{7{1'b0}},a[31:7]};
		sra = {{7{a[31]}},a[31:7]};
	end
	5'd8: begin
		sll = {a[23:0],{8{1'b0}}};
		srl = {{8{1'b0}},a[31:8]};
		sra = {{8{a[31]}},a[31:8]};
	end
	5'd9: begin 
		sll = {a[22:0],{9{1'b0}}};
		srl = {{9{1'b0}},a[31:9]};
		sra = {{9{a[31]}},a[31:9]};
	end 
	5'd10: begin 
		sll = {a[21:0],{10{1'b0}}};
		srl = {{10{1'b0}},a[31:10]};
		sra = {{10{a[31]}},a[31:10]};
	end
	5'd11: begin
		sll = {a[20:0],{11{1'b0}}};
		srl = {{11{1'b0}},a[31:11]};
		sra = {{11{a[31]}},a[31:11]};
	end 
	5'd12: begin
		sll = {a[19:0],{12{1'b0}}};
		srl = {{12{1'b0}},a[31:12]};
		sra = {{12{a[31]}},a[31:12]};
	end 
	5'd13: begin 
		sll = {a[18:0],{13{1'b0}}};
		srl = {{13{1'b0}},a[31:13]};
		sra = {{13{a[31]}},a[31:13]};
	end 
	5'd14: begin
		sll = {a[17:0],{14{1'b0}}};
		srl = {{14{1'b0}},a[31:14]};
		sra = {{14{a[31]}},a[31:14]};
	end 
	5'd15: begin
		sll = {a[16:0],{15{1'b0}}};
		srl = {{15{1'b0}},a[31:15]};
		sra = {{15{a[31]}},a[31:15]};
	end 
	5'd16: begin
		sll = {a[15:0],{16{1'b0}}};
		srl = {{16{1'b0}},a[31:16]};
		sra = {{16{a[31]}},a[31:16]};
	end 
	5'd17: begin
		sll = {a[14:0],{17{1'b0}}};
		srl = {{17{1'b0}},a[31:17]}; 
		sra = {{17{a[31]}},a[31:17]};
	end 
	5'd18: begin
		sll = {a[13:0],{18{1'b0}}};
		srl = {{18{1'b0}},a[31:18]};
		sra = {{18{a[31]}},a[31:18]};
	end
	5'd19: begin 
		sll = {a[12:0],{19{1'b0}}};
		srl = {{19{1'b0}},a[31:19]};
		sra = {{19{a[31]}},a[31:19]};
	end
	5'd20: begin 
		sll = {a[11:0],{20{1'b0}}}; 
		srl = {{20{1'b0}},a[31:20]};
		sra = {{20{a[31]}},a[31:20]};
	end
	5'd21: begin
		sll = {a[10:0],{21{1'b0}}};
		srl = {{21{1'b0}},a[31:21]};
		sra = {{21{a[31]}},a[31:21]};
	end 
	5'd22: begin
		sll = {a[9:0],{22{1'b0}}};
		srl = {{22{1'b0}},a[31:22]};
		sra = {{22{a[31]}},a[31:22]};
	end 
	5'd23: begin
		sll = {a[8:0],{23{1'b0}}};
		srl = {{23{1'b0}},a[31:23]};
		sra = {{23{a[31]}},a[31:23]};
	end
	5'd24: begin
		sll = {a[7:0],{24{1'b0}}};
		srl = {{24{1'b0}},a[31:24]};
		sra = {{24{a[31]}},a[31:24]};
	end
	5'd25: begin
		sll = {a[6:0],{25{1'b0}}};
		srl = {{25{1'b0}},a[31:25]};
		sra = {{25{a[31]}},a[31:25]};
	end 
	5'd26: begin 
		sll = {a[5:0],{26{1'b0}}};
		srl = {{26{1'b0}},a[31:26]};
		sra = {{26{a[31]}},a[31:26]};
	end 
	5'd27: begin 
		sll = {a[4:0],{27{1'b0}}};
		srl = {{27{1'b0}},a[31:27]};
		sra = {{27{a[31]}},a[31:27]};
	end 
	5'd28: begin
		sll = {a[3:0],{28{1'b0}}};
		srl = {{28{1'b0}},a[31:28]};
		sra = {{28{a[31]}},a[31:28]};
	end 
	5'd29: begin 
		sll = {a[2:0],{29{1'b0}}};
		srl = {{29{1'b0}},a[31:29]};
		sra = {{29{a[31]}},a[31:29]};
	end 
	5'd30: begin
		sll = {a[1:0],{30{1'b0}}};
		srl = {{30{1'b0}},a[31:30]};
		sra = {{30{a[31]}},a[31:30]};
	end
	5'd31: begin 
		sll = {a[0:0],{31{1'b0}}};
		srl = {{31{1'b0}},a[31:31]};
		sra = {{31{a[31]}},a[31:31]};
	end
	default: begin 
		sll = 32'h0;
		srl = 32'h0;
		sra = 32'h0; 
 end
 endcase 
 end

endmodule : shift_reg

