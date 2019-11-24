####################### Data segment ######################################
 .data
msg_input1:   .asciiz "Enter the 8 numbers: "
space:	.asciiz "  "

pos_result:   .asciiz "The sorted numbers are    "

#declaring the array and the space it'll use
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
		    
		    # li $v0, 1
		    # move $a0, $s0
		    # syscall  
		    #Loop Condition
		    blt $s0, 8, Loop1
	      
	    	
		#main loop for bubble sort keeping the track of number of swaps    
	    Loop2:
	    	li $s0, 0	
	    	li $s1, 0
	    	la $t0, array
	    	Loop3:
	    		#t1 vairable stores the next number to t0
			    lw $t1, 4($t0)

			    # s2 stores the number as t0
			    lw $s2, ($t0)
			    #check condition
			    blt $t1, $s2, Swap
			    j notSwap
			    #swaping when t1 is less then s2
			    Swap:
			    	sw $t1, ($t0)
			    	sw $s2, 4($t0)
			    	#s1 keeps the track of number of swaps
			    	addi $s1, $s1, 1

			    notSwap:	
			    	addi $t0, $t0, 4

			    	#Loop variable
			    	addi $s0, $s0, 1
			      
		# 	    	#Loop condition
			    	blt $s0, 7, Loop3
			#if number of swaps is not 0 then again go to the main loop    	
			bgt $s1, 0, Loop2    

		li  $v0, 4 # for print_str
	    la  $a0, pos_result  # preparing to print the message 
	    syscall  # print the string	
		
		li $s0, 0
		la $t0, array

		Loop4:
		    li  $v0, 1
	        lw $a0, ($t0)
	        syscall

	        li  $v0, 4 # for print_str
	    	la  $a0, space  # preparing to print the message 
	    	syscall  # print the string	

	        addi $t0, $t0, 4
	        addi $s0, $s0, 1
	        blt $s0, 8, Loop4		

	    exit:
	     	li $v0, 10
          	syscall # exit


  # #              