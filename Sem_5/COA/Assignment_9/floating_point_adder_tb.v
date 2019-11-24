`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:15:43 09/29/2019
// Design Name:   floating_point_adder
// Module Name:   D:/assgn_9/floating_point_adder/floating_point_adder_tb.v
// Project Name:  floating_point_adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: floating_point_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

// Assignment :- 9
// Group :- 61
// Problem :- 1

module floating_point_adder_tb;

	// Inputs
	reg [31:0] a;
	reg [31:0] b;
	reg rst;
	reg clk;

	// Outputs
	
	wire [31:0] ans;
	
	// Modifications
	reg [4:0] cnt;
	
	// Instantiate the Unit Under Test (UUT)
	floating_point_adder uut (
		.a(a), 
		.b(b), 
		.rst(rst), 
		.clk(clk),
		.ans(ans)
	);

	initial begin
	
		// Initialize Inputs
		a = 0;
		b = 0;
		rst = 1;
		clk = 0;
		cnt = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		// Wait for 5ns and change the input before positive clock edge ( a = 3.25, b = 4.3125)
		#5 rst = 0; a = 32'b01000000010100000000000000000000; b = 32'b01000000100010100000000000000000;
		$display($time, "\tINPUT \ta = %b, \tb = %b, \tClock cycle = %d",a,b,cnt);
		
		// Wait for one complete cycle and then change input ( a = 2, b = 2)
		#20 rst = 0; a = 32'b01000000000000000000000000000000; b = 32'b01000000000000000000000000000000;
		$display($time, "\tINPUT \ta = %b, \tb = %b, \tClock cycle = %d",a,b,cnt);
		
		// Wait for one complete cycle and then change input ( a = 3.25, b = -4.3125)
		#20 rst = 0; a = 32'b01000000010100000000000000000000; b = 32'b11000000100010100000000000000000;
		$display($time, "\tINPUT \ta = %b, \tb = %b, \tClock cycle = %d",a,b,cnt);
		
		// Wait for one complete cycle and then change input ( a = 3.25, b = -3.25)
		#20 rst = 0; a = 32'b01000000010100000000000000000000; b = 32'b11000000010100000000000000000000;
		$display($time, "\tINPUT \ta = %b, \tb = %b, \tClock cycle = %d",a,b,cnt);
		
		// At every clock cycle display the output for the input given 4 cycles before it
		#20 $display("\n",$time, "\tAnswer for a = 01000000010100000000000000000000, \tb = 01000000100010100000000000000000 \tis \tANSWER = %b \tClock cycle = %d",ans,cnt);
		#20 $display($time, "\tAnswer for a = 01000000000000000000000000000000, \tb = 01000000000000000000000000000000 \tis \tANSWER = %b \tClock cycle = %d",ans,cnt);
		#20 $display($time, "\tAnswer for a = 01000000010100000000000000000000, \tb = 11000000100010100000000000000000 \tis \tANSWER = %b \tClock cycle = %d",ans,cnt);
		#20 $display($time, "\tAnswer for a = 01000000010100000000000000000000, \tb = 11000000010100000000000000000000 \tis \tANSWER = %b \tClock cycle = %d",ans,cnt);
		#2 $finish;
	end 
   
	// Clock of period 20 ns
	always begin
		#10 clk = !clk;
		if( clk == 0 ) 
			cnt = cnt + 1;
	end
endmodule

