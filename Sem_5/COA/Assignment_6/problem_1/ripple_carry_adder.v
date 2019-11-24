`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:36:19 08/19/2019 
// Design Name: 
// Module Name:    ripple_carry_adder 
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
    Problem No :- 1
    Group No :- 61

    Name1 :- Kousshik Raj
    Roll No. 1:- 17CS30022
    
    Name2 :- Prashant Ramnani
    Roll No. 2:- 17CS10038
*/

module ripple_carry_adder(
    input [7:0] a,
    input [7:0] b,
    input  c_in,
    output [7:0] sum,
    output c_out
    );
	 
	 wire [6:0] temp_c;

	// Cascading 8 1 bit full adders
	full_adder a1(a[0], b[0], c_in, sum[0], temp_c[0]);
	full_adder a2(a[1], b[1], temp_c[0], sum[1], temp_c[1]);
	full_adder a3(a[2], b[2], temp_c[1], sum[2], temp_c[2]);
	full_adder a4(a[3], b[3], temp_c[2], sum[3], temp_c[3]);
	full_adder a5(a[4], b[4], temp_c[3], sum[4], temp_c[4]);
	full_adder a6(a[5], b[5], temp_c[4], sum[5], temp_c[5]);
	full_adder a7(a[6], b[6], temp_c[5], sum[6], temp_c[6]);
	full_adder a8(a[7], b[7], temp_c[6], sum[7], c_out);

endmodule
