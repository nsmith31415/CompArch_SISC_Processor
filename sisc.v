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
	
	//ALU
	wire [31:0] RSA;
	wire [31:0] RSB;
	wire [3:0] CC;
	wire [31:0] alu_result;

	//MUX4
	wire [3:0] mux4_result;
	
	//Output of mux32
	wire [31:0] mux32_result;

// component instantiation goes here
// Component Initialization
	
	mux4 my_mux4(.in_a(ir[15:12]), .in_b(ir[23:20]), .sel(1'b0), .out(mux4_result));
	alu my_alu(.clk(clk), .rsa(RSA), .rsb(RSB), .imm(ir[15:0]), .alu_op(ALU_OP), .alu_result(alu_result), .stat(CC), .stat_en(STAT_EN));
	mux32 my_mux32(.in_a(alu_result), .in_b(8'h00000000), .sel(WB_SEL), .out(mux32_result));
	statreg my_statreg(.clk(clk), .in(CC), .enable(STAT_EN), .out(STAT_OUT));
  	ctrl my_ctrl(.clk(clk), .rst_f(rst_f), .opcode(ir[31:28]), .mm(ir[27:24]), .stat(STAT_OUT), .rf_we(RF_WE), .alu_op(ALU_OP), .wb_sel(WB_SEL)	);
	rf my_rf (.clk(clk), .read_rega(ir[19:16]), .read_regb(mux4_result), .write_reg(ir[23:20]), .write_data(mux32_result), .rf_we(RF_WE), .rsa(RSA), .rsb(RSB));
    initial
  begin
   $monitor ($time,, " ir>: %h, R1=%h, R2=%h, R3=%h, R4=%h, R5=%h, ALU_OP=%h, WB_SEL=%h, RF_WE=%h, STAT_OUT=%h", ir,my_rf.ram_array[1], my_rf.ram_array[2], my_rf.ram_array[3], my_rf.ram_array[4], my_rf.ram_array[5], ALU_OP, WB_SEL, RF_WE, STAT_OUT);
	/*	please monitor the following signals: IR, R1 through R5, RD_SEL, ALU_OP,
		WB_SEL, RF_WE and STAT.
		
		 If you have instantiated module rf with the name my_rf, you can access R1
		with the following syntax in the $monitor signal list, i.e. my_rf.ram_array[1].
		
		
	*/

  end 



endmodule
