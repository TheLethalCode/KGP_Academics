`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:03 08/19/2019 
// Design Name: 
// Module Name:    bit_serial_adder 
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

/*
    Assignment No. :- 6
    Problem No :- 3
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

// A single bit full adder
module full_adder(
		input a,
		input b,
		input cin,
		output sum,
		output cout
	);
	assign {cout, sum} = a + b + cin;

endmodule

// This is a positive edge triggered D - flip flop
module DFlipFlop(
		input clk,
		input rst,
		input D,
		input cin, 
		output reg Q
	);
	
	always @(posedge clk or posedge rst) // If rst = 0, normal functioning ; else assign the intial carry in
	begin
		if(rst)
			Q=cin;
		else
			Q=D;
	end
endmodule

// Module for parallel in serial out shift register
module PISO(
	input [7:0] a,
	input clk,
	input load,
	input rst,
	output reg [7:0] out
	);

	always @(posedge clk or posedge rst or load)
	begin
		// if rst = 1, then out = 0
		if(rst)
			out=8'b0;
		// if rst = 0, load =1, then out = input
		else if(load)
			out=a;
		else // if rst =, load =0, shifting
			out = out >> 1;
	end
endmodule

// Serial in parallel out shift register
module SIPO(
	input clk,
	input rst,
	input a,
	output reg [7:0] sum
	);

	// Positive edge triggered flip flop
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			sum=8'b0;
		else
			sum = {a, sum[7:1]};
	end
endmodule

module bit_serial_adder(
		input [7:0] a,
		input [7:0] b,
		input cin,
		input clk,
		input load,
		input rst,
		output [7:0] sum,
		output cout
    );
	 wire [7:0] in1,in2;
	 wire cur_state, next_state, temp_s;
	 
	 // Serialize the input
	 PISO a1(a, clk, load, rst, in1);
	 PISO b1(b, clk, load, rst, in2);
	 
	 // pass it to the adder
	 full_adder f1(in1[0], in2[0], cur_state, temp_s, next_state);
	 
	 // Remember the carry
	 DFlipFlop D1(clk, rst, next_state, cin, cur_state	);
	 
	 // Send the output to SIPO module, so that sum can be generated
	 SIPO X(clk, rst, temp_s, sum);
	 
endmodule
