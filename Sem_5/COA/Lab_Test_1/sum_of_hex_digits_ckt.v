`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:22 09/11/2019 
// Design Name: 
// Module Name:    sum_of_hex_digits_ckt 
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

//////////////////////////////////////////////////////////////////////////////////
// Name :- Kousshik Raj M
// Roll No. :- 17CS30022
//////////////////////////////////////////////////////////////////////////////////

module sum_of_hex_digits_ckt(
		input clk,
		input rst,
		input [31:0] num,
		output reg [6:0] sum_of_hex_digits
    );

	 reg [31:0] temp_num; // Register for storing the input number and acts as a shift register
	 reg [3:0] cntr; // Cntr keeping track of 8 clock cycles
	 
	// At every positive edge of the clock cycle or when reset is pressed
	always @(posedge clk or posedge rst) begin
		
		// If rst = 1, reset everything to trivial values
		if(rst) begin
			sum_of_hex_digits <= 0;
			temp_num <= num;
			cntr = 0;
		end
		
		// else if the cntr is less than 8 clock cycles, calculate the sum of digits
		else if(cntr < 8) begin
			sum_of_hex_digits <=  sum_of_hex_digits + temp_num[3:0]; // Calculate the sum of current hex digit
			temp_num <= temp_num >> 4; // read in 4 new bits of the input
			cntr = cntr + 1; // increase the cntr
		end
	end
endmodule
