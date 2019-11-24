`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:25:59 09/11/2019
// Design Name:   sum_of_hex_digits_ckt
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/sum_of_hex_digits_ckt/sum_of_hex_digits_ckt_tb.v
// Project Name:  sum_of_hex_digits_ckt
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sum_of_hex_digits_ckt
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// Name :- Kousshik Raj M
// Roll No. :- 17CS30022
//////////////////////////////////////////////////////////////////////////////////


module sum_of_hex_digits_ckt_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] num;

	// Outputs
	wire [6:0] sum_of_hex_digits;

	// Instantiate the Unit Under Test (UUT)
	sum_of_hex_digits_ckt uut (
		.clk(clk), 
		.rst(rst), 
		.num(num), 
		.sum_of_hex_digits(sum_of_hex_digits)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		num = 4'ha1fb;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Display the values of clk, rst, num (in hexadecimal), and output sum
		$monitor($time,"\tclk = %d \trst = %d \tnum = %x \tsum=%d",clk,rst,num,sum_of_hex_digits);
		
		rst = 1; // Make rst 1 so that input is loaded
		#9 rst =0; // Make rst 0, to carry the process
		
		#100 $finish; // Wait for 10 clock cycles and finish
	end
    
	 // Clock of time period 10ns
	 always #5 clk = !clk;      
endmodule

