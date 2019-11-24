`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:43 11/11/2019 
// Design Name: 
// Module Name:    hardware_router 
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

// NAME : KOUSSHIK RAJ
// ROLL NO. : 17CS30022 

// Module for buffer A
module buffer( 
			input clk, // The clock variable
			input rst, // The reset variable 
			input [42:0] buffer_in, // The input for the buffer
			output [42:0] buffer_out // The output for the buffer
		);
		
		reg [42:0] buff[3:0]; // The buffer storage

		assign buffer_out = buff[0]; // Always the first position will be transferred out
		
		// Assign the initial values
		initial begin
			buff[0] = 43'd0;
			buff[1] = 43'd0;
			buff[2] = 43'd0;
			buff[3] = 43'd0;
		end
		
		always @(posedge clk) begin
		
			// If rst is pressed flush the buffer
			if(rst) begin
				buff[0] = 43'd0;
				buff[1] = 43'd0;
				buff[2] = 43'd0;
				buff[3] = 43'd0;
			end
			
			// If not reset perform the operation
			else begin
				// Add the data to the buffer
				buff[0] = buffer_in;
			end
			
		end
		
endmodule

module router(
			input [42:0] data_in,
			input clk,
			input rst,
			output [42:0] channel_1,
			output [42:0] channel_2,
			output [42:0] channel_3,
			output [42:0] channel_4,
			output reg ready
		);

	// The data input for the different buffers
	reg [42:0] data_in_A, data_in_B, data_in_C, data_in_D, data, drop[7:0];
	reg drop_flag;
	// register for copy count
	reg [2:0] count;
	
	// Assign the initial values
	initial begin
		ready = 1; // Initially the router is ready
		
		// Initial inputs are dummy packets
		data_in_A = 43'd0;
		data_in_B = 43'd0;
		data_in_C = 43'd0;
		data_in_D = 43'd0;
		
		drop_flag = 0;
		count = 0;
	end

	// Initialize the 4 buffer modules
	buffer A(clk,rst,data_in_A,channel_1);
	buffer B(clk,rst,data_in_B,channel_2);
	buffer C(clk,rst,data_in_C,channel_3);
	buffer D(clk,rst,data_in_D,channel_4);

	always @(posedge clk) begin
		
		$display("MAIN: %b", data_in);
		
		if(rst) begin
			ready = 1;
			data_in_A = 43'd0;
			data_in_B = 43'd0;
			data_in_C = 43'd0;
			data_in_D = 43'd0;
			count = 0;
			drop_flag = 0;
		end
		
		else begin
		
			if(ready) begin
				data = data_in;
				ready = 0;
				count = data_in[42:40];
				data_in_A = 43'd0;
				data_in_B = 43'd0;
				data_in_C = 43'd0;
				data_in_D = 43'd0;
				if(count == 0)
					drop_flag = 1;
			end
			
			if( count == 0) begin
				// Drop History Update
			end
			
			else if( count == 0)
			
			if( count > 0 ) begin
				case(data[39:24])
					{8'd188,8'd39}:begin
											data_in_D = data;
										end
					{8'd170,8'd153}:begin
											data_in_B = data;
										end
					{8'd83,8'd168}:begin
											data_in_A = data;
										end
					{8'd104,8'd148}:begin
											data_in_C = data;
										end
				endcase
				count = count - 1;
			end
			
			if( count == 0 )
				ready = 1;
			
		end
	end
	 
endmodule
