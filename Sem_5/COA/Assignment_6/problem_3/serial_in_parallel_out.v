`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:29:06 08/19/2019 
// Design Name: 
// Module Name:    serial_in_parallel_out 
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
module serial_in_parallel_out(
    input clock,
    input load,
    input inpt,
    output reg [7:0] outpt
    );
	
	//reg [7:0] outpt;
	always @(posedge clock)
	begin	
		if(load == 0)
			outpt = {inpt, outpt[7:1]};
	end	

endmodule
