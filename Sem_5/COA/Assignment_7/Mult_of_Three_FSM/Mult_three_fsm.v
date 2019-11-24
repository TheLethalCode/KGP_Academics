`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:56 08/21/2019 
// Design Name: 
// Module Name:    Mult_three_fsm 
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
module Mult_three_fsm(
		input clk,
		input in,
		input rst,
		output div
    );

	reg [1:0] state;
	assign div = (state == 0);
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			state <= 0;
		else
		begin
			case (state)
				0 : state <= in? 1: 0;
				1 : state <= in? 0: 2;
				2 : state <= in? 2: 0;
			endcase
		end
	end
endmodule
