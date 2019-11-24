`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:22:03 08/21/2019
// Design Name:   Mult_three_fsm
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_7/Mul_of_Three_FSM/Mult_three_fsm_tb.v
// Project Name:  Mul_of_Three_FSM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mult_three_fsm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Mult_three_fsm_tb;

	// Inputs
	reg clk;
	reg in;
	reg rst;

	// Outputs
	wire div;

	// Instantiate the Unit Under Test (UUT)
	Mult_three_fsm uut (
		.clk(clk), 
		.in(in), 
		.rst(rst), 
		.div(div)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		in = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time,"\tclk = %d \trst = %d \tin = %d \tdiv=%d",clk,rst,in,div);
		
		#11; 
		
		rst = 0; // Make rst 0
		
		// Starting inputs
		in = 1;
		#10 in = 1;
		#10 in = 0;
		#10 in = 1;
		#10 in = 0;
		#10 in = 0;
		#10 in = 1;
		#10 in = 1;
		#10 in = 0;
		#5 $finish;
	end
   
	always
			#5 clk = !clk;

endmodule

