`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:08:33 11/05/2019 
// Design Name: 
// Module Name:    ALU_imm_unit 
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
module ALU_imm_unit(
		input [31:0] inp1, // Input 1
		input [15:0] inp2, // Input 2
		input [1:0] func, // Operation
		input ena, // Enable
		output reg [31:0] res1, // result
		output reg carryFlag, // Flags
		output reg signFlag,
		output reg overflowFlag,
		output reg zeroFlag
    );

	reg te;
	reg signed [31:0] temp;
	
	always @(posedge ena) begin
		// Different operations and flag assignation
		case(func) 
		
			// Add Immediate
			6'd0: begin
						// Sign Extension
						temp = inp2[15]? {16'b1111111111111111,inp2} : {16'b0,inp2};
						{te, res1} = inp1 + temp;
						zeroFlag = (res1 == 0);
						signFlag = res1[31];
						carryFlag = te;
						overflowFlag = ((inp1[31] == temp[31]) && (res1[31] != inp1[31]));
					end
			
			// 2's Complement Immediate
			6'd1: begin
						// Sign Extension
						temp = inp2[15]? {16'b1111111111111111,inp2} : {16'b0,inp2};
						res1 = -temp;
						overflowFlag = 0;
						zeroFlag = (res1 == 0);
						signFlag = res1[31];
						carryFlag = 0;
					end
		endcase
	end
endmodule