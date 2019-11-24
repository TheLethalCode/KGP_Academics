`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:44 11/05/2019 
// Design Name: 
// Module Name:    jump_unit 
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
module jump_unit(
		input [21:0] addr, // Jump Address
		input [3:0] func,  // type of jump
		input carryFlag, // Different flags
		input signFlag,
		input overflowFlag,
		input zeroFlag,
		input [31:0] raReg, // Old RA
		input [31:0] PC, // Old PC
		input ena, // Enable
		output reg [31:0] PC_new, // New PC
		output reg [31:0] ra_new // New RA
    );

	always @(posedge ena) begin
		
		// New Ra reg is the same as the old unless changed
		ra_new = raReg;
				
		case(func)
		
			// Call function
			4'd0:begin
						PC_new = {10'b0,addr};
						ra_new = PC + 1;
					end
					
			// Branch on No Overflow
			4'd1:begin
						if(overflowFlag == 0)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
					
			// Branch on Overflow
			4'd2:begin
						if(overflowFlag == 1)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
					
			// Branch on Not Sign
			4'd3:begin
						if(signFlag == 0)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
			
			// Branch on Sign
			4'd4:begin
						if(signFlag == 1)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
					
			// Branch on No Carry
			4'd5:begin
						if(carryFlag == 0)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
			
			// Branch on Carry
			4'd6:begin
						if(carryFlag == 1)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
					
			// Branch on Not Zero
			4'd7:begin
						if(zeroFlag == 0)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
			
			// Branch on Zero
			4'd8:begin
						if(zeroFlag == 1)
							PC_new = {10'b0,addr};
						else
							PC_new = PC+1;
					end
			
			// Unconditional Branch
			4'd9:begin
						PC_new = {10'b0,addr};
					end
					
			// Return
			4'd10:begin
						PC_new = raReg;
					end
		
		endcase
	end
endmodule

