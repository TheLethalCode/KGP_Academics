####################################
## Kousshik Raj
## 17CS30022
## Compilers Assignment - 1
####################################	
	.file	"ass1_17CS30022.c"										# name of the source file
	.text															# type of the section below
	.section	.rodata												# read only data below
	.align 8														# 8 byte memory boundary alignment
.LC0:																# first string label for storing the prompt to ask for dimenstions
	.string	"Enter the dimension of a square matrix: "				
.LC1:																# second string label for reading dimenstion from  the user
	.string	"%d"
	.align 8														# 8 byte memory boundary alignment
.LC2:																# third string label to prompt user to enter the first matrix
	.string	"Enter the first matix (row-major): "
	.align 8														# 8 byte boundary alignment
.LC3:																# fourth string label to prompt user to enter the second matrix
	.string	"Enter the second matix (row-major): "
.LC4:																# fifth string label to show result
	.string	"\nThe result matrix:"
.LC5:																# sixth string label to store user entry
	.string	"%d "
	.text															# type of the section below
	.globl	main													# defines the global function that is main
	.type	main, @function											# define type of main, which is function
main:																# start of main function
.LFB0:																
	.cfi_startproc													# initialize internal structures and emit initial CFI
	pushq	%rbp													# put base pointer in stack
	.cfi_def_cfa_offset 16											# Set CFA to use offset of 16
	.cfi_offset 6, -16											 	# Set rule to set register 6 at offset of -16 from CFI
	movq	%rsp, %rbp												# rbp <- rsp
	.cfi_def_cfa_register 6											# Set CFA to use offset of 16
	subq	$4832, %rsp												# Allocate space for array and variables
	leaq	.LC0(%rip), %rdi										# load address of .LCO(%rip) into %rdi
	movl	$0, %eax												# load 0 into %eax
	call	printf@PLT												# call system function printf to print "Enter the dimension of a square matrix: "
	leaq	-12(%rbp), %rax											# load address of -12(%rbp) into %rax
	movq	%rax, %rsi												# copy %rax to %rsi
	leaq	.LC1(%rip), %rdi										# copy first bit address of LC1 to store input variable in %rdi
	movl	$0, %eax												# load 0 into %eax
	call	__isoc99_scanf@PLT										# call scanf system function
	leaq	.LC2(%rip), %rdi										# copy first bit address of LC2 to store input variable in %rdi
	movl	$0, %eax												# load 0 into %eax
	call	printf@PLT												# call system printf function
	movl	-12(%rbp), %eax											# move -12(%rbp) to %eax
	leaq	-1616(%rbp), %rdx										# load address -1616(%rbp) to %rdx
	movq	%rdx, %rsi												# move %rdx to %rsi, basically passing matrix to the function ReadMat
	movl	%eax, %edi												# move %eax to %edi for passing variable n to ReadMat
	call	ReadMat													# call function ReadMat
	leaq	.LC3(%rip), %rdi										# copy string label LC3 to %edit for storing starting address of third string to print
	movl	$0, %eax												# put 0 in %eax
	call	printf@PLT												# call system printf function
	movl	-12(%rbp), %eax											# move -12(%rbp) into %eax%
	leaq	-3216(%rbp), %rdx										# loads address -3216(%rbp) into %rdx 
	movq	%rdx, %rsi												# move %rdx to %rsi
	movl	%eax, %edi												# move %eax to %edi
	call	ReadMat													# call ReadMat function
	movl	-12(%rbp), %eax											# move -12(%rbp) to %eax
	leaq	-4816(%rbp), %rcx										# load address of -4816(%rbp) to %rcx
	leaq	-3216(%rbp), %rdx										# load address of -3216(%rbp) to %rdx
	leaq	-1616(%rbp), %rsi										# load address of -1616(%rbp) to %rsi
	movl	%eax, %edi												# copy %eax to %edi
	call	MatMult													# call function MatMult
	leaq	.LC4(%rip), %rdi										# load string to print with the 4th printf statement
	call	puts@PLT												# initiate for loop
	movl	$0, -4(%rbp)											# set i = 0 for the outer loop by copying 0 into -4(%rbp)
	jmp	.L2															# jump to label L2 to check if to continue outer-level loop if i less than n
.L5:
	movl	$0, -8(%rbp)											# set j = 0 for the inner loop by setting 0 in -8(%rbp)
	jmp	.L3															# jump to label L3 to check if to continue inner-level loop if j les than n
