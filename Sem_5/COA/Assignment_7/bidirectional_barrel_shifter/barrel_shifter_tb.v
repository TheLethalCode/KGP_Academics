`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:00 08/21/2019
// Design Name:   barrel_shifter
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/Assgn_7/bidirectional_barrel_shifter/barrel_shifter_tb.v
// Project Name:  bidirectional_barrel_shifter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: barrel_shifter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module barrel_shifter_tb;

	// Inputs
	reg [7:0] in;
	reg [2:0] shamt;
	reg dir;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	barrel_shifter uut (
		.in(in), 
		.shamt(shamt), 
		.dir(dir), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		shamt = 0;
		dir = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time,"in = %b \tshamt=%d \tdir=%d \tout=%b\n", in, shamt, dir, out);
		#2 in = 47; shamt = 3; dir = 1;
		#2 in = 47; shamt = 3; dir = 0;
		#2 $finish;
	end
      
endmodule

