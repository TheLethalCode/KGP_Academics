`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:18 08/26/2019 
// Design Name: 
// Module Name:    unsigned_seq_mult_RS 
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
module unsigned_seq_mult_RS(
	input  clk,
	input  rst,
	input load,
	input [5:0] a,
	input [5:0] b,
	output reg [12:0] product
	);
	
	reg [5:0] store_a, store_b; //shift register to store the value of a and b
	reg [2:0] cntr;					// counter to keep a track of number of cycles
	reg [12:0] temp;					// Storing the value 6, the number by which b is shifted in every cycle
											// P(i+1') = (P(i) + X(i)Y2^(temp))/2
	
	always @ (posedge clk or posedge rst) begin // Always loop, which is accesed at every positive edge of clock or reset
		
		if(rst) begin				// Asyncronous Reset
			store_a <= 0;
			store_b <=0;
			cntr = 0;
			product <= 0;
		end

		else if(load) begin			// load the inputs a and b into store_a and store_b respectively
			store_a <= a;
			store_b <= b;
			cntr = 0;
			product <= 0;
		end
			
		else if(cntr < 6) begin		// Checking condition, this has to be entered only 6 times
		
			if( store_a[0])			// When first bit of store_a is one then P(i+1) = (P(i) + X(i)*store_b*2^temp)/2
				temp = store_b << 6;
				
			else
				temp = 0;				// else P(i+1) = P(i)/2			
			product <= (product + temp) >> 1;  // P(i+1) = (P(i) + X(i)*store_b*2^n)/2
			store_a <= store_a >> 1;				// shifting store_a to right by one bit equivalent to going to next bit of store_a
			cntr = cntr + 1;							// incrementing counter
		end
	end
endmodule
