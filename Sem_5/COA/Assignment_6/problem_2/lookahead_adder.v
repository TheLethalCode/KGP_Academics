`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:31 08/19/2019 
// Design Name: 
// Module Name:    lookahead_adder 
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

module lookahead_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
    );

	wire [2:0] temp_c;
	wire [3:0] D;
	wire [3:0] T;
	
	// Calculating Di
	assign D[0] = a[0] & b[0]; 
	assign D[1] = a[1] & b[1]; 
	assign D[2] = a[2] & b[2]; 
	assign D[3] = a[3] & b[3];
	
	// Calculating Ti
	assign T[0] = a[0] ^ b[0]; 
	assign T[1] = a[1] ^ b[1]; 
	assign T[2] = a[2] ^ b[2]; 
	assign T[3] = a[3] ^ b[3];

	// With Di and Ti calculate carry in for each bit
	assign temp_c[0] = D[0] | (T[0] & cin);
	assign temp_c[1] = D[1] | (T[1] & (D[0] | (T[0] & cin)));
	assign temp_c[2] = D[2] | (T[2] & (D[1] | (T[1] & (D[0] | (T[0] & cin)))));
	assign cout = D[3] | (T[3] & (D[2] | (T[2] & (D[1] | (T[1] & (D[0] | (T[0] & cin)))))));

	// Calculate time for each bit
	assign sum[0] = T[0] ^ cin;
	assign sum[1] = T[1] ^ temp_c[0];
	assign sum[2] = T[2] ^ temp_c[1];
	assign sum[3] = T[3] ^ temp_c[2];
	
endmodule
