`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:18:38 08/28/2019
// Design Name:   booth_multiplier
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_8/Booth_mutiplier/booth_multiplier_tb.v
// Project Name:  Booth_mutiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: booth_multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module booth_multiplier_tb;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg signed [5:0] a;
	reg signed [5:0] b;

	// Outputs
	wire signed [11:0] product;

	// Instantiate the Unit Under Test (UUT)
	booth_multiplier uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.a(a), 
		.b(b), 
		.product(product)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		load = 0;
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		a = 43;
		b = 23;
		
		#21
		rst = 0;
		load = 1;
		
		#12
		load = 0;
		
		// Add stimulus here
		$monitor($time,"\tclk = %d \trst = %d \tload = %d \ta=%d \tb=%d \tproduct=%d",clk,rst,load,a,b,product);
		#500 $finish;
	end
	
	always
		#5 clk = !clk;		
      
endmodule

