####################### Data segment ######################################
 .data
orig: .asciiz "The string before converting is:-   "
result:  .asciiz "The string after converting to lower string is:-   "
string1: .asciiz "fhuyUNJjbhh7nJNkjghh78"
newline: .asciiz "\n"
answer: .space 100
####################### Data segment ######################################

####################### Text segment ######################################
.text
.globl main
    main:
     	
     	# Store the strings in register  
		la $t0, string1
		la $t2, answer

		# Traverse the string
		Loop:
			lb $t1, ($t0)

			# Null character checking
			beqz $t1, converted

			# If capital no change
			bgt $t1, 96, NoChange

			# If small increment by 32
			bgt $t1, 64, Change

			# Other characters
			j NoChange

			Change:
				addi $t1, $t1, 32

			#Store it in the location
			NoChange:
				sb $t1, ($t2)

			#Increment memory storage location
			addi $t0, $t0, 1
			addi $t2, $t2, 1
			j Loop

		# After converting
		converted:

			# Print the original string
			sb $t1, ($t2)
			li $v0, 4
			la $a0, orig
			syscall

			li $v0, 4
			la $a0, string1
			syscall

			li $v0, 4
			la $a0, newline
			syscall

			# Print the converted string
			li $v0, 4
			la $a0, result
			syscall

			li $v0, 4
			la $a0, answer
			syscall

		# Exit
		exit:
			li $v0, 10
			syscall # exit


               