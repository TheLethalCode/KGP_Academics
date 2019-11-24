`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:27:07 11/06/2019 
// Design Name: 
// Module Name:    hybrid_adder 
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
module hybrid_adder(
		input [31:0] a,
		input [31:0] b,
		input cin,
		output [31:0] sum,
		output cout
    );
	
    wire temp;
	
	// Combination of 8 carry_lookahead adders
    lookahead_adder a1(a[3:0],b[3:0],cin,sum[3:0],temp1);
    lookahead_adder a2(a[7:4],b[7:4],temp1,sum[7:4],temp2);
	 lookahead_adder a3(a[11:8],b[11:8],temp2,sum[11:8],temp3);
    lookahead_adder a4(a[15:12],b[15:12],temp3,sum[15:12],temp4);
    lookahead_adder a5(a[19:16],b[19:16],temp4,sum[19:16],temp5);
    lookahead_adder a6(a[23:20],b[23:20],temp5,sum[23:20],temp6);
	 lookahead_adder a7(a[27:24],b[27:24],temp6,sum[27:24],temp7);
    lookahead_adder a8(a[31:28],b[31:28],temp7,sum[31:28],cout);

endmodule