`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:52 11/06/2019 
// Design Name: 
// Module Name:    array_multiplier 
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
module array_multiplier(
		input [31:0] inp1, 
		input [31:0] inp2, 
		output reg [63:0] y
		);

	parameter width = 32;

	wire [63:0] a,b;
	wire [2*width*width-1:0] partials;
	wire [63:0] y1;

	assign a = inp1;
	assign b = inp2;

	barrel_shifter bs(b,i,1,y1);

	genvar i;
	assign partials[2*width-1 : 0] = a[0] ? b : 0;
	
	generate for (i = 1; i < width; i = i+1) 
	begin:gen
		assign partials[2*width*(i+1)-1 : 2*width*i] = (a[i] ? y1 : 0) +
                                   partials[2*width*i-1 : 2*width*(i-1)];
	end endgenerate

	assign y = partials[2*width*width-1 : 2*width*(width-1)];

endmodule
