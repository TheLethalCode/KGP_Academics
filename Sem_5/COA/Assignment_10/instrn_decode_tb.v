`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:28:12 11/06/2019
// Design Name:   instrn_decode
// Module Name:   D:/assgn_9/RISC/instrn_decode_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instrn_decode
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instrn_decode_tb;

	// Inputs
	reg clk;
	reg [31:0] instrn;
	reg [31:0] PC_old;

	// Outputs
	wire [31:0] PC;

	// Instantiate the Unit Under Test (UUT)
	instrn_decode uut (
		.clk(clk), 
		.instrn(instrn), 
		.PC_old(PC_old), 
		.PC(PC)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		instrn = 0;
		PC_old = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor("DECODE: PC = %d",PC);
		instrn = 32'b00000101010000000000000011001000;
		#40
		instrn = 32'b00000101011000000000000011101000;
		#40 $finish;
	end
	
	always #5 clk = !clk;
      
endmodule

