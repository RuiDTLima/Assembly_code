.globl   quick_sort

/**
	Arguments and Labels:
	*base is passed in %rdi and held in %r12
	nel is passed in %rsi 
	width is passed in %rdx and held in %rbp
	*compar is passed in %rcx and held in %r13
	*last is held in %r10
	*right is held in %r14
	*left is held in %r15
**/

.text

quick_sort:

/*==============salvaguarda de registos======================*/
push  %rbp			# save previous value in %rbp
push  %r12			# save previous value in %r12
push  %r13			# save previous value in %r13
push  %r14			# save previous value in %r14
push  %r15			# save previous value in %r15
movq  %rdx, %rbp	# %rbp = %rdx			//%rbp = width
movq  %rdi, %r12	# %r12 = %rdi			//%r12 = *base
movq  %rcx, %r13	# %r13 = %rcx			//%r13 = *compar
movq  %rsi, %r10	# %r10 = %rsi			//%r10 = nel

/*=============preparação de ponteiros======================*/
decq  %r10			# %r10 = %r10 - 1		//nel-1
imulq %rdx, %r10	# %r10 = %r10 * %rdx    //width*(nel-1)
addq  %rdi, %r10	# %r10 = %r10 + %rdi	//*last = base + width*(nel-1)
movq  %r10, %r14	# %r14 = %r10			//*right = last
movq  %rdx, %r15	# %r15 = %rdx			//*left = width
addq  %rdi, %r15	# %r15 = %r15 + %rdi	//*left = width + base

/*=============do while====================================*/
while1:
	
	while2:
		cmpq  %r14, %r15		# %r15 - %r14			//left - right
		jg    while3
		movq  %rdi, %rsi		# %rsi = %rdi			//%rsi = *base
		movq  %r15, %rdi		# %rdi = %r15			//%rdi = *left
		call  *%rcx
		testl %eax,   %eax
		jg    fim_while2
		addq  %rbp, %r15		# %r15 = %r15 + %rdx	//left+=width
		movq  %r12, %rdi		# %rdi = %r12
		jmp   while2
		
	fim_while2:
		movq %r12, %rdi		# %rdi = %r12
		
	while3:
		cmpq  %r15, %r14		# %r14 - %r15			//right-left
		jl    if
		movq  %rdi, %rsi		# %rsi = %rdi			//%rsi = *base
		movq  %r14, %rdi		# %rdi = %r14			//%rdi = *right
		call  *%rcx
		testl %eax,   %eax
		js    if
		subq  %rdx, %r14		# %r14 = %r14 - %rdx	//right-=width
		movq  %r12, %rdi		# %rdi = %r12
		jmp   while3
	
	if:	
		cmpq %r15, %r14		# %r14 - %r15		//right-left
		jl   fim_while1
		
	movq %r15, %rdi		# %rdi = %r15		//%rdi= *left
	movq %r14, %rsi		# %rsi = %r14		//%rsi= *right
	call memswap
	movq %rbp, %rdx		# %rdx = %rbp		//%rdx= width
	jmp while1
	
fim_while1:

/*===============recursividade============================*/
movq %r12, %rdi		# %rdi = %r12			//%rdi= *base
movq %r14, %rsi		# %rsi = %r14			//%rsi= *right
call memswap
movq %r12, %rdi		# %rdi = %r12			//%rdi= *base
cmpq %rdi, %r14		# %r14 - %rdi			//right-base
jle  secondIf
movq %r14, %rax		# %rax = %r14			//%rax=right
subq %rdi, %rax		# %rax = %rax - %rdi	//right-base
movq $0,   %rdx	
div  %rbp
movq %rax, %rsi		# %rsi = %rax			//%rsi = (right-base)/width
movq %rbp, %rdx		# %rdx = %rbp			//%rdx = width
movq %r13, %rcx		# %rcx = %r13			//%rcx = compar
call quick_sort

secondIf:
	cmpq %r10, %r14		# %r14 - %r10				//right-last
	jge return
	movq %r14, %rdi		# %rdi = %r14				//%rdi=*right
	addq %rbp, %rdi		# %rdi = %rdi + %rbp		//%rdi=right+width
	movq %r10, %rax		# %rax = %r10				//%rax=*last
	subq %r14, %rax		# %rax = %rax - %r14		//%rax=last-right
	movq $0,   %rdx
	div  %rbp
	movq %rax, %rsi		# %rsi = %rax				//%rsi=(last-right)/width
	movq %rbp, %rdx		# %rdx = %rbp				//%rdx=width
	movq %r13, %rcx		# %rcx = %r13				//%rcx=compar
	call quick_sort
	
return:
	pop  %rbp			# restore previous value in %rbp
	pop  %r12			# restore previous value in %r12
	pop  %r13			# restore previous value in %r13
	pop  %r14			# restore previous value in %r14
	pop  %r15			# restore previous value in %r15
	ret
	
	
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
	movq  %rsp,      %rbp
	pushq %r13
	pushq %r12
	pushq %rbx
	
	mov   %rdi,      %r13
	mov   %rsi,      %r12
	mov   %rdx,		 %rbx
	
	/*=========colocar o %rsp num endereço multiplo de 16===========*/
	subq  $24,       %rsp
	leaq  15(%rdx),  %rax
	andq  $-16,      %rax
	subq  %rax,      %rsp      #localiza o tmp
	
	/*=========memcpy(tmp,one,size)===============*/
	movq  %rsp,      %rdi      #tmp
	movq  %r13,		 %rsi	   #one
	call  memcpy			   #%rdx = size
	
	/*=========memcpy(one,other,size)===============*/
	movq  %r13,		 %rdi
	movq  %r12,		 %rsi
	movq  %rbx,		 %rdx
	call memcpy
	
	/*=========memcpy(other,tmp,size)===============*/
	movq  %r12,		 %rdi
	movq  %rsp,		 %rsi
	movq  %rbx,      %rdx
	call memcpy
	
	/*=========discarta o espaço local, pops e retorna===============*/
	leaq  -24(%rbp), %rsp
	popq  %rbx
	popq  %r12
	popq  %r13
	popq  %rbp
	ret
