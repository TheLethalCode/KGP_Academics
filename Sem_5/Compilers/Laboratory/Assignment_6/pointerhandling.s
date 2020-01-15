	.file	"output.s"

.STR0:	.string "\n"
.STR1:	.string "\n"
.STR2:	.string "YIPPEEE\n"
.STR3:	.string "OOOOPS\n"
.STR4:	.string "\n"
	.text
	.globl	gen
	.type	gen, @function
gen:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$20, %rsp
	movq	%rdi, -8(%rbp)
# 0:res = t000 
	movl	$10, -12(%rbp)
# 1:res = a arg1 = t000 
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movl	%edx, (%rax)
# 2:res = t001 arg1 = t000 
	movl	-12(%rbp), %eax
	movl	%eax, -16(%rbp)
# 3:res = t002 
	movl	$0, -20(%rbp)
# 4:res = t002 
	movl	-20(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-20, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	gen, .-gen
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$125, %rsp
# 5:res = t003 
	movl	$5, -16(%rbp)
# 6:res = i arg1 = t003 
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
# 7:res = t004 arg1 = i 
	leaq	-12(%rbp), %rax
	movq	%rax, -24(%rbp)
# 8:res = p arg1 = t004 
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
# 9:res = t005 arg1 = t004 
	movq	-24(%rbp), %rax
	movq	%rax, -32(%rbp)
# 10:res = t006 
	movl	$61, -36(%rbp)
# 11:res = p arg1 = t006 
	movq	-8(%rbp), %rax
	movl	-36(%rbp), %edx
	movl	%edx, (%rax)
# 12:res = t007 arg1 = t006 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 13:res = i 
# 14:res = t008 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printi
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 15:
	movq	$.STR0,	%rdi
# 16:res = t009 
	pushq %rbp
	call	prints
	movl	%eax, -48(%rbp)
	addq $8 , %rsp
# 17:res = q arg1 = p 
	movq	-8(%rbp), %rax
	movq	%rax, -56(%rbp)
# 18:res = t010 
	movl	$55, -60(%rbp)
# 19:res = q arg1 = t010 
	movq	-56(%rbp), %rax
	movl	-60(%rbp), %edx
	movl	%edx, (%rax)
# 20:res = t011 arg1 = t010 
	movl	-60(%rbp), %eax
	movl	%eax, -64(%rbp)
# 21:res = i 
# 22:res = t012 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printi
	movl	%eax, -68(%rbp)
	addq $0 , %rsp
# 23:
	movq	$.STR1,	%rdi
# 24:res = t013 
	pushq %rbp
	call	prints
	movl	%eax, -72(%rbp)
	addq $8 , %rsp
# 25:res = t014 
	movb	$65, -74(%rbp)
# 26:res = c arg1 = t014 
	movzbl	-74(%rbp), %eax
	movb	%al, -73(%rbp)
# 27:res = t015 arg1 = c 
	leaq	-73(%rbp), %rax
	movq	%rax, -90(%rbp)
# 28:res = d arg1 = t015 
	movq	-90(%rbp), %rax
	movq	%rax, -82(%rbp)
# 29:res = t016 arg1 = t015 
	movq	-90(%rbp), %rax
	movq	%rax, -98(%rbp)
# 30:res = t017 
	movb	$107, -99(%rbp)
# 31:res = d arg1 = t017 
	movq	-82(%rbp), %rax
	movl	-99(%rbp), %edx
	movl	%edx, (%rax)
# 32:res = t018 arg1 = t017 
	movzbl	-99(%rbp), %eax
	movb	%al, -100(%rbp)
# 33:res = t019 
	movb	$107, -101(%rbp)
# 34:arg1 = c arg2 = t019 
	movzbl	-73(%rbp), %eax
	cmpb	-101(%rbp), %al
	je .L1
# 35:
	jmp .L2
# 36:
	jmp .L3
# 37:
.L1:
	movq	$.STR2,	%rdi
# 38:res = t020 
	pushq %rbp
	call	prints
	movl	%eax, -105(%rbp)
	addq $8 , %rsp
# 39:
	jmp .L3
# 40:
.L2:
	movq	$.STR3,	%rdi
# 41:res = t021 
	pushq %rbp
	call	prints
	movl	%eax, -109(%rbp)
	addq $8 , %rsp
# 42:
	jmp .L3
# 43:res = p 
.L3:
# 44:res = t022 
	pushq %rbp
	movq	-8(%rbp), %rdi
	call	gen
	movl	%eax, -113(%rbp)
	addq $0 , %rsp
# 45:res = i 
# 46:res = t023 
	pushq %rbp
	movl	-12(%rbp) , %edi
	call	printi
	movl	%eax, -117(%rbp)
	addq $0 , %rsp
# 47:
	movq	$.STR4,	%rdi
# 48:res = t024 
	pushq %rbp
	call	prints
	movl	%eax, -121(%rbp)
	addq $8 , %rsp
# 49:res = t025 
	movl	$0, -125(%rbp)
# 50:res = t025 
	movl	-125(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-125, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
