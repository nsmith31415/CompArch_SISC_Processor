// ECE:3350 SISC computer project
// finite state machine
// Nick Smith and Alan Rolla
`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rd_sel, rf_we, alu_op, wb_sel, PC_RST, PC_Sel, PC_Write, ir_load, BR_Sel, rb_sel);

  /* Declare the ports listed above as inputs or outputs.  Note that
     you will add signals for parts 2, 3, and 4. */
  
  input clk, rst_f;
  input [3:0] opcode, mm, stat;
  output reg rf_we, wb_sel, PC_RST, PC_Sel, PC_Write, ir_load, BR_Sel, rb_sel, rd_sel;
  output reg [1:0] alu_op;
  
  // state parameter declarations
  
  parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;
   
  // opcode paramenter declarations
  
  parameter NOOP = 0, LOD = 1, STR = 2, SWP = 3, BRA = 4, BRR = 5, BNE = 6, BNR = 7, ALU_OP = 8, HLT=15;

  // addressing modes
  
  parameter AM_IMM = 8;

  // state register and next state value
  
  reg [2:0]  present_state, next_state;

  // Initialize present state to 'start0'.
  
  initial
    present_state = start0;

  /* Clock procedure that progresses the fsm to the next state on the positive 
     edge of the clock, OR resets the state to 'start1' on the negative edge
     of rst_f. Notice that the computer is reset when rst_f is low, not high. */

  always @(posedge clk)
	begin
	PC_RST=1'b0;
	present_state<=next_state;
	end
  always @(negedge clk)
  begin
    if (rst_f == 1'b0)
	PC_RST=1'b1;
      	present_state <= start1;
  end
  
  /* Combinational procedure that determines the next state of the fsm. */

  always @(present_state, rst_f)
  begin
    case(present_state)
      start0:	 begin next_state <= start1; end
      start1:	 begin next_state <= fetch; end
      fetch:	 begin next_state <= decode; end
      decode:	 begin next_state <= execute; end
      execute:	 begin next_state <= mem; end
      mem:	 begin next_state <= writeback; end
      writeback: begin next_state <= fetch; end
    endcase
  end
  

//Check on rising clock edges
always @(posedge clk)
	begin
	//first check state
	if(present_state == start0)
		begin
		rf_we <=1'b0;
		wb_sel<=1'b0;
		alu_op<=2'b10;
		rb_sel <= 1'b0;
		PC_Write <= 1'b0;	
		ir_load <= 1'b0;
		BR_Sel <= 1'b0;
		PC_RST <= 1'b1;
		PC_Sel <= 1'b0;
		end
	if(present_state == start1)
		begin
		alu_op <= 2'b00;
		ir_load <= 1'b0;
		PC_RST <= 1'b0;
		end
	if(present_state == fetch)
		begin
		$display("Fetching");
		rf_we <= 1'b0;
		wb_sel <= 1'b0;
		alu_op <= 2'b00;
		rb_sel <= 1'b0;
		PC_Write <= 1'b1;	// Must inc pc in fetch
		ir_load <= 1'b1;
		BR_Sel <= 1'b0;
		PC_RST <= 1'b0;
		PC_Sel <= 1'b0;	
		end
	if(present_state == decode)
		begin
		PC_Write<=1'b0;
		ir_load<=1'b0;
		$display("Decoding");
		//check opcode (decoding only matters for BNE,BRA, BRR, BNR right now)
	
		if(opcode==BNE)
			begin
			PC_Sel<=1;
			if((stat & mm)==4'b0000)	
				begin
				$display("Branching BNE");
				PC_Sel<=1;
				PC_Write<=1;
				BR_Sel<=1;
				end
			end
		if(opcode==BNR)
			begin
			if((stat & mm)==4'b0000)	
				begin
				$display("Branching BNR");
				PC_Sel<=1;
				PC_Write<=1;
				BR_Sel<=0;
				end
			end
		if(opcode==BRA)
			begin
			if((stat & mm)!=4'b0000)	
				begin
				$display("Branching BRA");
				PC_Sel<=1;
				PC_Write<=1;
				BR_Sel<=1;
				end
			end
		if(opcode==BRR)
			begin
			if((stat & mm)!=4'b0000)	
				begin
				$display("Branching BRR");
				PC_Sel<=1;
				PC_Write<=1;
				BR_Sel<=0;
				end
			end
		end
	
	else if (present_state == execute)
		begin
		$display("Executing");
		PC_Write<=1'b0;
		ir_load<=1'b0;
		//check MM
		if(opcode == 4'b1000) //opcode for ALU op
			begin
				//fourth check mm, if 1000, use immediate load instead of input B
				if(mm==4'b1000)
					begin
					alu_op<=2'b01;
					end
				else
					begin
					alu_op<=2'b00;
					end
			end
		else		//if not ALU_OP
			begin
				//fourth check mm
				if(mm==4'b1000)
					begin
					alu_op<=2'b11;
					end
				else
					begin
					alu_op<=2'b10;
					end
			end
		
		end
	else if (present_state == mem)
		begin
		
		end
	else if (present_state == writeback)
		begin
		if(opcode==4'b1000)
			begin
			rf_we=1;
			end
		end
	end
	

// Halt on HLT instruction
  
  always @(opcode)
  begin
    if (opcode == HLT)
    begin 
      #5 $display ("Halt."); //Delay 5 ns so $monitor will print the halt instruction
      $stop;
    end
  end
    
  
endmodule
