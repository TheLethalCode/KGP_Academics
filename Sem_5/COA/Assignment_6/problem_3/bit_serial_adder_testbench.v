`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:53:18 08/19/2019
// Design Name:   bit_serial_adder
// Module Name:   D:/bit_serial_adder/bit_serial_adder_testbench.v
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

module bit_serial_adder_testbench;

	// Inputs
	reg clock;
	reg reset_shift;
	reg reset_flip_flop;
	reg load;
	reg serial_in_parallel_out_load;
	reg [7:0] a;
	reg [7:0] b;
	reg c_in;

	// Outputs
	wire [7:0] sum;
	wire c_out;

	// Instantiate the Unit Under Test (UUT)
	bit_serial_adder uut (
		.clock(clock), 
		.reset_shift(reset_shift), 
		.reset_flip_flop(reset_flip_flop), 
		.load(load), 
		.serial_in_parallel_out_load(serial_in_parallel_out_load), 
		.a(a), 
		.b(b), 
		.c_in(c_in), 
		.sum(sum), 
		.c_out(c_out)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset_shift = 0;
		reset_flip_flop = 0;
		load = 0;
		serial_in_parallel_out_load = 0;
		a = 0;
		b = 0;
		c_in = 0;

		// Wait 100 ns for global reset to finish
		#50
		reset_flip_flop = 1'b0;
		
		#400
		load = 1'b0;
        
		// Add stimulus here

	end
	
	always
		#25 clock = !clock;
		
   initial begin
		#850 serial_in_parallel_out_load = 1'b1;
		$display("%d, %d, %d", a, b, sum);
	end
      
endmodule

