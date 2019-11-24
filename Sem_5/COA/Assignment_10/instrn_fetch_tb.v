`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:17:52 11/05/2019
// Design Name:   instrn_fetch
// Module Name:   D:/assgn_9/RISC/instrn_fetch_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instrn_fetch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

// TEST BENCH FOR LINEAR SEARCH OF 1 IN [1,2,-1,3,-4,5,6,0]

module instrn_fetch_tb;

	// Inputs
	reg clk;
	reg rst;

	// Instantiate the Unit Under Test (UUT)
	instrn_fetch uut (
		.clk(clk), 
		.rst(rst),
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
           
		// Add stimulus here
	end
   
	always #1 clk = !clk;
	
endmodule

