`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:21 08/26/2019
// Design Name:   unsigned_seg_mult_LS
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_8/Seq_unsigned_multiplier_left/unsigned_seq_mult_LS_tb.v
// Project Name:  Seq_unsigned_multiplier_left
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: unsigned_seg_mult_LS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module unsigned_seq_mult_LS_tb;

	// Inputs
	reg clk;
	reg rst;
	reg load;
	reg [5:0] a;
	reg [5:0] b;

	// Outputs
	wire [11:0] product;

	// Instantiate the Unit Under Test (UUT)
	unsigned_seg_mult_LS uut (
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
      
		a = 23;
		b = 43;
		
		#21
		rst = 0;
		load = 1;
		
		#12
		load =0;
		
		// Add stimulus here
		$monitor($time,"\tclk = %d \trst = %d \tload = %d \ta=%d \tb=%d \tproduct=%d",clk,rst,load,a,b,product);
		#500 $finish;
	end
	
	always
		#5 clk = !clk;		
      
endmodule

