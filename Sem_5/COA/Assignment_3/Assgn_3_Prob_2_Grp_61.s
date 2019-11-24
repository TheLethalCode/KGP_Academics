####################### Data segment ######################################
 .data
arraySize:   .asciiz "Enter the size of the array: "
space: .asciiz " "

windowsize:   .asciiz "Enter the window size: "

arrayValues:  .asciiz "Enter the array values: "

ans: 		  .asciiz "The window average of the array is: "	

newline: .asciiz "\n"

#declaring the array and the space it'll use
array: .space 10000	
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
    main:
        #Asking for numbers
	    la $a0, arraySize 
	    li $v0,4  #prints the message string
	    syscall

	    li $v0, 5  #reads the size of the array
		syscall

		move $t0, $v0

		la $a0, newline 
	    li $v0,4  #prints new line character
	    syscall

	    la $a0, windowsize 
	    li $v0,4  #prints the message for window size
	    syscall

	    li $v0, 5  #reads the window size
		syscall

	    move $t1, $v0  # t1 is the window size

	    la $a0, newline 
	    li $v0,4  #prints the new line character
	    syscall

	    la $a0, arrayValues 
	    li $v0,4  #prints the message for input of array integers
	    syscall

	    la $t2, array # base address of array
	    li $s0, 0	#i for Loop1

	    # Reading input
	    Loop1:
	        li $v0, 5  #reads first integer
		    syscall
		
		    #Move the inputs to the array
		    sw $v0, ($t2)
		    
		    #Increase the array index
		    addi $t2, $t2, 4

		    # No. of integers
            addi $s0, $s0, 1
		    
		    blt $s0, $t0, Loop1 #loop exit condition
	     
	    
	    la $t2, array	# base address of array
	    li $s1, 0		# i for Loop2
	    sub $s2, $t0, $t1	#s2 is the number of iterations for the outerloop

	    Loop2:
	    	li $s0, 0	#j for inner loop i.e loop3
	    	move $t3, $t2 # t3 is the base address for the window
	    	li $s3, 0  # s3 is used for calculating the average of the window
	    	Loop3:
			    # s2 stores the number as t0
			    lw $s4, ($t3)
			    
			    add $s3, $s3, $s4

		    	addi $t3, $t3, 4

			    	#Loop variable
		    	addi $s0, $s0, 1
			      
		# 	    	#Loop condition
			    blt $s0, $t1, Loop3
			
			div $s3, $t1 #dividing by window size
			mflo $s3
			sw $s3, ($t2)	#storing the window average at the base address of current window
			
			addi $t2, $t2, 4

			addi $s1, $s1, 1
			ble $s1, $s2, Loop2
			    

		la $a0, ans 
	    li $v0,4  #prints the message string
	    syscall	

	    la $t2, array # base address of array
	    li $s0, 0	#i for Loop1


	    # Reading input
	    Loop4:


		    la $a0, space 
	    	li $v0,4  #prints the message string
	    	syscall	

	    	lw $a0, ($t2)
	        li $v0, 1  #prints the array values
		    syscall
		    
		    #Increase the array index
		    addi $t2, $t2, 4

		    # No. of integers
            addi $s0, $s0, 1
		    
		    ble $s0, $s2, Loop4 #loop exit condition

	    exit:
	     	li $v0, 10
          	syscall # exit


  # #              