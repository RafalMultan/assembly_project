.data
	size: .space 1
	C: .space 1
	atab: .space 4
	btab: .space 4
	ttab: .space 12
	S: .space 1
	n: .space 4
	n_prim: .space 4
	r_inv: .space 4
	r: .space 4 
	W: .space 4
	m: .space 4
	
.text
.globl main
main:

	pushl %ebp
	movl %esp, %ebp
#==========================	

	movl $17, n
	movl $32, r
	movl $256, W	

	#calculate n' and inv_r

	pushl n
	pushl r
	call f_mul_inv
	movl %eax, r_inv
	
	pushl r
	pushl n
	call f_n_prim
	movl %eax, n_prim
	addl $16, %esp	#remove nrrn from stack
	
	xor %edi, %edi	#i = 0
	xor %esi, %esi	#j = 0

	
outter_loop:
	cmp size, %edi
	je end_outter_loop
	
	xor %eax, %eax
	movl %eax, C #C = 0
	xor %esi, %esi
inner_loop:
	cmp size, %esi
	je exit_inner_loop
	
	xor %eax, %eax
	xor %ebx, %ebx

	movb atab(,%esi,1), %bl
	movb btab(,%edi,1), %al
	
	imulb %bl	#a[j]*b[i]
	xor %ebx, %ebx
	adcb $0, %bl	#add carry from imul
	addb C, %al	#add carry fr		om last iteration
	adcb $0, %bl	#add carry from ^
	addb %al, ttab(,%esi,1) #zrobić wynik do s, wszystko ponad do C
	movb %bl, C
	inc %esi
	jmp inner_loop

exit_inner_loop:
	mov size, %ebx
	movb C, %al			#(C, S) = t[s] + C
	addb %al, ttab(,%ebx,1)		
	adcb $0, 1+ttab(,%ebx,1)	#t[s+1] = S

	movb $0, %al 	#C = 0
	movb %al, C
	#m = t[0]*n'[0] mod W
	
	xor %ebx, %ebx
	xor %eax, %eax
	movb n_prim, %al
	movb ttab(,%ebx,1), %bl
	imulb %bl
	movl W, %ebx
	idivl %ebx
	movb %dl, m
	
	



end_outter_loop:

#==========================
	movl %ebp, %esp
	popl %ebp
ret