.L4:
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	movslq	%eax, %rcx												# convert long int to quad
	movl	-4(%rbp), %eax											# copy -4(%rbp) to %eax
	movslq	%eax, %rdx												# convert long int to quad
	movq	%rdx, %rax												# copy %rdx to %rax
	salq	$2, %rax												# divide %rax by 4 using left shifts
	addq	%rdx, %rax												# add %rdx and %rax and store back in %rdx
	salq	$2, %rax												# divide %rax by 4 using left shifts
	addq	%rcx, %rax												# add %rcx and %rax and store back in %rcx
	movl	-4816(%rbp,%rax,4), %eax								# calculate array element address to print by storing (-1616 + %rbp + 4* %rax) in %rbp
	movl	%eax, %esi												# set second argument
	leaq	.LC5(%rip), %rdi										# load string label LC5 for printing
	movl	$0, %eax												# set 0 to %eax
	call	printf@PLT												# call system printf function
	addl	$1, -8(%rbp)											# increment -8(%rbp) by 1
.L3:
	movl	-12(%rbp), %eax											# move -12(%rbp) to %eax, that is store n in %eax
	cmpl	%eax, -8(%rbp)											# compare if %eax is less than -8(%rbp)
	jl	.L4															# if previous is true, jump to label L4
	movl	$10, %edi												# put 10 in %edi
	call	putchar@PLT												# call system putchar function
	addl	$1, -4(%rbp)											# increment -4(%rbp) by 1
.L2:
	movl	-12(%rbp), %eax											# copy -12(%rbp) to %eax that is putting n in %eax
	cmpl	%eax, -4(%rbp)											# compare if %eax is less than -4(%rbp)
	jl	.L5															# jump to label L5 if previous statement is true
	movl	$0, %eax												# put 0 in %eax
	leave															# put EBP to ESP and restore state of EBP to original
	.cfi_def_cfa 7, 8												# set computing CFA from register 7 and 8
	ret																# pop return address
	.cfi_endproc													# generate binary structure
.LFE0:
	.size	main, .-main											
	.globl	ReadMat
	.type	ReadMat, @function
ReadMat:															# define function ReadMat
.LFB1:																
	.cfi_startproc													# initialize internal structures
	pushq	%rbp													# push %rbp onto stack
	.cfi_def_cfa_offset 16											# Set CFA to use offset of 16
	.cfi_offset 6, -16											 	# Set rule to set register 6 at offset of 16 from CFI
	movq	%rsp, %rbp												# rbp <- rsp

	.cfi_def_cfa_register 6											# Set CFA to use offset of 16
	subq	$32, %rsp												# Allocate space for array and variables
	movl	%edi, -20(%rbp)											# copy %edi to -20(%rbp)
	movq	%rsi, -32(%rbp)											# copy %rsi to -32(%rbp)
	movl	$0, -4(%rbp)											# put 0 into -4(%rbp)
	jmp	.L8															# jump to label L8
.L11:
	movl	$0, -8(%rbp)											# put 0 in -8(%rbp), that is set j = 0 for inner loop
	jmp	.L9															# jump to label L9
.L10:
	movl	-4(%rbp), %eax											# put value of i in %eax
	movslq	%eax, %rdx												# convert from long to quad and put value of %eax to %rdx
	movq	%rdx, %rax												# move %rdx to %rax
	salq	$2, %rax												# division by 4 using 2 shift lefts
	addq	%rdx, %rax												# %rax = %rax + %rdx
	salq	$4, %rax												# division by 16 using 4 shift lefts
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	addq	%rax, %rdx												# %rdx = %rdx + %rax
	movl	-8(%rbp), %eax											# put -8(%rbp) in %eax
	cltq															# convert long to quad
	salq	$2, %rax												# division by four using two left shifts
	addq	%rdx, %rax												# %rax = %rdx + %rax
	movq	%rax, %rsi												# put %rax into %rsi
	leaq	.LC1(%rip), %rdi										# set first argument for scanf
	movl	$0, %eax												# set 0 to %eax
	call	__isoc99_scanf@PLT										# call system scanf function
	addl	$1, -8(%rbp)											# increment j for inner loop
.L9:
	movl	-8(%rbp), %eax											# put -8(%rbp) in %eax
	cmpl	-20(%rbp), %eax											# put -20(%rbp) in %eax
	jl	.L10														# move to inner loop
	addl	$1, -4(%rbp)											# increment i for outer loop
