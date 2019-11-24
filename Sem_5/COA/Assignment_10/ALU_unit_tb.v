`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:18:38 11/05/2019
// Design Name:   ALU_unit
// Module Name:   D:/assgn_9/RISC/ALU_unit_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_unit_tb;

	// Inputs
	reg [31:0] inp1;
	reg [31:0] inp2;
	reg [5:0] shAmt; 
	reg [5:0] func;
	reg ena;

	// Outputs
	wire [31:0] res1;
	wire [31:0] res2;
	wire carryFlag;
	wire signFlag;
	wire overflowFlag;
	wire zeroFlag;

	// Instantiate the Unit Under Test (UUT)
	ALU_unit uut ( 
		.inp1(inp1), 
		.inp2(inp2), 
		.func(func),
		.shAmt(shAmt),	
		.ena(ena), 
		.res1(res1), 
		.res2(res2), 
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
		shAmt = 0;
		ena = 0;
      
		// Wait 100 ns for global reset to finish
		#100;
		
		
		$monitor("inp1 = %d, \t inp2 = %d, \t func = %d, \t shAmt = %d,\t res1 = %d, \t res2 = %d, \t flags = %b", inp1, inp2, func, shAmt, res1, res2, {carryFlag, signFlag, overflowFlag, zeroFlag});
		//ADD
		#3 func = 0; inp1 = 12; inp2 = 34; ena = 1;
		#5 ena = 0;
		#10 func = 0; inp1 = 12; inp2 = -12; ena = 1;
		#5 ena = 0;
		#10 func = 0; inp1 = 11; inp2 = -12; ena = 1;
		#5 ena = 0;
		#10 func = 0; inp1 = {32{1'b1}}; inp2 = {32{1'b1}}; ena = 1;
		
		// 2's compliment
		#5 ena = 0;
		#10 func = 3; inp1 = 4; ena = 1;
		#5 ena = 0;
		#10 func = 3; inp1 = 0; ena = 1;	
		#5 ena = 0;
		// Bitwise AND
		#10 func = 4; inp1 = {32{1'b1}}; inp2 = {32{1'b1}}; ena = 1;
		#5 ena = 0;
		#10 func = 4; inp1 = 3; inp2 = 2; ena = 1;
		#5 ena = 0;
		#10 func = 4; inp1 = {32{1'b1}}; inp2 = 2047; ena = 1;
		#5 ena = 0;
		// Bitwise XOR
		#10 func = 5; inp1 = {32{1'b1}}; inp2 = {32{1'b1}}; ena = 1;
		#5 ena = 0;
		#10 func = 5; inp1 = 3; inp2 = 2; ena = 1;
		#5 ena = 0;
		#10 func = 5; inp1 = {32{1'b1}}; inp2 = 2047; ena = 1;
		#5 ena = 0;
		// Shift left logical
		#10 func = 6; inp1 = 32'd42; shAmt = 3; ena = 1;
		#5 ena = 0;
		#10 func = 6; inp1 = 3; shAmt = 4; ena = 1;
		#5 ena = 0;
		#10 func = 6; inp1 = {32{1'b1}}; shAmt = 5; ena = 1;
		#5 ena = 0;
		// Shift right logical
		#10 func = 7; inp1 = 32'd42; shAmt = 3; ena = 1;
		#5 ena = 0;
		#10 func = 7; inp1 = 3; shAmt = 4; ena = 1;
		#5 ena = 0;
		#10 func = 7; inp1 = {32{1'b1}}; shAmt = 5; ena = 1;
		#5 ena = 0;
		// Shift left logical variable
		#10 func = 8; inp1 = 32'd42; inp2 = 3; ena = 1;
		#5 ena = 0;
		#10 func = 8; inp1 = 3; inp2 = 4; ena = 1;
		#5 ena = 0;
		#10 func = 8; inp1 = {32{1'b1}}; inp2 = 5; ena = 1;
		#5 ena = 0;	
		// Shift right logical variable
		#10 func = 9; inp1 = 32'd42; inp2 = 3; ena = 1;
		#5 ena = 0;
		#10 func = 9; inp1 = 3; inp2 = 4; ena = 1;
		#5 ena = 0;
		#10 func = 9; inp1 = {32{1'b1}}; inp2 = 5; ena = 1;
		#5 ena = 0;
		
		// Shift right arithmetic 
		#10 func = 10; inp1 = 32'd42; shAmt = 3; ena = 1;
		#5 ena = 0;
		#10 func = 10; inp1 = 3; shAmt = 4; ena = 1;
		#5 ena = 0;
		#10 func = 10; inp1 = {32{1'b1}}; shAmt = 5; ena = 1;
		#5 ena = 0;
		
		// Shift right arithmetic variable
		#10 func = 11; inp1 = 32'd42; inp2 = 3; ena = 1;
		#5 ena = 0;
		#10 func = 11; inp1 = 3; inp2 = 4; ena = 1;
		#5 ena = 0;
		#10 func = 11; inp1 = {32{1'b1}}; inp2 = 5; ena = 1;
		#5 ena = 0;
	end

		
endmodule

