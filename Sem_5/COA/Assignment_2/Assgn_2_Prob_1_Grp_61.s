####################### Data segment ######################################
 .data
msg_input1:   .asciiz "Enter the 8 numbers: "
msg_input2:   .asciiz "Enter the number to be searched for: "

desc_number:  .asciiz "The numbers are not in ascending order"
neg_result:   .asciiz "The number was not found"

pos_result:   .asciiz "The number was found at index    "
newline:   .asciiz "\n"

array: .space 32
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
     main:
     	  #Asking for numbers
	      la $a0, msg_input1 
	      li $v0,4  #prints the message string
	      syscall

	      la $t0, array
	      li $s0, 0

	      # Reading input
	      Loop1:
		      li $v0, 5  #reads first integer
		      syscall
		      
		      #Move the inputs to the array
		      sw $v0, ($t0)
		      
		      #Increase the array index
		      addi $t0, $t0, 4

		      # No. of integers
		      addi $s0, $s0, 1
		      
		      #Loop Condition
		      blt $s0, 8, Loop1
	      
		  #Checking for ascending order
	      li $s0, 0
	      la $t0, array

	      Loop2:
		      lw $t1, 4($t0)

		      # Check condition
		      lw $s2, ($t0)
		      blt $t1, $s2, notAscending
		      addi $t0, $t0, 4

		      #Loop variable
		      addi $s0, $s0, 1
		      
		      #Loop condition
		      blt $s0, 7, Loop2

		  #Read in number to be searched for
		  la $a0, msg_input2 
	      li $v0, 4  #prints the message string
	      syscall

	      li $v0, 5  #reads integer
		  syscall
		  move $s1, $v0 

		  #Searching for the number
		  li $t2, 0
		  li $t3, 7
		  la $t0, array
		  la $t1, array

		  Loop3:
		  	  #Exit condition
		  	  bgt $t2, $t3, fail

		  	  # Calculating mid
		      add $t4, $t2, $t3
		      li $s3, 2
		      div $t4, $s3
		      mflo $t4

		      # In terms of bytes
		      li $s3, 4
		      mult $t4, $s3
		      mflo $t4

		      #Check for success
		      add $t1, $t0, $t4
		      lw $s2, ($t1)
		      beq $s2, $s1, success

		      # Binary Search conditio
		      blt $s2, $s1, Right
		      j Left

		      Right:
		        li $s3, 4
		      	div $t4, $s3
		      	mflo $t4
		      	addi $t2, $t4, 1
		      	j Loop3

		      Left:
		      	li $s3, 4
		      	div $t4, $s3
		      	mflo $t4
		      	sub $t3, $t4, 1
		      	j Loop3 

		  #When the number has not been found
		  fail:
		      li  $v0, 4 # for print_str
	          la  $a0, neg_result  # preparing to print the message 
	          syscall  # print the string
	          j exit

		  #When the number has been found
		  success:
		      li $s3, 4
		      div $t4, $s3
		      mflo $t4

		      li  $v0, 4 # for print_str
	          la  $a0, pos_result  # preparing to print the message 
	          syscall  # print the string

	          li  $v0, 1
	          move $a0, $t4
	          syscall

	          j exit

	      #When numbers are not in ascending order 
		  notAscending:
		  	  li  $v0, 4 # for print_str
	          la  $a0, desc_number  # preparing to print the message 
	          syscall  # print the string
	          j exit

	      exit:
	      	li $v0, 10
          	syscall # exit


               