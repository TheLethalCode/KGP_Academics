`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:21:25 08/19/2019
// Design Name:   bit_serial_adder
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_6/bit_serial_adder/bit_serial_adder_tb.v
// Project Name:  bit_serial_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bit_serial_adder
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
    Problem No :- 3
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

module bit_serial_adder_tb;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;
	reg cin;
	reg clk;
	reg load;
	reg rst;
	
	// Outputs
	wire [7:0] sum;
	wire cout;

	// Temp
	reg [4:0] cntr;

	// Instantiate the Unit Under Test (UUT)
	bit_serial_adder uut (
		.a(a), 
		.b(b), 
		.cin(cin), 
		.clk(clk), 
		.load(load), 
		.rst(rst), 
		.sum(sum), 
		.cout(cout)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		cin = 0;
		clk = 0;
		load = 0;
		rst = 0;
		cntr = 5'b0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		// Make load and reset 1
		rst = 1;
		#20;
		
		// Make reset 0, load 1, actual loading happens in PISO shift register 
		rst = 0;
		#20; 
		load = 1; a = 13; b = 12;
		#20;

		end
		
		always
		begin
		
			#50; // Clock cycle of time period 100 ns
			if(cntr == 16) // If clock changes 16 times stop
				$finish;
		
			cntr = cntr + 1; // Increase the number of time clock incresases
			clk = !clk; // Toggle clock
			$monitor($time,"\ta=%d,\tb=%d,\tc_in=%d,\tsum=%d, \tclk=%d, \tc_out=%d",a,b,cin,sum,clk	,cout);
		end
endmodule

