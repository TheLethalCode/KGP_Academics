`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:20:03 11/05/2019
// Design Name:   ALU_imm_unit
// Module Name:   D:/assgn_9/RISC/alu_imm_unit_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU_imm_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_imm_unit_tb;

	// Inputs
	reg [31:0] inp1;
	reg [15:0] inp2;
	reg [1:0] func;
	reg ena;

	// Outputs
	wire [31:0] res1;
	wire carryFlag;
	wire signFlag;
	wire overflowFlag;
	wire zeroFlag;

	// Instantiate the Unit Under Test (UUT)
	ALU_imm_unit uut (
		.inp1(inp1), 
		.inp2(inp2), 
		.func(func), 
		.ena(ena), 
		.res1(res1), 
		.carryFlag(carryFlag), 
		.signFlag(signFlag), 
		.overflowFlag(overflowFlag), 
		.zeroFlag(zeroFlag)
	);

	initial begin
		// Initialize Inputs
		inp1 = 0;
		inp2 = 0;
		func = 0;
		ena = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("inp1 = %d, \t inp2 = %d, \t func = %d,\t res1 = %d,\t flags = %b", inp1, inp2, func, res1, {carryFlag, signFlag, overflowFlag, zeroFlag});
		#3 func = 0; inp1 = 12; inp2 = 34; ena = 1;
		#5 ena = 0;
		#10 func = 0; inp1 = 1; inp2 = -2; ena = 1;
		#5 ena = 0;
		#10 func = 0; inp1 = 2; inp2 = -1; ena = 1;
		#5 ena = 0; 
		  
		#10 func = 1; inp2 = 0; ena = 1;
		#5 ena = 0;
		#10 func = 1; inp2 = -1; ena = 1;
		#5 ena = 0;
		#10 func = 1; inp2 = 1; ena = 1;
		
	end
      
endmodule

