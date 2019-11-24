`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:12 11/05/2019 
// Design Name: 
// Module Name:    control_unit 
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
module control_unit(
		input clk,
		input [5:0] opCode,
		input [25:0]  data,
		input [31:0] PC_old,
		output reg [31:0] PC
    );

	// Enable Variables
	reg alu_ena, alu_imm_ena, load_store_ena, jump_ena, reg_read_ena, reg_write_ena;
	
	////////////////////////////////// REGISTER BANK ///////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////
	
	// Writing Variables
	reg [31:0] writeData; // Result Registers
	reg [31:0] flagRegWrite; // Flag write registers
	reg [4:0] writeAddr; // Write Address
	
	// Reading Variables
	wire [31:0] readData1, readData2, flagReg, raReg; // Reading Data and Flag registers

	// Register Bank module
	registerBank M0(clk, reg_write_ena, writeAddr, writeData, data[25:21], data[20:16], readData1, readData2, flagReg, raReg);

	////////////////////////////////// ALU //////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	// Input variables
	reg [31:0] ALU_inp1, ALU_inp2;
	reg [4:0] ALU_shAmt;
	reg [5:0] ALU_func;
	
	// Output Variables
	wire [31:0] ALU_res1, ALU_res2;
	wire ALU_carryFlag, ALU_signFlag, ALU_overflowFlag, ALU_zeroFlag;
	
	// Flag
	reg [2:0] ALU_flag;
	
	// ALU module
	ALU_unit M1(ALU_inp1, ALU_inp2, ALU_shAmt, ALU_func, alu_ena, ALU_res1, ALU_res2, ALU_carryFlag, ALU_signFlag, ALU_overflowFlag, ALU_zeroFlag);
	
	////////////////////////////////// ALU Immediate ///////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	// Input variables
	reg [31:0] ALU_imm_inp1;
	reg [15:0] ALU_imm_inp2;
	reg [1:0] ALU_imm_func;
	
	// Output Variables
	wire [31:0] ALU_imm_res;
	wire ALU_imm_carryFlag, ALU_imm_signFlag, ALU_imm_overflowFlag, ALU_imm_zeroFlag;
	
	// Flag
	reg [1:0] ALU_imm_flag;
	
	ALU_imm_unit M2(ALU_imm_inp1, ALU_imm_inp2, ALU_imm_func, alu_imm_ena, ALU_imm_res, ALU_imm_carryFlag, ALU_imm_signFlag, ALU_imm_overflowFlag, ALU_imm_zeroFlag);
	
	////////////////////////////////// LOAD STORE ///////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	// Defining the variables
	reg mem_write_ena;
	reg [10:0] mem_addr;
	reg [31:0] mem_data_in, mem_temp;
	wire [31:0] mem_data_out;
	reg [1:0] mem_func, mem_flag;
	
	// Calling the BRAM module
	BRAM_module M3(clk, mem_write_ena, mem_addr, mem_data_in, mem_data_out);
	
	////////////////////////////////// Branching ///////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	reg [3:0] jump_func;
	reg [21:0] jump_addr;
	reg [1:0] jump_flag;
	reg jump_carryFlag, jump_signFlag, jump_overflowFlag, jump_zeroFlag;
	
	// PC and $ra
	reg [31:0] jump_ra, jump_PC;
	wire [31:0] jump_ra_write, PC_temp;
		
	// Calling the jumping module
   jump_unit M4(jump_addr, jump_func, jump_carryFlag, jump_signFlag, jump_overflowFlag, jump_zeroFlag, jump_ra, jump_PC, jump_ena, PC_temp, jump_ra_write);                              	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////// Processing Instruntion //////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	initial begin
	
		// Disable all operations initially
		alu_ena = 0; alu_imm_ena = 0; load_store_ena = 0;
		jump_ena = 0; reg_read_ena = 0; reg_write_ena = 0;
		mem_write_ena = 0;
		
		// Start initial flag as 0
		ALU_flag = 0; ALU_imm_flag = 0; jump_flag = 0; mem_flag=0;
		
	end
	
	always @(posedge clk) begin
		
		// $display("Clock Cycle Start: opCode: %d",opCode);
		
		// Read untill encountering finishing instrn
		if(opCode != 6'b111111) begin
			
			// ALU unit
			if(opCode == 0) begin
				
				// $display("\tIn ALU unit");
				// Perform the ALU operation by assigning the inputs and increase the flag
				if(ALU_flag == 0) begin
					
					// Make the write flags 0
					reg_write_ena = 0;
					mem_write_ena = 0;
					
					// $display("\t\tFLAG 0");
					// Call ALU
					ALU_inp1 = readData1;
					ALU_inp2 = readData2;
					ALU_shAmt = data[15:11];
					ALU_func = data[10:5];
					alu_ena = 1;
					ALU_flag = ALU_flag + 1;
					// $display("\t\tINPUTS: inp1 =%2d, inp2 =%2d, func =%2d",ALU_inp1, ALU_inp2, ALU_func);

				end
				
				// Write the first part of result
				else if(ALU_flag == 1) begin
					// $display("\t\tFLAG 1");
					alu_ena = 0;
					ALU_flag = ALU_flag + 1;
					
					// If not multiplication, write the result
					if( (ALU_func != 1) && (ALU_func != 2)) begin
						writeAddr = data[25:21];
						writeData = ALU_res1;
						reg_write_ena = 1;
					end
					
					// If multiplication, assign res1 in reg 19
					else begin
						writeAddr = 5'd19;  // mflo
						writeData = ALU_res1;
						reg_write_ena = 1;
					end 
					// $display("\t\tOUTPUTS: Waddr =%2d, WData =%2d",writeAddr, writeData);
				end
				
				// Write the 2nd part of result
				else if(ALU_flag == 2) begin
					// $display("\t\tFLAG 2");
					alu_ena = 0;
					ALU_flag = ALU_flag + 1;
					
					// If multiplication, assign res2 to reg 20
					if( (ALU_func == 1) || (ALU_func == 2)) begin
						writeAddr = 5'd20;  // mfho
						writeData = ALU_res2;
						reg_write_ena = 1;
					end
					// $display("\t\tOUTPUTS: Waddr =%2d, Wdata =%2d",writeAddr, writeData);
					
				end
				
				// Write the flag registers
				else if(ALU_flag == 3) begin
					// $display("\t\tFLAG 3");
					alu_ena = 0;
					ALU_flag = ALU_flag + 1;
					
					// Assign the flags
					flagRegWrite[0] = ALU_carryFlag;
					flagRegWrite[1] = ALU_signFlag; 
					flagRegWrite[2] = ALU_overflowFlag; 
					flagRegWrite[3] = ALU_zeroFlag;
					flagRegWrite[31:4] = 0;
					 
					// Write the flag registers
					writeAddr = 5'd22;
					writeData = flagRegWrite;
					reg_write_ena = 1;
					// $display("\t\tOUTPUTS: Waddr =%2d, Wdata =%b",writeAddr, writeData);
					
					
					// Increase PC;
					PC = PC_old + 1;
					
				end
				
				// Waiting for reg write
				else begin
					// $display("\t\tFLAG 4");
					// $display("\t\tPC: %d",PC);
					ALU_flag = 0;
				end
			end
			
			// ALU immediate unit
			else if(opCode == 1) begin

				// $display("\tIn ALU imm");
				// Perform the ALU immediate operation by assigning the inputs and increase the flag
				if(ALU_imm_flag == 0) begin
				
					reg_write_ena = 0;
					mem_write_ena = 0;
				
					// $display("\t\tFLAG 0");
					
					// Call ALU immediate
					ALU_imm_inp1 = readData1;
					ALU_imm_inp2 = data[20:5];
					ALU_imm_func = data[4:3];
					alu_imm_ena = 1;
					ALU_imm_flag = ALU_imm_flag + 1;
					reg_write_ena = 0;
					// $display("\t\tINPUTS: inp1 =%2d, inp2 =%2d, func =%2d",ALU_imm_inp1,ALU_imm_inp2,ALU_imm_func);
				end
				
				// Write the result
				else if(ALU_imm_flag == 1) begin
					// $display("\t\tFLAG 1");
					alu_imm_ena = 0;
					ALU_imm_flag = ALU_imm_flag + 1;
					
					writeAddr = data[25:21];
					writeData = ALU_imm_res;
					reg_write_ena = 1; 
					
					// $display("\t\tOUTPUTS: Waddr =%d, WData =%d",writeAddr , writeData);
					
				end
				 
				// Write the flag registers
				else if(ALU_imm_flag == 2) begin
					// $display("\t\tFLAG 2");
					alu_imm_ena = 0;
					ALU_imm_flag = ALU_imm_flag + 1;
					
					// Assign the flags
					flagRegWrite[0] = ALU_imm_carryFlag;
					flagRegWrite[1] = ALU_imm_signFlag; 
					flagRegWrite[2] = ALU_imm_overflowFlag; 
					flagRegWrite[3] = ALU_imm_zeroFlag; 
					flagRegWrite[31:4] = 0;

					// Write the flag registers
					writeAddr = 5'd22;
					writeData = flagRegWrite;
					reg_write_ena = 1;
					
					// $display("\t\tOUTPUTS: Waddr =%d, WData =%d",writeAddr , writeData);
					
					// Increase PC;
					PC = PC_old + 1;
					
				end
				 
				// Wait for writing to finish
				else begin
					// $display("\t\tFLAG 3");
					// $display("\t\tPC: %d",PC);
					ALU_imm_flag = 0;
				end
			end
			
			// Load Store Unit
			else if(opCode == 2) begin
				
				// $display("\tIn Load Store Unit");
				
				// Check the function
				mem_func = data[1:0];
				
				// Store Word mem[val(rs) + offset] = val(rt)
				if((mem_func == 0) && (mem_flag == 0)) begin
				
					reg_write_ena = 0;
					mem_write_ena = 0;

					// $display("\t\tFLAG 0");
					// Writing in the BRAM Module
					mem_data_in = readData2;
					mem_write_ena = 1;
					mem_temp = readData1 + data[15:2];
					mem_addr = mem_temp[10:0];
					
					mem_flag = mem_flag + 1;
					reg_write_ena = 0;
					
					// $display("\t\tWriteAddr: %d, WriteData: %d", mem_addr, mem_data_in);
					
				end
				
				// Waiting for BRAM write
				else if((mem_func == 0) && (mem_flag == 1)) begin
					// $display("\t\tFLAG 1");
					mem_flag = mem_flag + 1;
					
					// Increase PC
					PC = PC_old + 1;
					// $display("\t\tIncreasing PC");
				end
				
				// Waiting for BRAM write
				else if((mem_func == 0) && (mem_flag == 2)) begin
					// $display("\t\tFLAG 2");
					mem_flag = 0;
					// $display("\t\tWaiting for BRAM write");
				end
				
				// Load Word val(rt) = mem[val(rs) + offset]
				// Read from memory
				else if((mem_func == 1) && (mem_flag == 0)) begin
					
					// $display("\t\tFLAG 0");					
					
					// Load from BRAM according to the address
					reg_write_ena = 0;				
					mem_write_ena = 0;
					mem_temp = readData1 + data[15:2];
					mem_addr = mem_temp[10:0];
					mem_flag = mem_flag + 1;

					// $display("\t\tReadAddr: %d, ReadData: %d", mem_addr, mem_data_out);
					
				end 
				
				// Waiting for BRAM Read
				else if((mem_func == 1) && (mem_flag == 1)) begin
					// $display("\t\tFLAG 1");
					mem_flag = mem_flag + 1;
					// $display("\t\tWaiting for BRAM Read");
				end
				
				// Write value into register
				else if((mem_func == 1) && (mem_flag == 2)) begin
					
					// $display("\t\tFLAG 2");
					
					mem_write_ena = 0;
					writeAddr = data[20:16];
					writeData = mem_data_out;
					reg_write_ena = 1;
					
					mem_flag = mem_flag + 1;
					
					// Increase PC
					PC = PC_old + 1;
					
					// $display("\t\tReadAddr: %d, ReadData: %d", mem_addr, mem_data_out);
				end
				
				// Wait for Reg Write
				else begin
					mem_flag = 0;
					// $display("\t\tFLAG 3");										
					// $display("\t\tWaiting for Reg Write");
				end
				
			end
			
			// Branching Unit
			else if(opCode == 3) begin
			
				// $display("\tIn Jump unit");
				
				if(jump_flag == 0) begin
				
					// Make write flags 0
					reg_write_ena = 0;
					mem_write_ena = 0;
				
					// $display("\t\tFLAG 0");
					
					// Assign the jump parameters properly
					jump_func = data[3:0];
					jump_addr = data[25:4];
					
					// Pass the flags
					jump_carryFlag = flagReg[0]; 
					jump_signFlag = flagReg[1];
					jump_overflowFlag = flagReg[2];
					jump_zeroFlag = flagReg[3];
					
					jump_ra = raReg;
					jump_PC = PC_old;
					
					jump_flag = jump_flag + 1;
					reg_write_ena = 0;
					
					
					// If it is not a branch on register instrunction
					if(jump_func != 11)
						jump_ena = 1;
					
					// $display("\t\tJumpAddr: %d, JumpFunc: %d, PC: %d", data[25:4], data[3:0], PC_old);
				end
				
				// Write the RA Reg
				else if( jump_flag == 1 ) begin
					// $display("\t\tFLAG 1");
					
					jump_ena = 0;
					jump_flag = jump_flag + 1;
					
					// If it is a branch on register instruction, assign PC from readData
					if(jump_func == 11) begin
						writeData = jump_ra;
						PC = readData1;
					end
					
					else begin
						writeData = jump_ra_write;
						PC = PC_temp;
					end
					
					// Write the Ra
					writeAddr = 8;
					reg_write_ena = 1;
					// $display("\t\t$ra: %d", writeData);
				end
				
				// Waiting for Reg Write
				else if( jump_flag == 2) begin
					jump_flag = 0;
					// $display("\t\tFLAG 2");
					// $display("\t\tStall for writing");

				end
			end
			
		end
	end
endmodule