`timescale 1ns / 1ps
`include "lookahead_adder.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:59 08/19/2019 
// Design Name: 
// Module Name:    hybrid_adder 
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
    Problem No :- 2
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

module hybrid_adder(
		input [7:0] a,
		input [7:0] b,
		input cin,
		output [7:0] sum,
		output cout
    );
	
    wire temp;
	
	// Combination of 2 carry_lookahead adders
    lookahead_adder a1(a[3:0],b[3:0],cin,sum[3:0],temp);
    lookahead_adder a2(a[7:4],b[7:4],temp,sum[7:4],cout);

endmodule
