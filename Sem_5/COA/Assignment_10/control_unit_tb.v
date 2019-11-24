`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:31:48 11/05/2019
// Design Name:   control_unit
// Module Name:   D:/assgn_9/RISC/control_unit_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_unit_tb;

	// Inputs
	reg clk;
	reg [5:0] opCode;
	reg [25:0] data;
	reg [31:0] PC_old;

	// Outputs
	wire [31:0] PC;

	// Instantiate the Unit Under Test (UUT)
	control_unit uut (
		.clk(clk), 
		.opCode(opCode), 
		.data(data), 
		.PC_old(PC_old), 
		.PC(PC)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		opCode = -1;
		data = 0;
		PC_old = 0;

		// Wait 100 ns for global reset to finish
		#100 

		$monitor("PC: %d &&&", PC); 
		
		opCode = 6'b1;
		data = {5'd10,16'd9,2'd0,3'd0};
		#40 
		
		PC_old = PC;
		opCode = 6'b1;
		data = {5'd11,16'd6,2'd0,3'd0};
		#40
		
		PC_old = PC;
		opCode = 6'b0;
		data = {5'd11,5'd10,5'd0,6'd0,5'd0};
		#50
	
		PC_old = PC;
		opCode = 6'd3;
		data = {5'd11,17'b0,4'd11};
		#30
		 
		$finish;
		// Add stimulus here
		
	end
	
	always #5 clk = !clk;
      
endmodule