.L8:
	movl	-4(%rbp), %eax											# put -4(%rbp) to %eax
	cmpl	-20(%rbp), %eax											# compare if -20(%rbp) less than %eax 
	jl	.L11														# jump to L11
	nop
	nop																
	leave															# Copy EBP to ESP and then restore EBP to old state
	.cfi_def_cfa 7, 8												# set content of register 7 and 8 to CFA
	ret																# pop return address from stack and move there
	.cfi_endproc													# generate appropritate binary structures
.LFE1:
	.size	ReadMat, .-ReadMat										
	.section	.rodata
	.align 8														# set 8 byte memory alignment
.LC6:																# label for printf statement string
	.string	"\nThe transpose of the second matrix:"					
	.text
	.globl	TransMat												# make TransMat global name
	.type	TransMat, @function										# set type of TransMat as function
TransMat:
.LFB2:
	.cfi_startproc													# initialize internal structures
	pushq	%rbp													# push %rbp into stack
	.cfi_def_cfa_offset 16											# change CFA offset to 16
	.cfi_offset 6, -16												# save register 6 at -16 offset
	movq	%rsp, %rbp												# move %rsp to %rbp
	.cfi_def_cfa_register 6											# change CFA rule to use offset of 6
	subq	$32, %rsp												# create space for local variables of the function
	movl	%edi, -20(%rbp)											# move %edi to -20(%rbp), basically copying n
	movq	%rsi, -32(%rbp)											# move %rsi to -32(%rbp), loading matrix in stack
	movl	$0, -4(%rbp)											# move 0 to -4(%rbp)
	jmp	.L13														# jump to Label L13
.L16:
	movl	$0, -8(%rbp)											# set j = 0
	jmp	.L14														# jump to Label L14
.L15:
	movl	-4(%rbp), %eax											# copy -4(%rbp) value of i to %eax	
	movslq	%eax, %rdx												# convert to quad from long
	movq	%rdx, %rax												# load %rdx into %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rax = %rax + %rdx
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	addq	%rax, %rdx												# %rax = %rax + %rdx
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	cltq															# convert long to quad
	movl	(%rdx,%rax,4), %eax										# %eax = %rdx + (%rax* 4)
	movl	%eax, -12(%rbp)											# move %eax to -12(%rbp)
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	movslq	%eax, %rdx												# convert i to quad and move to %rdx
	movq	%rdx, %rax												# move %rdx to %rax
	salq	$2, %rax												# divide by 4 using left shift
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using left shift
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	leaq	(%rdx,%rax), %rsi										# load into %rsi
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad  
	movq	%rdx, %rax												# move %rdx to %rax
	salq	$2, %rax												# divide by 4 by left shift
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 by left shift
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	leaq	(%rdx,%rax), %rcx										# load memory value to %rcx
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	cltq															# convert long to quad
	movl	(%rsi,%rax,4), %edx										# %edx = %rdx +%rax* 4
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	cltq															# convert to quad
	movl	%edx, (%rcx,%rax,4)										# %rcx + (4 * %rax) <-- %edx
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad and move to -8(%rbp)
	movq	%rdx, %rax												# move %rdx to %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# %rax = %rax + %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	leaq	(%rdx,%rax), %rcx										# load memory value into %rcx
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	cltq															# convert to quad
	movl	-12(%rbp), %edx											# move -12(%rbp) to %edx
	movl	%edx, (%rcx,%rax,4)										# move %edx to %rcx + (%rax * 4)
	addl	$1, -8(%rbp)											# increment by 1 in -8(%rbp)
.L14:
	movl	-8(%rbp), %eax											# store j, move -8(%rbp) to %eax											
	cmpl	-4(%rbp), %eax											# check if -4(%rbp) is less than %eax
	jl	.L15														# jump to inner loop if last comparison true, that is label L15
	addl	$1, -4(%rbp)											# increment by 1 in -4(%rbp)
.L13:
	movl	-4(%rbp), %eax											# move -12(%rbp) to %eax
	cmpl	-20(%rbp), %eax											# compare if -20(%rbp) less than %eax
	jl	.L16														# if last statement is true, jump to label L16
	leaq	.LC6(%rip), %rdi										# load LC6 to %rdi to print
	call	puts@PLT												# call system puts function
	movl	$0, -4(%rbp)											# put 0 in -4(%rbp)
	jmp	.L17														# jump to another print loop for matrix printing
.L20:
	movl	$0, -8(%rbp)											# put 0 into -8(%rbp)
	jmp	.L18														# jump to Label L18 if the inner loop is to be continued
