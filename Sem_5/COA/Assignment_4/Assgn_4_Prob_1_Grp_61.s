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
	      
	    la $a0, array   #The first argument for the function is thge address of array stored in a0
	    li $a1, 8  		#The second argument for the function is number of elemnts in array stored in a1
	    jal InsertionSort # calling the subroutine

	    move $t0, $v0

		li  $v0, 4 # for print_str
	    la  $a0, pos_result  # preparing to print the message 
	    syscall  # print the string	
		
		li $s0, 0
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


  	InsertionSort:

  		li $t3, 1 # i - Outer loop counter
  		li $t2, 4
  		move $t0 ,$a0 # Load address of array
  		Loop2:
	    	
	    	mult $t3, $t2 
	    	mflo $t4  # 4*i number of bytes
	    	
	    	add $t5, $t0, $t4 # Address of A[i]
	    	
	    	move $t6, $t3 # j - inner loop counter
	    	addi $t6, $t6, -1 

	    	lw $t7, ($t5) #Loading k = A[i]

	    	Loop3:
	    		mult $t6, $t2 
	    		mflo $t4

	    		add $t8, $t0, $t4 # Address of A[j] 
	    		lw $t9, ($t8) # Value of A[j]


	    		ble $t9, $t7, outerloop # inner Loop condition (if A[j] < k then break)
	    		blt $t6, 0, outerloop # Boundary condition

	    		sw $t9, 4($t8) # A[j+1] = A[j]
	    	
	    		addi $t6, $t6 ,-1 # j--
	    		j Loop3

	    	outerloop:
	    		sw $t7, 4($t8) #A[j+1] = k
				
			addi $t3, $t3, 1
			blt $t3, $a1, Loop2

			move $v0, $a0 #Storing the address of array in the return parameter i.e v0
			jr $ra        #return to the last stored address in $ra       