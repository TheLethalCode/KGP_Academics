`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:57 11/05/2019 
// Design Name: 
// Module Name:    registerBank 
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
module registerBank(
		input clk,								// Clock
		input write,							// To decide if we need to write or not
		input [4:0] wrAddr,					// Write address
		input [31:0] wrData,       		//	Write data
		input [4:0] rdAddrA,       		//	Read Addresses and Read Data
		input [4:0] rdAddrB,
		output reg [31:0] rdDataA,
		output reg [31:0] rdDataB,
		output [31:0] flagReg,				// Flag Register
		output [31:0] raReg					// RA Reg
    );

	// 32 registers of 32 bits
	reg [31:0] r[31:0];
	
	// Initialise with 0
	initial begin
		r[0]=32'b0;	r[8]=32'b0;		r[16]=32'b0;	r[24]=32'b0;	
		r[1]=32'b0; r[9]=32'b0;		r[17]=32'b0;	r[25]=32'b0;	
		r[2]=32'b0; r[10]=32'b0;	r[18]=32'b0;	r[26]=32'b0;	
		r[3]=32'b0; r[11]=32'b0;	r[19]=32'b0;	r[27]=32'b0;	
		r[4]=32'b0; r[12]=32'b0;	r[20]=32'b0;	r[28]=32'b0;	
		r[5]=32'b0; r[13]=32'b0;	r[21]=32'b0;	r[29]=32'b0;	
		r[6]=32'b0; r[14]=32'b0;	r[22]=32'b0;	r[30]=32'b0;	
		r[7]=32'b0; r[15]=32'b0;	r[23]=32'b0;	r[31]=32'b0;
	end
	
	// Reading the flag registers
	assign flagReg = r[22];
	
	// Reading the RA registers
	assign raReg = r[8];
	
	always @(clk or rdAddrA or rdAddrB) begin
	
		// Reading data in reg A
		if( rdAddrA >= 32)
			rdDataA = 32'hffffffff;
		else
			rdDataA = r[rdAddrA];
		
		// Reading data in reg B
		if( rdAddrB >= 32)
			rdDataB = 32'hffffffff;
		else
			rdDataB = r[rdAddrB];

	end
	
	// Writing in register if enabled
	always @(posedge clk) begin
		if(write)
			r[wrAddr] = wrData;
	end
endmodule
