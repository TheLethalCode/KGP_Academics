`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:54 11/05/2019 
// Design Name: 
// Module Name:    instrn_decode 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module instrn_decode(
		input clk,
		input [31:0] instrn,
		input [31:0] PC_old,
		output [31:0] PC
    );

	reg [5:0] opCode;
	reg [25:0] data, cycle;
	
	initial begin 
		cycle = 0;
	end

	// Separate the opCode, and data and Call control Unit
	control_unit main(clk,instrn[31:26],instrn[25:0],PC_old, PC);
	
	always @(posedge clk) begin
		// $display($time,"\tIN DECODE(%d) : PC_old = %d, instrn = %b, PC = %d", cycle, PC_old, instrn, PC);
		cycle = cycle + 1; // Calculate the number of clock cycles
	end
endmodule
