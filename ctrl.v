// ECE:3350 SISC computer project
// finite state machine
// Nick Smith and Alan Rolla
`timescale 1ns/100ps

module ctrl (clk, rst_f, opcode, mm, stat, rd_sel, rf_we, alu_op, wb_sel, PC_RST, PC_Sel, PC_Write, BR_Sel);

  /* Declare the ports listed above as inputs or outputs.  Note that
     you will add signals for parts 2, 3, and 4. */
  
  input clk, rst_f;
  input [3:0] opcode, mm, stat;
  output reg rf_we, wb_sel, PC_RST, PC_Sel, PC_Write, BR_Sel;
  output reg [1:0] alu_op, rd_sel;
  
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

  always @(posedge clk, negedge rst_f)
  begin
    if (rst_f == 1'b0)
      present_state <= start1;
    else
      present_state <= next_state;
  end
  
  /* Combinational procedure that determines the next state of the fsm. */

  always @(present_state, rst_f)
  begin
    case(present_state)
      start0:	 next_state <= start1;
      start1:	 next_state <= decode;
      fetch:	 next_state <= decode;
      decode:	 next_state <= execute;
      execute:	 next_state <= mem;
      mem:	 next_state <= writeback;
      writeback: next_state <= fetch;
      default:
        next_state = start1;
    endcase
  end
  

//Check on rising clock edges
always @(posedge clk)
	begin
	//first check for no operation
	if(opcode == NOOP)
		begin
		rf_we<=0;
		alu_op<=2'b00;
		wb_sel<=0;
		PC_Sel<=0;
		PC_RST<=0;
		BR_Sel<=0;
		end
	//second check state
	if(present_state == fetch)
		begin
		PC_Write<=1;
		PC_RST<=0;
		PC_Sel<=0;
			
		rf_we<=0;
		alu_op <= 2'b00;
		wb_sel<=0;
		//third check opcode
		if(opcode == ALU_OP) 
			begin
			rf_we=1'b0;
			alu_op=2'b00;
			wb_sel=1'b0;
			BR_Sel<=0;
			PC_Sel<=0;
			
			end
		if((	   opcode==BNE)	
			||(opcode==BRA)	
			||(opcode==BRR))	
			begin
			wb_sel<=0;
			rf_we<=0;
			alu_op<=2'b10;
			end
		end
		
	else if (present_state == decode)
		begin
		PC_Write<=0;
		if(opcode == 4'b1000) //opcode for ALU op
			begin
				if(mm==4'b1000)
					begin
					rd_sel<=1;
					end
				else
					begin
					rd_sel<=0;
					end
			end
		else
			begin
			rd_sel<=0;
			end
		end
	else if (present_state == execute)
		begin
		
		//third check opcode
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
		if(opcode==BNE)
			begin
			if((mm&stat)==4'b0000)
				begin
				PC_Sel<=1; 
				BR_Sel<=1;
				present_state<=fetch;
				end
			else
				begin
				PC_Sel<=0;
				end
			end
		
		
		if(opcode==BRR)
			begin
			if((mm&stat)!=4'b0000)
				begin
				PC_Sel<=1; 
				BR_Sel<=0;
				present_state<=fetch;
				end
			else
				begin
				PC_Sel<=0;
				end
			end
		

		if(opcode==BRA)
			begin
			if((mm&stat)!=4'b0000)
				begin
				PC_Sel<=1; 
				BR_Sel<=1;
				present_state<=fetch;
				end
			else
				begin
				PC_Sel<=0;
				end
			end
		end
	else if (present_state == mem)
		begin
		//third check opcode
		if(opcode == 4'b1000) //opcode for ALU op
			begin
			rf_we=1;
			end
		end
	else if (present_state == writeback)
		begin
			//writeback state not yet used
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
