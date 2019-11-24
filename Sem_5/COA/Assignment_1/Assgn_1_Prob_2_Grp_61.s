####################### Data segment ######################################
 .data
msg_input:   .asciiz "Enter the number: "
# msg_arg:   .asciiz "The argument is: "
msg_result:   .asciiz "The fibonacci number is: "
neg_number:   .asciiz "You have not entered a positive number"
newline:   .asciiz "\n"
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
     main:
          la $a0, msg_input # message string in $a0, pseudoinstruction
          li $v0, 4 # Prepare to print the message
          syscall  # print the message

          li $v0, 5 # for read_int
          syscall 
          move $a0, $v0
           

          move $t0, $a0

          # First and second fibonacci number
          li $s0, 0
          li $s1, 1

          # checking whether input is positive
          bgt $t0, 2, Great_2
          bgt $t0, 1, Great_1
          bgt $t0, 0, Great_0
               
          # if not positive
          la $a0, neg_number # message string in $a0, pseudoinstruction
          li $v0, 4 # Prepare to print the message
          syscall  # print the message
          j Exit

          # if input is 2
          Great_1:
          li $t0, 1
          j Print

          # if input is 1
          Great_0:
          li $t0, 0
          j Print

          # Run a loop and perform calculations to calculate the $t0 th fibonacci number if input is greater than 2
          Great_2:
          sub $t0, $t0, 2
          
          Loop:  
          sub $t0, $t0, 1 #number of iterations
          move $t1, $s1 # store the bigger number in a temp register
          add $s1, $s1, $s0 # calculate the sum of the two registers
          move $s0, $t1 # copy the bigger register to the smaller one
          bgt $t0, $zero, Loop #exit the loop when t0 becomes 0
          
          move $t0, $s1 # temporarily hold value in $t0
          
          # Print a newline
          li  $v0, 4 # for print_str
          la  $a0, newline # preparing to print the newline
          syscall  # print the newline
          
          # Print result
          Print:
          li  $v0, 4 # for print_str
          la  $a0, msg_result  # preparing to print the message 
          syscall  # print the string
      
              
          move $a0, $t0 # get result in $a0
          li  $v0, 1 # for print_int
          syscall  # print the result

     Exit:
          li $v0, 10
          syscall # exit
           
####################### Text segment ######################################
