.globl quick_sort

/**
	Arguments and Labels:
	*base is passed in %rdi and held in %r15
	nel is passed in %rsi
	width is passed in %rdx and held in %rbp
	*compar is passed in %rcx and held in %rbx
	*last is held in %r14
	*right is held in %r12
	*left is held in %r13
**/

.text

quick_sort:
/*==============salvaguarda de registos======================*/
push  %r12
push  %r13
push  %r14
push  %r15
push  %rbp
push  %rbx
mov   %rsi, %r14	# %r14 = %rsi			//%r14=nel	
mov   %rdi, %r15	# %r15 = %rdi			//%r15=*base
mov   %rdx, %rbp	# %rbp = %rdx			//%rbp=width
mov   %rcx, %rbx	# %rbx = %rcx			//%r10=*compar

decq  %r14			# %r14 = %r14 - 1		//nel-1		
imulq %rdx, %r14	# %r14 = %r14 * %rdx	//width*(nel-1)
addq  %rdi, %r14	# %r14 = %rdi + %r14	//*last=base+width*(nel-1)
movq  %r14, %r12	# %r12 = %r14			//*rigth=last
movq  %rdx, %r13	# %r13 = %rdx			
addq  %rdi, %r13	# %r13 = %r13 + %di		//*left=base+width

while:
	while1:
		cmpq %r12, %r13		# %r13 - %r12			//left-right
		jg   while2
		mov  %r13, %rdi		# %rdi = %r13			//%rdi=left
		mov  %r15, %rsi		# %rsi = %r15			//%rsi=base
		call *%rbx			# call *compar
		cmpl $0,%eax
		jg   while2
		add  %rbp, %r13		# %r13 = %r13 + %rbp	//left+=width
		jmp  while1
	
	while2:
		cmpq %r13, %r12		# %r12 - %13			//right-left
		jb   if
		mov  %r12, %rdi		# %rdi = %r12			//%rdi=right
		mov  %r15, %rsi		# %rsi = %r15			//%rsi=base
		call *%rbx			# call *compar
		cmpl $0,%eax
		jl   if
		sub  %rbp, %r12		# %r12 = %r12 - %rbp	//right-=width
		jmp  while1
	
	if:
		cmp %r13, %r12		# %r12 - %r13			//right-left
		jl fim_while
	
	mov %r13, %rdi		# %rdi = %r13		//%rdi=left
	mov %r12, %rsi		# %rsi = %r12		//%rsi=right
	mov %rbp, %rdx		# %rdx = %rbp		//%rdx=width
	call memswap
	jmp while1

fim_while:

mov  %r15, %rdi		# %rdi = %r15			//%rdi=base
mov  %r12, %rsi		# %rsi = %r12			//%rsi=right
mov  %rbp, %rdx		# %rdx = %rbp			//%rdx=width
call memswap

cmp  %r15, %r12		# %r12 - %r15			//right-base
jle   second_if
mov  %rbp, %rcx
mov  %r12, %rax		# %rax = %r12			//%rax=right
sub  %r15, %rax		# %rax = %rax - %r15	//%rax=right-base
cqto
movq %rbp,%rcx
idiv %rcx			# %rax = %rax / %rdx
mov  %rax, %rsi		# %rsi = %rax			//%rsi=(right-base)/width
mov  %rbp, %rdx		# %rdx = %rbp			//%rdx=width
mov  %rbx, %rcx 	# %rcx = %rbx			//%rcx=compar
mov  %r15, %rdi		# %rdi = %r15			//%rdi=base
call quick_sort

second_if:
	cmp  %r14, %r12		# %r12 - %r14			//right-last
	jge  return
	mov  %rbp, %rcx
	mov  %r12, %rdi		# %rdi = %r12			//%rdi=right
	add  %rbp, %rdi		# %rdi = %rdi + %rbp	//%rdi=right+width
	mov  %r14, %rax		# %rax = %r14			//%rax=last
	sub  %r12, %rax		# %rax = %rax - %r12	//%rax=last-right
	cqto
	movq %rbp,%rcx
	idiv %rcx			# %rax = %rax / %rdx	//%rax=(last-right)/width
	mov  %rax, %rsi		# %rsi = %rax			//%rsi=(last-right)/width
	mov  %rbp, %rdx
	mov  %rbx, %rcx		# %rcx = %rbx			//%rcx=compar
	call quick_sort
	
return:
	pop %rbx
	pop %rbp
	pop %r15
	pop %r14
	pop %r13
	pop %r12


/*===============memswap=================*/

/**
	Arguments and labels:
	*one is passed in %rdi and is held in %r13
	*other is passed in %rsi and is held in %r12
	width is passed in %rdx and is held in %rbx
**/
memswap:
	/*====definir frame pointer=========*/
	pushq %rbp
	movq %rsp,%rbp
	pushq %r13
	pushq %r12
	pushq %rbx
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	subq $8,%rsp
	leaq 15(%rdx),%rax
	andq $16,%rax # possibly negative or positive
	subq %rax,%rsp
	movq %rsp,%rdi
	movq %r13,%rsi
	call memcpy
	movq %r13,%rdi
	movq %r12,%rsi
	movq %rbx,%rdx
	call memcpy
	movq %r12,%rdi
	movq %rsp,%rsi
	movq %rbx,%rdx
	call memcpy
	leaq -24(%rbp),%rsp
	popq %rbx
	popq %r12
	popq %r13
	popq %rbp
	ret
