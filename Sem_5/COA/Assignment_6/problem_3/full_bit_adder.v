`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:15:39 08/19/2019 
// Design Name: 
// Module Name:    full_bit_adder 
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
module full_bit_adder(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
    );
	
	assign {c_out, sum} = a + b + c_in;
	
endmodule
