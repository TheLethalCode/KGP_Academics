`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:13:02 08/26/2019
// Design Name:   unsigned_seq_mult_RS
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_8/Seq_unsigned_multiplier_right/unsigned_seq_mult_RS_tb.v
// Project Name:  Seq_unsigned_multiplier_right
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: unsigned_seq_mult_RS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module unsigned_seq_mult_RS_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [5:0] a;
	reg [5:0] b;
	reg load;
	
	// Outputs
	wire [11:0] product;

	// Instantiate the Unit Under Test (UUT)
	unsigned_seq_mult_RS uut (
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
		a = 23;
		b = 43;

		// Wait 100 ns for global reset to finish
		#101
      rst = 0;
		load = 1;	
		// Add stimulus here
		#20
		load = 0;
		
		$monitor($time,"\tclk = %d \trst = %d \tsto_a=%d \tsto_b=%d \tproduct=%d",clk,rst,a,b,product);
		#500 $finish;
	end
     
	always 
	#5 clk = !clk;
		
endmodule

