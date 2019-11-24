`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:33:53 11/11/2019
// Design Name:   router
// Module Name:   C:/Users/student/Desktop/coaLAB/FPGA/lab_test2_17cs30022/router_tb.v
// Project Name:  lab_test2_17cs30022
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: router
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

// NAME : KOUSSHIK RAJ
// ROLL NO. : 17CS30022 

module router_tb;

	// Inputs
	reg [42:0] data_in;
	reg clk;
	reg rst;

	// Outputs
	wire [42:0] channel_1;
	wire [42:0] channel_2;
	wire [42:0] channel_3;
	wire [42:0] channel_4;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	router uut (
		.data_in(data_in), 
		.clk(clk), 
		.rst(rst), 
		.channel_1(channel_1), 
		.channel_2(channel_2), 
		.channel_3(channel_3), 
		.channel_4(channel_4), 
		.ready(ready)
	);

	reg [42:0] input_buffer[19:0];
	reg [4:0] cntr;
	
	initial begin
		
		// Initialize Inputs
		data_in = 0;
		clk = 0;
		rst = 0;
		cntr = 0;
		
		// Initialize Input buffer
		input_buffer[0] = {3'd2, 8'd170, 8'd153, 8'd26, 8'd104, 8'd1};
		input_buffer[1] = {3'd4, 8'd170, 8'd153, 8'd127, 8'd218, 8'd2};
		input_buffer[2] = {3'd2, 8'd83, 8'd168, 8'd234, 8'd22, 8'd3};
		input_buffer[3] = {3'd2, 8'd104, 8'd148, 8'd200, 8'd16, 8'd4};
		input_buffer[4] = {3'd1, 8'd83, 8'd168, 8'd252, 8'd74, 8'd5};
		input_buffer[5] = {3'd2, 8'd188, 8'd39, 8'd221, 8'd216, 8'd6};
		input_buffer[6] = {3'd4, 8'd104, 8'd148, 8'd115, 8'd57, 8'd7};
		input_buffer[7] = {3'd3, 8'd170, 8'd153, 8'd78, 8'd224, 8'd8};
		input_buffer[8] = {3'd4, 8'd188, 8'd39, 8'd3, 8'd195, 8'd9};
		input_buffer[9] = {3'd3, 8'd83, 8'd168, 8'd164, 8'd223, 8'd10};
		input_buffer[10] = {3'd3, 8'd104, 8'd148, 8'd202, 8'd212, 8'd11};
		input_buffer[11] = {3'd2, 8'd83, 8'd168, 8'd90, 8'd183, 8'd12};
		input_buffer[12] = {3'd0, 8'd83, 8'd168, 8'd159, 8'd92, 8'd13};
		input_buffer[13] = {3'd1, 8'd104, 8'd148, 8'd19, 8'd46, 8'd14};
		input_buffer[14] = {3'd1, 8'd188, 8'd39, 8'd150, 8'd38, 8'd15};
		input_buffer[15] = {3'd0, 8'd170, 8'd153, 8'd75, 8'd98, 8'd16};
		input_buffer[16] = {3'd4, 8'd170, 8'd153, 8'd12, 8'd220, 8'd17};
		input_buffer[17] = {3'd0, 8'd170, 8'd153, 8'd59, 8'd168, 8'd18};
		input_buffer[18] = {3'd4, 8'd83, 8'd168, 8'd1, 8'd82, 8'd19};
		input_buffer[19] = {3'd0, 8'd104, 8'd148, 8'd23, 8'd173, 8'd20};
				
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
   
	always 
		#5 clk = !clk;
	
	always @(negedge clk) begin
		if( (ready) && (cntr < 20) ) begin
			data_in = input_buffer[cntr];
			cntr = cntr + 1;
		end
		
		if( cntr >= 20 )
			$finish;
	end
	
endmodule

