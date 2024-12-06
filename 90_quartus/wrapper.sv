module wrapper (
   input  logic [17:0]      SW      ,
   input  logic [ 3:0]      KEY     ,

   output logic [17:0]      LEDR    ,
   output logic [ 8:0]      LEDG    ,

   output logic [ 6:0]      HEX0    ,
   output logic [ 6:0]      HEX1    ,
   output logic [ 6:0]      HEX2    ,
   output logic [ 6:0]      HEX3    ,
   output logic [ 6:0]      HEX4    ,
   output logic [ 6:0]      HEX5    ,
   output logic [ 6:0]      HEX6    ,
   output logic [ 6:0]      HEX7    ,

   output logic [ 7:0]      LCD_DATA,
   output logic             LCD_RW  ,
   output logic             LCD_RS  ,
   output logic             LCD_EN  ,
   output logic             LCD_ON  ,

   inout	 	         [15:0]	    SRAM_DQ  ,				//	SRAM Data bus 16 Bits
   output logic      [17:0]	    SRAM_ADDR,				//	SRAM Address bus 18 Bits
   output logic			          SRAM_UB_N,				//	SRAM High-byte Data Mask 
   output logic			          SRAM_LB_N,				//	SRAM Low-byte Data Mask 
   output logic			          SRAM_WE_N,				//	SRAM Write Enable
   output logic			          SRAM_CE_N,				//	SRAM Chip Enable
   output logic			          SRAM_OE_N,				//	SRAM Output Enable
   
	input  logic             CLOCK_50
);

   logic [31:0]       io_sw  ;
   logic [31:0]       io_lcd ;
   logic [31:0]       io_ledg;
   logic [31:0]       io_ledr;
   logic [ 6:0]       io_hex0;
   logic [ 6:0]       io_hex1;
   logic [ 6:0]       io_hex2;
   logic [ 6:0]       io_hex3;
   logic [ 6:0]       io_hex4;
   logic [ 6:0]       io_hex5;
   logic [ 6:0]       io_hex6;
   logic [ 6:0]       io_hex7;

   logic [31:0]       pc_debug;

   assign io_sw      =  {{15{1'b0}},SW[16:0]};
   assign io_btn     =  KEY[3:0];
   assign LEDG[7:0]  =  io_ledg[7:0];
   assign LEDR[16:0] =  io_ledr[16:0];

   assign LCD_DATA   =  io_lcd[7:0];
   assign LCD_RW     =  io_lcd[8];
   assign LCD_RS     =  io_lcd[9];
   assign LCD_EN     =  io_lcd[10];
   assign LCD_ON     =  io_lcd[31];

   assign HEX0 = io_hex0;
   assign HEX1 = io_hex1;
   assign HEX2 = io_hex2;
   assign HEX3 = io_hex3;
   assign HEX4 = io_hex4;
   assign HEX5 = io_hex5;
   assign HEX6 = io_hex6;
   assign HEX7 = io_hex7;

   singlecycle cpu (
      .pc_debug (pc_debug),
      .io_ledr  (io_ledr) ,
      .io_ledg  (io_ledg) ,
      .io_hex0  (io_hex0) ,
      .io_hex1  (io_hex1) ,
      .io_hex2  (io_hex2) ,
      .io_hex3  (io_hex3) ,
      .io_hex4  (io_hex4) ,
      .io_hex5  (io_hex5) ,
      .io_hex6  (io_hex6) , 
      .io_hex7  (io_hex7) ,
      .io_lcd   (io_lcd)  ,
      .io_sw    (io_sw)   ,
      .io_btn   (io_btn)  ,
      
      .SRAM_ADDR (SRAM_ADDR),
      .SRAM_DQ   (SRAM_DQ)  ,
      .SRAM_CE_N (SRAM_CE_N),
      .SRAM_WE_N (SRAM_WE_N),
      .SRAM_LB_N (SRAM_LB_N),
      .SRAM_UB_N (SRAM_UB_N),
      .SRAM_OE_N (SRAM_OE_N), 

      .clk       (CLOCK_50),
      .rst       (SW[17])
   ); 

endmodule : wrapper

