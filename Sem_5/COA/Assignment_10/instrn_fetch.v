`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:19 11/05/2019 
// Design Name: 
// Module Name:    instrn_fetch_decode 
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
module instrn_fetch(
		input clk,
		input rst,
    );

	wire [31:0] PC, PC_old;
	reg [31:0] cycle, instrn_pass, PC_temp;
	wire [31:0] instrn;
	 
	assign PC_old = PC_temp;
	
	initial begin
		cycle = 0;
		instrn_pass = {6'b111111,26'b0}; // No Operation Code
		PC_temp = 0;
	end
	  
	// Fetching the instrunctions
	BRAM_module fetch(clk, 1'b0, PC_old[10:0], 0, instrn);
	 
	// Passing it to decode 
	instrn_decode decode(clk,instrn_pass,PC_old,PC);
	  
	always @(clk) begin
		// $display($time,"\tIN FETCH (%d): PC = %d, instrn = %b",cycle, PC_old, instrn_pass);
		
		// Calculate the number of half cycles passes
		cycle = cycle + 1;

		// Assign PC if it is less than 2048 becuase that is the maximum possiblea address
		if( PC < 2048)
			PC_temp = PC;
			
		// To prevent calls before starting
		if( cycle > 6 )
			instrn_pass = instrn;
		
	end
	 
endmodule
