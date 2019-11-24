`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:22:37 08/19/2019 
// Design Name: 
// Module Name:    shift_register 
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
module shift_register(
    input clock,
    input reset,
    input load,
    input [7:0] inpt,
    output reg [7:0] outpt
    );
	
	//reg [7:0] outpt;
	always @(posedge clock)
	begin
		if(load == 0 & reset == 0)
			outpt = outpt>>1;
		else if(load == 1 & reset == 0)
			outpt = inpt;
		else
			outpt = 8'b0;	
	end		
			

endmodule
