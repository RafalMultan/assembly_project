.section .data
	b0: .space 4
	t: .space 4
	q: .space 4
	x0: .space 4
	x1: .space 4	
	a: .space 4
	b: .space 4
	return: .space 4

.section .text

.global mulinv
.type mulinv, @function
mulinv:

	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax #grab a from stack
	movl %eax, a

	movl 12(%ebp), %eax #grab b
	movl %eax, b
	movl %eax, b0
		
	
	xor %eax, %eax
	mov %eax, x0
	incl %eax
	mov %eax, x1

	cmp $1, b
	je return1
	
div_loop:	#while a>1
	
	
	cmp $1, a
	jbe end_loop
	
	#clear eax, edx for divide
	xor %eax, %eax
	xor %edx, %edx
	

	mov a, %eax
	cdq #??? y tho
	mov b, %ebx
	idiv %ebx
	mov %eax, q
	
	mov b, %edi
	mov %edi, t
	mov %edx, b
	mov t, %edi
	mov %edi, a

	mov x0, %edi
	mov %edi, t
	mov q, %eax
	mov x0, %edx
	imull %edx, %eax
	mov x1, %edx
	sub %eax, %edx
	mov %edx, x0
	mov t, %edi 
	mov %edi, x1	

	jmp div_loop

end_loop:
	xor %eax, %eax
	cmp x1, %eax
	jg add_x1b0
	jmp end_mulinv


return1:
	mov $1, %eax
	jmp end_mulinv

add_x1b0:
	mov x1, %eax
	add b0, %eax
	mov %eax,b0
	mov b0, %eax
	mov %eax, x1
	jmp end_mulinv

end_mulinv:
	mov x1, %eax
	movl %ebp, %esp,
	popl %ebp

ret
	

