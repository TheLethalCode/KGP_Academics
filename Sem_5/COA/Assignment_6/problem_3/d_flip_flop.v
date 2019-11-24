`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:33 08/19/2019 
// Design Name: 
// Module Name:    d_flip_flop 
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
module d_flip_flop(
    input clock,
    input reset,
    input d,
    input c_in,
    output reg q
    );
	
	always @(posedge clock)	//if reset=0, Q=D, else Q=cin
	begin	
		if(reset == 0)
			q = d;
		else
			q = c_in;
	end

endmodule
