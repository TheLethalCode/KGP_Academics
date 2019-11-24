`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:25 08/26/2019 
// Design Name: 
// Module Name:    unsigned_seg_mult_LS 
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
module unsigned_seg_mult_LS(
		input clk,
		input rst,
		input load,
		input [5:0] a,
		input [5:0] b,
		output reg [11:0] product
    );
	 
	 reg [3:0] cntr; // cntr to keep track of the loop
	 reg [5:0] store_a, store_b; // registers to store the value of inputs
	 
	 always @(posedge clk or posedge rst) begin // change when clk or rst rises
		
		if(rst) begin  // if rst is pressed, bring everything to in initial value
			store_a <= 0;
			store_b <= 0;
			cntr = 0;
			product <= 0;
		end
		
		else if(load) begin // if load is pressed, load the input to registers
			store_a <= a;
			store_b <= b;
			cntr = 0;
			product <= 0;
		end
		
		else if(cntr < 6) begin // if cntr <= 5, run the loop
			if(store_a[0]) // if the current input bit is 1
				product <= product + (store_b << cntr);
			store_a <= store_a >> 1; // shift a 1 bit right
			cntr = cntr + 1; // increase cntr
		end
	 end
endmodule
