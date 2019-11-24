`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:12 11/06/2019 
// Design Name: 
// Module Name:    barrel_shifter 
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
module barrel_shifter(
		input [31:0] in,
		input [4:0] shamt, // Amount of shifting
		input dir, // The direction of shifting
		output reg [63:0] out
    );

	// Shifting according to the amount specified 
	always @(in or shamt or dir)
	begin
	
		out = in;
		if(shamt[0])
			out = dir? out << 1: out >> 1;
		if(shamt[1])
			out = dir? out << 2: out >> 2;
		if(shamt[2])
			out = dir? out << 4: out >> 4;
	end
endmodule
