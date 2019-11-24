####################### Data segment ######################################
 .data
msg_input1:   .asciiz "Enter the first numbers: "
msg_input2:   .asciiz "Enter the second numbers: "

msg_result:   .asciiz "The GCD of two numbers is: "
neg_number:   .asciiz "You have not entered a positive number"
newline:   .asciiz "\n"
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
     main:
          la $a0, msg_input1 
          li $v0,4  #prints the message string
          syscall

          li $v0,5  #reads first integer
          syscall
          move $t0, $v0 #result returned in $v0
               
          la $a0, msg_input2 
          li $v0,4  #prints the message string
          syscall
               
          li $v0, 5 #reads second integer
          syscall
          move $t1, $v0 #result returned in $v0

          # checking whether both the inputs are positive
          blt $t0, 1, NegetiveNumber
          blt $t1, 1, NegetiveNumber 
          j Loop

          # if not positive
          NegetiveNumber:
          la $a0, neg_number # message string in $a0, pseudoinstruction
          li $v0, 4 # Prepare to print the message
          syscall  # print the message
          j Exit

          # Calculating GCD
          Loop:  
          bgt $t1, $t0, AGreaterB
          j BGreaterA

          AGreaterB:
          sub $t1, $t1, $t0
          j LoopCondition

          BGreaterA:
          sub $t0, $t0, $t1
          j LoopCondition
          
          LoopCondition:
          bgt $t0, $zero, Loop
          
          # Print a newline
          li  $v0, 4 # for print_str
          la  $a0, newline # preparing to print the newline
          syscall  # print the newline
          
          # Print result
          Print:
          li  $v0, 4 # for print_str
          la  $a0, msg_result  # preparing to print the message 
          syscall  # print the string
      
              
          move $a0, $t1 # get result in $a0
          li  $v0, 1 # for print_int
          syscall  # print the result

     Exit:
          li $v0, 10
          syscall # exit
           
####################### Text segment ######################################
