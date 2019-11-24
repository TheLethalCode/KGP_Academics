`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:39:22 08/19/2019
// Design Name:   ripple_carry_adder
// Module Name:   D:/ripple_carry_adder/ripple_carry_adder_testbench.v
// Project Name:  ripple_carry_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ripple_carry_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

/*
    Assignment No. :- 6
    Problem No :- 1
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

module ripple_carry_adder_testbench;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg c_in;

	// Outputs
	wire [7:0] sum;
	wire c_out;

	// Instantiate the Unit Under Test (UUT)
	ripple_carry_adder uut (
		.a(a), 
		.b(b), 
		.c_in(c_in), 
		.sum(sum), 
		.c_out(c_out)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		c_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time,"\ta=%d,\tb=%d,\tc_in=%d,\tsum=%d,\tc_out=%d \ttotal=%d",a,b,c_in,sum,c_out, {c_out, sum});

		// Checking the adder for 8 inputs
		#2 a = 0; b = 0; c_in = 1;
		#2 a = 22; b = 33; c_in = 0;
		#2 a = 34; b = 78; c_in = 1;
		#2 a = 54; b = 69; c_in = 0;
		#2 a = 91; b =11; c_in = 1;
		#2 a = 32; b = 89; c_in = 0;
		#2 a = 128; b = 128; c_in = 1;
		#2 $finish;

	end
      
endmodule