.L19:
	movl	-4(%rbp), %eax											# copy value of i, that is copy -4(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad and move %eax to %rdx
	movq	%rdx, %rax												# move %rdx to %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	addq	%rax, %rdx												# %rax = %rax + %rdx
	movl	-8(%rbp), %eax											# move -8(%rbp) to %eax
	cltq															# convert long in %eax to quad in %rax
	movl	(%rdx,%rax,4), %eax										# %eax = %rdx + (%rax * 4)
	movl	%eax, %esi												# move %eax to %esi
	leaq	.LC5(%rip), %rdi										# load LC5 address into %rdi for printing
	movl	$0, %eax												# put 0 in %eax
	call	printf@PLT												# call system print function
	addl	$1, -8(%rbp)											# increment by 1 in -8(%rbp) that is i
.L18:
	movl	-8(%rbp), %eax											# put n in %eax
	cmpl	-20(%rbp), %eax											# compare if -20(%rbp) is less than %eax
	jl	.L19														# if last is true, jump to L19
	movl	$10, %edi												# put 10 to %edi
	call	putchar@PLT												# call system putchar function
	addl	$1, -4(%rbp)											# increment -4(%rbp) by 1, i++
.L17:
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	cmpl	-20(%rbp), %eax											# compare if -20(%rbp) is less than %eax, that is j < n
	jl	.L20														# if last statement true, jump to L20
	nop																
	leave															# copy EBP to ESP and restore old EBP
	.cfi_def_cfa 7, 8												# set register 7 and 8 to compute CFA
	ret																# Pop return address and move to it
	.cfi_endproc													# generate appropriate binary structures
.LFE2:
	.size	TransMat, .-TransMat	
	.globl	VectMult												# VectMult is a global name
	.type	VectMult, @function										# VectMult is a function
VectMult:
.LFB3:

	.cfi_startproc													# initialize internal structures
	pushq	%rbp													# push %rbp into stack
	.cfi_def_cfa_offset 16											# change CFA offset to 16
	.cfi_offset 6, -16												# save register 6 at -16 offset
	movq	%rsp, %rbp												# move %rsp to %rbp
	.cfi_def_cfa_register 6											# change CFA rule to use offset of 6
	movl	%edi, -20(%rbp)											# move %edi to -20(%rbp)
	movq	%rsi, -32(%rbp)											# move %rsi to -32(%rbp)
	movq	%rdx, -40(%rbp)											# move %rdx to -40(%rbp)	
	movl	$0, -8(%rbp)											# put 0 in -8(%rbp)
	movl	$0, -4(%rbp)											# put 0 in -4(%rbp)
	jmp	.L22														# jump to label L22
.L23:
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	cltq															# convert to quad from long
	leaq	0(,%rax,4), %rdx										# load address into %rdx
	movq	-32(%rbp), %rax											# move -32(%rbp) to %rax
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	movl	(%rax), %edx											# move address of %rax to %edx
	movl	-4(%rbp), %eax											# move -4(%rbp) to %eax
	cltq															# convert to quad from long
	leaq	0(,%rax,4), %rcx										# load address into %rcx
	movq	-40(%rbp), %rax											# move -40(%rbp) into %rax
	addq	%rcx, %rax												# %rcx = %rcx + %rax
	movl	(%rax), %eax											# copt %rcx to %rax
	imull	%edx, %eax												# multiple %edx = %edx * %eax
	addl	%eax, -8(%rbp)											# %eax = %eax + (-8(%rbp))
	addl	$1, -4(%rbp)											# increment loop counter, add 1 to -4(%rbp)
.L22:
	movl	-4(%rbp), %eax											# copy -4(%rbp) to %eax
	cmpl	-20(%rbp), %eax											# compare if -20(%rbp) less than %eax, that is j < i
	jl	.L23														# if previous true, jump to L23
	movl	-8(%rbp), %eax											# copy -8%(rbp) to %eax
	popq	%rbp													# pop from stack and store in %rbp
	.cfi_def_cfa 7, 8												# set computing CFA from register 7 and 8
	ret																# pop return address from stack and go to it
	.cfi_endproc													# end process and generate appropriate structures
.LFE3:
	.size	VectMult, .-VectMult									
	.globl	MatMult													# declare MatMult as global
	.type	MatMult, @function										# declare type of MatMult as function
