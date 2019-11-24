`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:50 08/19/2019
// Design Name:   hybrid_adder
// Module Name:   D:/hybrid_adder/hybrid_adder_tb.v
// Project Name:  hybrid_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: hybrid_adder
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
    Problem No :- 2
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

module hybrid_adder_tb;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg cin;

	// Outputs
	wire [7:0] sum;
	wire cout;

	// Instantiate the Unit Under Test (UUT)
	hybrid_adder uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.sum(sum), 
		.cout(cout)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time,"\ta=%d,\tb=%d,\tc_in=%d,\tsum=%d,\tc_out=%d",a,b,cin,sum,cout);

		// Checking adder for 8 inputs
		#2 a = 22; b = 33; cin = 0;
		#2 a = 34; b = 78; cin = 1;
		#2 a = 54; b = 69; cin = 0;
		#2 a = 91; b =11; cin = 1;
		#2 a = 32; b = 89; cin = 0;
		#2 a = 128; b = 128; cin = 1;
		#2 $finish;

	end
      
endmodule

