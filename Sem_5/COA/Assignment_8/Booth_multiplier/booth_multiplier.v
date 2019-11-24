`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:57:49 08/28/2019 
// Design Name: 
// Module Name:    booth_multiplier 
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
module booth_multiplier(
		input clk,
		input rst,
		input load,
		input [5:0] a,
		input [5:0] b,
		output [11:0] product
    );

	reg signed [12:0] A, S, P; // P=temporary product, A=positive multiplicand, S = negative multiplicand
	reg [5:0] sto_a, sto_b; // Registers for parallel load of input
	reg [2:0] cntr; // cntr keeping track of number of loops
	
	assign product = P[12:1];
	
	always @(posedge clk or posedge rst) begin // When clk or rst rises up
		if(rst) begin  // If rst is pressed, reset everything to 0
			A <= 0;
			S <= 0;
			P = 0;
			sto_a <= 0;
			sto_b <= 0;
			cntr = 0;
		end
		else if(load) begin // If load is pressed, load data and reset everything else
			sto_a <= a;
			sto_b <= b;
			cntr = 0;
			A <= 0;
			S <= 0;
			P = 0;
		end
		else if(!cntr) begin // If first run, assign values to A, S, P
			A <= sto_a << 7;
			S <= -sto_a << 7;
			P = sto_b << 1;
			cntr = cntr + 1;
		end
		else if( cntr <= 6) begin // Run the loop for 6 times
			if(P[0] ^ P[1] == 0) // If last two significants are the same
				P = P >> 1;
			else if(P[0]) // If least 2 significant numbers is 01
				P = (P + A) >> 1;
			else // If least 2 significant numbers is 10
				P = (P + S) >> 1;
			P[12] = P[11];
			cntr = cntr + 1; // Increasing cntr
		end
	end
	
endmodule