MatMult:
.LFB4:

	.cfi_startproc													# initialize internal structures
	pushq	%rbp													# push %rbp into stack
	.cfi_def_cfa_offset 16											# change CFA offset to 16
	.cfi_offset 6, -16												# save register 6 at -16 offset
	movq	%rsp, %rbp												# move %rsp to %rbp
	.cfi_def_cfa_register 6											# change CFA rule to use offset of 6
	pushq	%rbx													# push %rbx into stack
	subq	$56, %rsp												# subtract 56 from %rsp and store in the same
	.cfi_offset 3, -24												# save register 3 at -24 offset
	movl	%edi, -36(%rbp)											# copy %edi to -36(%rbp)
	movq	%rsi, -48(%rbp)											# copy %rsi to -48(%rbp)
	movq	%rdx, -56(%rbp)											# copy %rdx to -56(%rbp)
	movq	%rcx, -64(%rbp)											# copy %rcx to -64(%rbp)
	movq	-56(%rbp), %rdx											# copy -56(%rbp) to %rdx
	movl	-36(%rbp), %eax											# copy -36(%rbp) to %eax
	movq	%rdx, %rsi												# copy %rdx to %rsi
	movl	%eax, %edi												# copy %eax to %edi
	call	TransMat												# call function TransMat
	movl	$0, -20(%rbp)											# put 0 in -20(%rbp)
	jmp	.L26														# jump to L26
.L29:
	movl	$0, -24(%rbp)											# put 0 in -24(%rbp)
	jmp	.L27														# jump to L27
.L28:
	movl	-24(%rbp), %eax											# copy -24(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad from long and  copy to %eax from %rdx
	movq	%rdx, %rax												# move to %rdx from %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# move %rax to %rdx
	movq	-56(%rbp), %rax											# copy -56(%rbp) to %rax
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	movq	%rax, %rsi												# move %rax to %rsi
	movl	-20(%rbp), %eax											# move long from -20(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad from long and move to %rdx
	movq	%rdx, %rax												# move from %rdx to %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# move from %rax to %rdx
	movq	-48(%rbp), %rax											# move quad from -48(%rbp) to %rax
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	movq	%rax, %rcx												# move from %rax to %rcx
	movl	-20(%rbp), %eax											# move long from -20(%rbp) to %eax
	movslq	%eax, %rdx												# convert to quad from long, move from %eax to %rdx
	movq	%rdx, %rax												# move from %rdx to %rax
	salq	$2, %rax												# divide by 4 using shift left
	addq	%rdx, %rax												# %rdx = %rdx + %rax
	salq	$4, %rax												# divide by 16 using shift left
	movq	%rax, %rdx												# move from %rax to %rdx
	movq	-64(%rbp), %rax											# move from -64(%rbp) to %rax
	leaq	(%rdx,%rax), %rbx										# load address into %rbx
	movl	-36(%rbp), %eax											# move from -36(%rbp) to %eax
	movq	%rsi, %rdx												# move quad from %rsi to %rdx
	movq	%rcx, %rsi												# move quad from %rcs to %rsi
	movl	%eax, %edi												# move long from %eax to %edi
	call	VectMult												# call function VectMult
	movl	%eax, %edx												# move long from %eax to %edx
	movl	-24(%rbp), %eax											# move long from -24(%rbp) to %eax
	cltq															# convert to quad from long
	movl	%edx, (%rbx,%rax,4)										# move long from %edx to %rbx + (4 * %rax)
	addl	$1, -24(%rbp)											# increment counter by 1 at -24(%rbp)
.L27:
	movl	-24(%rbp), %eax											# move long from -24(%rbp) to %eax
	cmpl	-36(%rbp), %eax											# compare if -36(%rbp) less than %eax
	jl	.L28														# if previous true, jump to L28 and loop again
	addl	$1, -20(%rbp)											# increment loop counter by 1 at -20(%rbp)
.L26:
	movl	-20(%rbp), %eax											# move long from -20(%rbp) to %eax
	cmpl	-36(%rbp), %eax											# compare if -36(%rbp) less than %eax
	jl	.L29														# jump to L29 if previous true
	nop
	nop
	addq	$56, %rsp												# %rsp = %rsp + 56
	popq	%rbx													# pop %rbx from stack
	popq	%rbp													# pop %rbp from stack
	.cfi_def_cfa 7, 8												# set computing CFA from register 7 and 8
	ret																# pop return address from stack and go to it
	.cfi_endproc													# end process and generate appropriate structures
.LFE4:
	.size	MatMult, .-MatMult
	.ident	"GCC: (GNU) 9.1.0"
	.section	.note.GNU-stack,"",@progbits
