`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:00 08/21/2019 
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
		input [7:0] in,
		input [2:0] shamt,
		input dir,
		output reg [7:0] out
    );

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
