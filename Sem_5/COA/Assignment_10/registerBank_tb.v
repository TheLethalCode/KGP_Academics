`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:14:43 11/05/2019
// Design Name:   registerBank
// Module Name:   D:/assgn_9/RISC/registerBank_tb.v
// Project Name:  RISC
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: registerBank
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module registerBank_tb;

	// Inputs
	reg clk;
	reg write;
	reg [4:0] wrAddr;
	reg [31:0] wrData;
	reg [4:0] rdAddrA;
	reg [4:0] rdAddrB;

	// Outputs
	wire [31:0] rdDataA;
	wire [31:0] rdDataB;
	wire [31:0] flagReg;
	wire [31:0] raReg;

	// Instantiate the Unit Under Test (UUT)
	registerBank uut (
		.clk(clk), 
		.write(write), 
		.wrAddr(wrAddr), 
		.wrData(wrData), 
		.rdAddrA(rdAddrA), 
		.rdDataA(rdDataA), 
		.rdAddrB(rdAddrB), 
		.rdDataB(rdDataB), 
		.flagReg(flagReg), 
		.raReg(raReg)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		write = 0;
		wrAddr = 0;
		wrData = 0;
		rdAddrA = 0;
		rdAddrB = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		$monitor($time,"\tclk = %b,\trdAddr1 = %d,\treadData1 = %d,\trdAddr2 = %d,\treadData2 = %d,\tflagReg = %b,\traReg = %d",clk,rdAddrA,rdDataA,rdAddrB,rdDataB,flagReg,raReg);
		#3 write = 1; wrAddr = 22; wrData = 32'b1101;
		#10 wrAddr = 8; wrData = 221;
		#10 wrAddr = 4; wrData = 404;
		#10 wrAddr = 12; wrData = 12012;
		#10 wrAddr = 23; wrData = 23023;
		#10 wrAddr = 30; wrData = 30030;
		#10 write = 0;
		#5 rdAddrA = 8; rdAddrB = 22;
		#5 rdAddrA = 4; rdAddrB = 12;
		#5 rdAddrA = 23; rdAddrB = 30;
		#5 write = 1;  wrAddr = 22; wrData = 32'b10;
		#10  write = 1;  wrAddr = 8; wrData = 808;
		#10 $finish;
		
	end
	
	always #5 clk = !clk;
endmodule

