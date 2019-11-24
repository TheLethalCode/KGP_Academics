####################### Data segment ######################################
 .data
msg_input1:   .asciiz "Enter the 8 numbers: "
space:  .asciiz "  "

pos_result:   .asciiz "The sorted numbers are    "
newline: .asciiz "  \n"
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

      # Initialise the arguments
      la $a0, array 
      li $a1, 8

      jal form_array  # function to read the input
      jal QuickSort # Call the quicksort

      li  $v0, 4 # for print_str
      la  $a0, pos_result  # preparing to print the message 
      syscall  # print the string 
    
      li $s0, 0
      la $t0, array

      # Print the sorted array
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
      
    # Function for reading input
    form_array:

      # Reading input
      move $t0, $a0
      li $s0, 0

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
        blt $s0, $a1, Loop1

      move $v0, $a0
      jr $ra

    # Quicksort 
    QuickSort:


      addi $sp, $sp, -12 # Making space in stack by moving stack pointer down

      sw $ra, ($sp)   # Storing ra
      sw $a0, 4($sp)  # Saving the original arguments given to the function
      sw $a1, 8($sp)
      
      addi $a2, $a1, -1
      li $a1, 0
      
      jal QuickSort1  # Calling the main quicksort

      lw $ra, ($sp)   # Getting the ra value back 
      lw $v0, 4($sp)  # Value to be returned
      
      addi $sp, $sp, 12 # Cleaning the stack
      
      jr $ra # Returning

    # The function where sorting happens
    QuickSort1:
      
      # Base condition If a1 >= a2, return
      blt $a1, $a2, recurse
      jr $ra

      # Main recursion
      recurse:
        addi $sp, $sp, -20 # Making space for 5 elements in stack by moving stack pointer down
        
         # Storing ra
        sw $ra, ($sp)  

        # Saving the original arguments given to the function
        sw $a0, 4($sp)  
        sw $a1, 8($sp)
        sw $a2, 12($sp)

        # Calculating the pivot index
        jal Partition

        sw $v0, 16($sp) # Storing $v0 = q

        lw $a0, 4($sp) # Address of array
        lw $a1, 8($sp) # a1 = p
        addi $a2, $v0, -1 # a2 = q-1

        jal QuickSort1 # Q(A, p, q-1)

        lw $a0, 4($sp) # Retrieve the address of array
        
        lw $a1, 16($sp) 
        addi $a1, $a1, 1 # a1 = q + 1

        lw $a2, 12($sp) # a2 = r


        jal QuickSort1 # Q(A, q + 1, r)

        # Retrieve the $ra
        lw $ra, ($sp)

        # Retriev the arguments
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $a2, 12($sp)
        
        # Clear up the stack
        addi $sp, $sp, 20

        # Return
        jr $ra


    Partition:
      
      li $s0, 4 # For multiplication

      mult $a2, $s0
      mflo $s1 # Number of bytes A[r] is ahead of base address of array
      
      add $s2, $s1, $a0 # s2 = Address of A[r]
      lw $s3, ($s2) # s3 = A[r] = x

      addi $s4, $a1, -1 # s4 = i = p-1

      move $s5, $a1 # s5 = j = p

      addi $s6, $a2, -1 # s6 = r-1

      Loop:

        # Calculating A + j*4    
        mult $s5, $s0
        mflo $s1

        add $s7, $s1, $a0 # s7 = Address of A[j]
        lw $t0, ($s7) # t0 = A[j]

        ble $t0, $s3, swap # Swapping conditon A[j] <= x

        j LoopCondtion

        swap:

          addi $s4, $s4, 1 # i = i + 1

          # Calculating A + 4*i
          mult $s4, $s0
          mflo $t1

          add $t2, $t1, $a0 # t2 = address of A[i]
          lw $t3, ($t2) # t3 = A[i]

          # Swap A[i] and A[j]
          sw $t3, ($s7)
          sw $t0, ($t2) 

        LoopCondtion:

          addi $s5, $s5, 1 # j = j + 1 
          ble $s5, $s6, Loop # Loop condition

      addi $s4, $s4, 1 # i = i + 1

      # Calculating A + 4*i
      mult $s4, $s0
      mflo $t1
      
      add $t2, $t1, $a0 # t2 = address of A[i]
      lw $t5, ($t2) # t5 = A[i]
      
      # Swap A[i] and A[r]
      sw $t5, ($s2) 
      sw $s3, ($t2)

      move $v0, $s4 # Return i
      jr $ra # Return