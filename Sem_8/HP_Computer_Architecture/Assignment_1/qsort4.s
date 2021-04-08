	.file	"qsort4.c"
	.text
	.globl	a
	.bss
	.align 32
	.type	a, @object
	.size	a, 8000
a:
	.zero	8000
	.text
	.globl	qsort
	.type	qsort, @function
qsort:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	%rdx, -136(%rbp)
	movq	%rcx, -144(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	movq	%rsp, %rax
	movq	%rax, %rbx
	movq	-136(%rbp), %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -88(%rbp)
	movq	%rax, %r14
	movl	$0, %r15d
	movq	%rax, %r12
	movl	$0, %r13d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %esi
	movl	$0, %edx
	divq	%rsi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -80(%rbp)
	movq	-136(%rbp), %rax
	movq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, -72(%rbp)
	movq	%rax, %r10
	movl	$0, %r11d
	movq	%rax, %r8
	movl	$0, %r9d
	movl	$16, %edx
	subq	$1, %rdx
	addq	%rdx, %rax
	movl	$16, %esi
	movl	$0, %edx
	divq	%rsi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -64(%rbp)
	movl	$0, -96(%rbp)
	movq	-128(%rbp), %rax
	subl	$1, %eax
	movl	%eax, -92(%rbp)
	movl	-96(%rbp), %eax
	cmpl	-92(%rbp), %eax
	jge	.L2
	movl	-92(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-136(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movl	-96(%rbp), %eax
	movl	%eax, -100(%rbp)
	movl	-92(%rbp), %eax
	movl	%eax, -104(%rbp)
	jmp	.L3
.L5:
	addl	$1, -100(%rbp)
.L4:
	movl	-100(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-80(%rbp), %rax
	movq	-144(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	js	.L5
	jmp	.L6
.L7:
	subl	$1, -104(%rbp)
.L6:
	movl	-104(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-80(%rbp), %rax
	movq	-144(%rbp), %rdx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	*%rdx
	testl	%eax, %eax
	jg	.L7
	movl	-100(%rbp), %eax
	cmpl	-104(%rbp), %eax
	jg	.L3
	movl	-100(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-136(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movl	-104(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rsi
	movl	-100(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	%rcx, %rdi
	call	memcpy@PLT
	movl	-104(%rbp), %eax
	cltq
	imulq	-136(%rbp), %rax
	movq	%rax, %rdx
	movq	-120(%rbp), %rax
	leaq	(%rdx,%rax), %rcx
	movq	-136(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy@PLT
	addl	$1, -100(%rbp)
	subl	$1, -104(%rbp)
.L3:
	movl	-100(%rbp), %eax
	cmpl	-104(%rbp), %eax
	jle	.L4
	movl	-104(%rbp), %eax
	subl	-96(%rbp), %eax
	addl	$1, %eax
	cltq
	movl	-96(%rbp), %edx
	movslq	%edx, %rdx
	movq	%rdx, %rcx
	imulq	-136(%rbp), %rcx
	movq	-120(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rdx
	movq	%rax, %rsi
	call	qsort
	movl	-92(%rbp), %eax
	subl	-100(%rbp), %eax
	addl	$1, %eax
	cltq
	movl	-100(%rbp), %edx
	movslq	%edx, %rdx
	movq	%rdx, %rcx
	imulq	-136(%rbp), %rcx
	movq	-120(%rbp), %rdx
	leaq	(%rcx,%rdx), %rdi
	movq	-144(%rbp), %rcx
	movq	-136(%rbp), %rdx
	movq	%rax, %rsi
	call	qsort
.L2:
	movq	%rbx, %rsp
	nop
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	je	.L9
	call	__stack_chk_fail@PLT
.L9:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	qsort, .-qsort
	.globl	compar_double
	.type	compar_double, @function
compar_double:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-24(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -16(%rbp)
	movq	-32(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	comisd	-16(%rbp), %xmm0
	jbe	.L16
	movl	$-1, %eax
	jmp	.L14
.L16:
	movsd	-16(%rbp), %xmm0
	ucomisd	-8(%rbp), %xmm0
	setp	%al
	movl	$1, %edx
	movsd	-16(%rbp), %xmm0
	ucomisd	-8(%rbp), %xmm0
	cmovne	%edx, %eax
	movzbl	%al, %eax
.L14:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	compar_double, .-compar_double
	.section	.rodata
.LC0:
	.string	"%f\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	jmp	.L18
.L19:
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-4(%rbp), %xmm0
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	a(%rip), %rax
	movsd	%xmm0, (%rdx,%rax)
	addl	$1, -4(%rbp)
.L18:
	cmpl	$999, -4(%rbp)
	jle	.L19
	leaq	compar_double(%rip), %rcx
	movl	$8, %edx
	movl	$1000, %esi
	leaq	a(%rip), %rdi
	call	qsort
	movl	$0, -4(%rbp)
	jmp	.L20
.L21:
	movl	-4(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	a(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, %xmm0
	leaq	.LC0(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	addl	$1, -4(%rbp)
.L20:
	cmpl	$999, -4(%rbp)
	jle	.L21
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
	.section	.note.GNU-stack,"",@progbits
