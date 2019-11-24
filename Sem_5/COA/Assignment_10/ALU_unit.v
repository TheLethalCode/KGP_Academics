`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:28 11/05/2019 
// Design Name: 
// Module Name:    ALU_unit 
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
module ALU_unit(
		input [31:0] inp1, // Input 1
		input [31:0] inp2, // Input 2
		input [4:0] shAmt, // Shift Amount
		input [5:0] func, // Operation
		input ena, // Enable
		output reg [31:0] res1, // Result 1
		output reg [31:0] res2, // Result 2
		output reg carryFlag,  // Flags
		output reg signFlag,
		output reg overflowFlag,
		output reg zeroFlag
    );

	reg te,dir;
	reg signed [31:0] temp1, temp2;
	
	wire [31:0] sum,Sout;
	wire [63:0] Pout;
	wire cout;
	
	// Calling Hybrid adder
	hybrid_adder add(inp1, inp2, 1'b0, sum, cout);
	
	// Calling barrel shifter for shift operations
	barrel_shifter shift(inp1, shAmt, dir, Sout);
	
	// Array multiplier for unsigned multiplication of 32 bit inputs
	array_multiplier dame(inp1, inp2, Pout);
	
	always @(posedge ena) begin
		// Make res2 0 
		res2 = 32'd0;
		
		// Different operations and Flag Assigning
		case(func) 
		
			// Add
			6'd0: begin
						{te,res1} = inp1 + inp2;
						zeroFlag = (res1 == 0);
						signFlag = res1[31];
						carryFlag = te;
						overflowFlag = ((inp1[31] == inp2[31]) && (res1[31] != inp1[31]));
					end
			
			// Multiply Unsigned
			6'd1: begin
						{res1, res2} = inp1 * inp2;
						overflowFlag = 0;
						zeroFlag = (res1 == 0) && (res2 == 0);
						signFlag = 0;
						carryFlag = 0;
					end
			
			// Multiply signed
			6'd2: begin
						temp1 = inp1; temp2 = inp2;
						{res1, res2} = temp1 * temp2;
						overflowFlag = 0;
						zeroFlag = (res1 == 0) && (res2 == 0);
						signFlag = inp1[31] ^ inp2[31];
						carryFlag = 0;
					end
			
			// 2's Complement
			6'd3: begin
						res1 = -inp1;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
			
			// Bitwise And
			6'd4: begin
						res1 = inp1&inp2;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
			
			// Bitwise Xor
			6'd5: begin
						res1 = inp1^inp2;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
					
			// Shift left logical
			6'd6: begin
						res1 = inp1 << shAmt;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
					
			// Shift right logical
			6'd7: begin
						res1 = inp1 >> shAmt;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end

			// Shift left logical variable
			6'd8: begin
						res1 = inp1 << inp2;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
					
			// Shift right logical variable
			6'd9: begin
						res1 = inp1 >> inp2;
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
					
			// Shift right arithmetic
			6'd10: begin
						temp1 = inp1;
						res1 = temp1 >>> shAmt;
						//res1[31] = inp1[31];
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
					
			// Shift right arithmetic variable
			6'd11: begin
						temp1 = inp1;
						res1 = temp1 >>> inp2;
						//res1[31] = inp1[31];
						signFlag = res1[31];
						zeroFlag = (res1 == 0);
						carryFlag = 0;
						overflowFlag = 0;
					end
		endcase
	end

endmodule
