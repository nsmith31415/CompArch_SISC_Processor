// ECE:3350 SISC processor project
// main SISC module, part 1
// Nick Smith and Alan Rolla

`timescale 1ns/100ps  

module sisc (clk, rst_f, ir);

  input clk, rst_f;
  input [31:0] ir;

// declare all internal wires here
// Datapath Wires
	//Control Unit
	wire [1:0] ALU_OP;
	wire WB_SEL;
	wire RF_WE;

	//STATREG
	wire STAT_EN;
	wire [3:0] STAT_OUT;
	
	//RSA and RSB to ALU
	wire [31:0] RSA;
	wire [31:0] RSB;
	//From alu_out
	wire [31:0] alu_result;
	//Output of mux4 to Rf
	wire [3:0] mux4_result;
	//Output of mux32
	wire [31:0] mux32_result;

// component instantiation goes here
// Component Initialization
	alu my_alu(.clk(clk), .rsa(RSA), .rsb(RSB), .imm(IR[15:0], .alu_op(ALU_OP), .alu_result(alu_result), .stat(STAT_OUT), .stat_en(STAT_EN));
	ctrl my_ctrl(.clk(clk), .rst_f(rst_f), .opcode(IR[32:28]), .mm(IR[27:24]), .stat(STAT_OUT), .rf_we(RF_WE), .alu_op(ALU_OP), .wb_sel(WB_SEL)	);
	mux4 my_mux4(.in_a(IR[23:20]), .in_b(IR[15,12]), .sel(0), .out(mux4_result));
	mux32 my_mux32(.in_a(RSA), .in_b(RSB), .sel(WB_SEL), .out(mux32_result));
	rf my_rf (.clk(clk), .read_rega(IR[23:30]), .read_regb(mux4_result[3:0]), .write_reg(IR[23:20]), .write_data(mux32_result[31:0], .rf_we(rf_we), .rsa(RSA), .rsb(RSB));
	statreg my_statreg();
  initial
  begin
   $monitor ($time,, " IR>: %h, R1=%h, R2=%h, R3=%h, R4=%h, R5=%h, RD_SEL=%h, ALU_OP=$h, WB_SEL=%h, RF_WE=%h, STAT=%h", IR,my_rf.ram_array[1], my_rf.ram_array[2], my_rf.ram_array[3], my_rf.ram_array[4], my_rf.ram_array[5], RD_SEL, ALU_OP, WB_SEL, RF_WE, STAT);
	/*	please monitor the following signals: IR, R1 through R5, RD_SEL, ALU_OP,
		WB_SEL, RF_WE and STAT.
		
		 If you have instantiated module rf with the name my_rf, you can access R1
		with the following syntax in the $monitor signal list, i.e. my_rf.ram_array[1].
		
		
	*/

  end 



endmodule
