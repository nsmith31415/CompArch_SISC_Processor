// ECE:3350 SISC processor project
// main SISC module, part 1
// Nick Smith and Alan Rolla

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
	wire [1:0] ALU_OP;
	wire WB_SEL;
	wire RF_WE;
	wire STAT_EN;
	wire 

// component instantiation goes here


  initial
  begin
// put a $monitor statement here.  
	/*	please monitor the following signals: IR, R1 through R5, RD_SEL, ALU_OP,
		WB_SEL, RF_WE and STAT.
		
		 If you have instantiated module rf with the name my_rf, you can access R1
		with the following syntax in the $monitor signal list, i.e. my_rf.ram_array[1].
		
		
	*/
  end 



endmodule


