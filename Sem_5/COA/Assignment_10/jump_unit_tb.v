`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:15:27 11/05/2019
// Design Name:   jump_unit
// Module Name:   D:/assgn_9/RISC/jump_unit_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: jump_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module jump_unit_tb;

	// Inputs
	reg [21:0] addr;
	reg [3:0] func;
	reg carryFlag;
	reg signFlag;
	reg overflowFlag;
	reg zeroFlag;
	reg [31:0] raReg;
	reg [31:0] PC;
	reg ena;

	// Outputs
	wire [31:0] PC_new;
	wire [31:0] ra_new;

	// Instantiate the Unit Under Test (UUT)
	jump_unit uut (
		.addr(addr), 
		.func(func), 
		.carryFlag(carryFlag), 
		.signFlag(signFlag), 
		.overflowFlag(overflowFlag), 
		.zeroFlag(zeroFlag), 
		.raReg(raReg), 
		.PC(PC), 
		.ena(ena), 
		.PC_new(PC_new), 
		.ra_new(ra_new)
	);

	initial begin
		// Initialize Inputs
		addr = 0;
		func = 0;
		carryFlag = 0;
		signFlag = 0;
		overflowFlag = 0;
		zeroFlag = 0;
		raReg = 0;
		PC = 0;
		ena = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		$monitor($time,"\taddr = %b,\tfunc = %d,\tflag = %b,\traReg = %d,\tPC = %d, \tPC_new = %d, \tra_new = %d ",addr, func, {carryFlag, signFlag, overflowFlag, zeroFlag}, raReg, PC, PC_new, ra_new);
		
		// CALL
		#3 func = 0; addr = 25; PC = 1; ena = 1;
		#5 ena = 0;
		#10 func = 0; addr = 12; PC = 5; ena = 1;
		#5 ena = 0;

		// Branch on No Overflow
		#3 func = 1; addr = 25; PC = 1; overflowFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 1; addr = 12; PC = 5; overflowFlag = 0; ena = 1;
		#5 ena = 0;
		
		// Branch on Overflow
		#3 func = 2; addr = 25; PC = 1; overflowFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 2; addr = 12; PC = 5; overflowFlag = 0; ena = 1;
		#5 ena = 0;
		
		// Branch on No Sign
		#3 func = 3; addr = 25; PC = 1; signFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 3; addr = 12; PC = 5; signFlag = 0; ena = 1;
		#5 ena = 0;
		
		// Branch on Sign
		#3 func = 4; addr = 25; PC = 1; signFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 4; addr = 12; PC = 5; signFlag = 0; ena = 1;
		#5 ena = 0;
		
		// Branch on No Carry
		#3 func = 5; addr = 25; PC = 1; carryFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 5; addr = 12; PC = 5; carryFlag = 0; ena = 1;
		#5 ena = 0; 
		
		// Branch on Carry
		#3 func = 6; addr = 25; PC = 1; raReg = 98; carryFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 6; addr = 12; PC = 5; carryFlag = 0; ena = 1;
		#5 ena = 0;
		
		// Branch on No Zero
		#3 func = 7; addr = 25; PC = 1; zeroFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 7; addr = 12; PC = 5; zeroFlag = 0; ena = 1;
		#5 ena = 0; 
		
		// Branch on Zero
		#3 func = 8; addr = 25; PC = 1; zeroFlag = 1; ena = 1;
		#5 ena = 0;
		#10 func = 8; addr = 12; PC = 5; zeroFlag = 0; ena = 1;
		#5 ena = 0; 
		 
		 // Uncondtional Branch
		#3 func = 9; addr = 125; PC = 1; ena = 1;
		#5 ena = 0;
		
		// Return
		#3 func = 10; addr = 25; PC = 1; raReg = 17; ena = 1;
		#5 ena = 0;
		// Add stimulus here

	end
      
endmodule