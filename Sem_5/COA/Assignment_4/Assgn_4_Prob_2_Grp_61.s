####################### Data segment ######################################
 .data
msg_input1:   .asciiz "Enter the integers in the row major order: "
space:	.asciiz "   "
pos_result:   .asciiz "Saddle point (i, j, A[i][j]):-   "
neg_result:   .asciiz "There are no saddle points."
newline: .asciiz "\n"
#declaring the array and the space it'll use
array: .space 64
min_row: .space 16
max_row: .space 16
min_col: .space 16
max_col: .space 16
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
    main:
        #Asking for numbers
	    la $a0, msg_input1 
	    li $v0, 4  #prints the message string
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
		    blt $s0, 16, Loop1
	      
	    la $a0, array   #The first argument for the function is thge address of array stored in a0
	    jal FindSaddle # calling the subroutine4		

	    exit:
	     	li $v0, 10
          	syscall # exit


  	FindSaddle:

  		li $t1, 4
		li $s4, 0 # Flag for saddle point

  		move $t0, $a0
  		
  		li $s0, 0 # Index for the row number (i)

		# The max rown and min col saddle point
		
  		LoopArray:
  			li $s1, 0 # Index for the column number (j)
  			
  			# Finding the unique maximum of the row

  			# Shift i*16 bytes so as to move to that address
			mult $s0, $t1  
			mflo $s2

			mult $s2, $t1
			mflo $s2

			add $t5, $t0, $s2 # Shift to the current address of the row

			lw $t6, ($t5) # Store the first element as the temporary maximum

			# Find the maximum element of the row
  			FindMaxRow:

  				lw $t7, ($t5) # The value in the array
   				bge $t6, $t7, NotChange 
  				
  				# Change the maximum
  				move $t6, $t7

  				NotChange:
  					addi $s1, $s1, 1
  					addi $t5, $t5, 4

  				blt $s1, 4, FindMaxRow


  			# Check whether it is unique
  			li $s1, 0
  			add $t5, $t0, $s2

  			li $t7, 0 # Counter
  			li $t9, 0 # Index of the maximum
  			CheckMax: 

  				lw $t8, ($t5) # The value in the array
   				bne $t6, $t8, NotChange1 
  				
  				# Increase Counter
  				addi $t7, $t7, 1
  				move $t9, $s1

  				NotChange1:
  					addi $s1, $s1, 1
  					addi $t5, $t5, 4

  				blt $s1, 4, CheckMax

  			bne $t7, 1, NoUniqueRow # If not unique maximum

  			# Find the column of the maximum of the row
  			mult $t9, $t1
  			mflo $t2

  			add $t5, $t0, $t2 # Shifted to the first number fo the required column
  			li $s1, 0 # Index for traversing the column

  			CheckSaddle:
  				lw $t7, ($t5)

				beq $s1, $s0, LoopCondition # If it is equal to the same element
  				ble $t7, $t6, NoUniqueRow # If it is not the unique minimum of the column, go to the next iteration
  				
				LoopCondition:
					addi $t5, $t5, 16 # Check the next element oif the column
					addi $s1, $s1, 1 # Increase Loop counter
					blt $s1, 4, CheckSaddle # Loop Condition

  			# Printing the saddle point

  			li  $v0, 4 # for print_str
		    la  $a0, pos_result  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $s0
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, space  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $t9
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, space  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $t6
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, newline  # preparing to print the message 
		    syscall

			li $s4, 1

  			NoUniqueRow:
  				addi $s0, $s0, 1
  				blt $s0, 4, LoopArray

		# The max col and min row saddle point
		
		li $s0, 0
  		LoopArray1:
  			li $s1, 0 # Index for the column number (j)
  			
  			# Finding the unique min of the row

  			# Shift i*16 bytes so as to move to that address
			mult $s0, $t1  
			mflo $s2

			mult $s2, $t1
			mflo $s2

			add $t5, $t0, $s2 # Shift to the current address of the row

			lw $t6, ($t5) # Store the first element as the temporary minimum

			# Find the maximum element of the row
  			FindMinRow:

  				lw $t7, ($t5) # The value in the array
   				ble $t6, $t7, NotChange2
  				
  				# Change the maximum
  				move $t6, $t7

  				NotChange2:
  					addi $s1, $s1, 1
  					addi $t5, $t5, 4

  				blt $s1, 4, FindMinRow


  			# Check whether it is unique
  			li $s1, 0
  			add $t5, $t0, $s2

  			li $t7, 0 # Counter
  			li $t9, 0 # Index of the minimum
  			CheckMin: 

  				lw $t8, ($t5) # The value of the array element
   				bne $t6, $t8, NotChange3 
  				
  				# Increase Counter
  				addi $t7, $t7, 1
  				move $t9, $s1

  				NotChange3:
  					addi $s1, $s1, 1
  					addi $t5, $t5, 4

  				blt $s1, 4, CheckMin

  			bne $t7, 1, NoUniqueCol # If not unique maximum

  			# Find the column of the maximum of the row
  			mult $t9, $t1
  			mflo $t2

  			add $t5, $t0, $t2 # Shifted to the first number fo the required column
  			li $s1, 0 # Index for traversing the column

  			CheckSaddle1:
  				lw $t7, ($t5)

				beq $s1, $s0, LoopCondition1 # If it is equal to the same element
  				bge $t7, $t6, NoUniqueCol # If it is not the unique minimum of the column, go to the next iteration
  				
				LoopCondition1:
					addi $t5, $t5, 16 # Check the next element oif the column
					addi $s1, $s1, 1 # Increase Loop counter
					blt $s1, 4, CheckSaddle1 # Loop Condition

  			# Printing the saddle point

  			li  $v0, 4 # for print_str
		    la  $a0, pos_result  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $s0
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, space  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $t9
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, space  # preparing to print the message 
		    syscall

		    li  $v0, 1
	        move $a0, $t6
	        syscall

	        li  $v0, 4 # for print_str
		    la  $a0, newline  # preparing to print the message 
		    syscall

			li $s4, 1

  			NoUniqueCol:
  				addi $s0, $s0, 1
  				blt $s0, 4, LoopArray1

		beq $s4, 1, Success

		# If no saddle point is found
		li  $v0, 4 # for print_str
		la  $a0, neg_result  # preparing to print the message 
		syscall

		Success:	
			jr $ra        #return to the last stored address in $ra       