.section .data
	m_b0: .space 4
	m_t: .space 4
	q: .space 4
	x0: .space 4
	x1: .space 4	
	m_a: .space 4
	m_b: .space 4
	return: .space 4

.section .text

.global mulinv
.type mulinv, @function
mulinv:

	
	popl %eax
	movl %eax, return
	popl %eax
	movl %eax,m_a
	popl %eax
	movl %eax,m_b
	mov %eax,m_b0
	
	mov $0, %eax
	mov %eax, x0
	mov $1, %eax
	mov %eax, x1

	cmp $1,m_b
	je return1
	
div_loop:	#while m_a>1
	
	
	cmp $1,m_a
	jbe end_loop
	
	#clear eax, edx for divide
	xor %eax, %eax
	xor %edx, %edx
	

	mov m_a, %eax
	cdq
	mov m_b, %ebx
	idiv %ebx
	mov %eax, q
	
	mov m_b, %edi
	mov %edi, m_t
	mov %edx,m_b
	mov m_t, %edi
	mov %edi,m_a

	mov x0, %edi
	mov %edi, m_t
	mov q, %eax
	mov x0, %edx
	imull %edx, %eax
	mov x1, %edx
	sub %eax, %edx
	mov %edx, x0
	mov m_t, %edi 
	mov %edi, x1	

	jmp div_loop

end_loop:
	mov $0, %eax
	cmp x1, %eax
	jg add_x1b0
	jmp end_mulinv


return1:
	mov $1, %eax
	jmp end_mulinv

add_x1b0:
	mov x1, %eax
	add m_b0, %eax
	mov %eax,m_b0
	mov m_b0, %eax
	mov %eax, x1
	jmp end_mulinv

end_mulinv:
	mov x1, %eax
	pushl return
	ret
	