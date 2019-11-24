`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:12:08 09/28/2019 
// Design Name: 
// Module Name:    floating_point_adder 
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

// Assignment :- 9
// Group :- 61
// Problem :- 1

module exponent_diff(
		input clk,
		input rst,
		input [31:0] a,
		input [31:0] b,
		output reg sign_a,
		output reg sign_b,
		output reg [26:0] sgnfcnd_a,
		output reg [26:0] sgnfcnd_b,
		output reg [7:0] exp
		);
		
		reg [31:0] inp_a,inp_b,temp;
		reg [7:0] exp_diff;
		
		always @(posedge clk) begin
			
			// Copying inputs
			inp_a = a;
			inp_b = b;
			
			// If rst is pressed, initialise everything
			if(rst) begin
				sign_a = 0;
				sign_b = 0;
				sgnfcnd_a = 27'b0;
				sgnfcnd_b = 27'b0;
				exp = 8'b0;
			end 
			
			else begin
			
				// Shifting the greater number to a
				if(inp_a[30:0] < inp_b[30:0]) begin
					temp = inp_a;
					inp_a = inp_b;
					inp_b = temp;
				end
				
				// Exponents of a and b and exponent difference
				exp_diff = inp_a[30:23] - inp_b[30:23];
				exp = inp_a[30:23];
				
				// Calculating significands of a and b with 3 extra figures
				sgnfcnd_a = (inp_a == 0)?0:{1'b1,inp_a[22:0],3'b0};
				sgnfcnd_b = (inp_b == 0)?0:{1'b1,inp_b[22:0],3'b0};
				sgnfcnd_b = sgnfcnd_b >> exp_diff;
				
				// Signs
				sign_a = inp_a[31];
				sign_b = inp_b[31];
			end // rst else end
		end // always end
endmodule

// Add the extracted significands according to the signs
module add(
			input clk,
			input rst,
			input sign_a_in,
			input sign_b_in,
			input [26:0] sgnfcnd_a_in,
			input [26:0] sgnfcnd_b_in,
			input [7:0] exp_in,
			output reg [27:0] sum,
			output reg sign,
			output reg [7:0] expOut
		);
		
		reg sign_a, sign_b;
		reg [26:0] sgnfcnd_a, sgnfcnd_b;
		reg [7:0] exp;
		
		always @(posedge clk) begin
		
			// Copying the inputs
			sign_a = sign_a_in;
			sign_b = sign_b_in;
			sgnfcnd_a = sgnfcnd_a_in;
			sgnfcnd_b = sgnfcnd_b_in;
			exp = exp_in;
 		
			// If rst is pressed, initialise everything
			if(rst) begin
				sum = 28'b0;
				sign = 0;
				expOut = 0;
			end
			
			else begin
			
				// Add if the signs are same
				if( sign_a == sign_b) 
					sum = sgnfcnd_a + sgnfcnd_b;
					
				// Else subtract
				else 
					sum = sgnfcnd_a - sgnfcnd_b;

				sign = sign_a; // The sign is the same as the sign of the bigger number
				expOut = exp;
				
			end // rst else end
		end // always end
endmodule

// Calculate the final value including extra figures
module normalize(
		input clk,
		input rst,
		input [27:0] sum_in,
		input [7:0] exp_in,
		input sign_in,
		output reg [35:0] final
	);
	
	reg [4:0] cnt;
	reg [27:0] temp_sum, sum;
	reg [7:0] exp;
	reg sign;
	
	always @(posedge clk) begin
		
		// Copying the inputs
		sum = sum_in;
		exp = exp_in;
		sign = sign_in;
		
		if(rst) begin
			final = 36'b0;
		end
		
		else begin
			temp_sum = sum;
			
			// If the answer is 0
			if( sum == 0) 
				final = 36'b0;
			
			// If the answer is overflow
			else if( (sum[27] == 1) && (exp == 255))
				final = {sign,8'b11111111,27'b0};
			
			// Find the index of first 1 from left and change the exp accordingly
			else begin
				for(cnt=27; sum[cnt] != 1; cnt = cnt - 1 )
					temp_sum = temp_sum << 1;
				
				// If not underflow, assign the final number with extra figures
				if(exp + cnt >= 8'b00011010) begin
					final = {sign, (exp + cnt) - 8'd26 , 27'b0};
					final = final + temp_sum[26:0];
				end
				
				// If underflow
				else 
					final = 36'b0;
			end // inside else end
		end // rst else end
	end // always end
endmodule

module round(
		input clk,
		input rst,
		input [35:0] pre_ans_in,
		output reg [31:0] ans
	);
	
	reg [35:0] pre_ans;
	
	always @(posedge clk) begin
	
		// Copying the inputs
		pre_ans = pre_ans_in;
	
		if(rst) begin
			ans = 32'b0;
		end
	
		else begin
		
			// If it is midway between the 2 numbers, round up to nearest even
			if(pre_ans[3:0] == 8)
				ans = {pre_ans[35:5],1'b1};
				
			// If less than midway, keep it as it is
			else if(pre_ans[3:0] > 8)
				ans = pre_ans[35:4] + 1;
			
			// ELse, use the greater number
			else
				ans = pre_ans[35:4];
		end // rst else end 
	end // always end
	
endmodule

module floating_point_adder(
		input clk,
		input rst,
		input [31:0] a,
		input [31:0] b,
		output [31:0] ans,
		output [7:0] exp1
    );
	
	
	// For the modules
	
	 // Module exp_diff
	 wire sign_a, sign_b;
	 wire [26:0] sgnfcnd_a, sgnfcnd_b;
	 wire [7:0] exp;
	 
	 // Module add

	 wire sign;
	 wire [27:0] sum;
	 
	 // Module normalize
	 wire [35:0] final;
	 
	 exponent_diff Z1(clk, rst, a, b, sign_a, sign_b, sgnfcnd_a, sgnfcnd_b, exp);
	 add Z2(clk, rst, sign_a, sign_b, sgnfcnd_a, sgnfcnd_b, exp, sum, sign, exp1);
	 normalize Z3(clk, rst, sum, exp1, sign, final);
	 round Z4(clk, rst, final, ans);
	 
endmodule
