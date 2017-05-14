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
	m: .space 1
	mn: .space 8
	
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
	addb %al, ttab(,%esi,1) 
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
	movb %dl, m	#m computed
	# loop j=0 to s
	# (C, S) =   m*n[j] + t[j] + C 
	xor %esi, %esi

loop_mn:
	cmp size, %esi
	je exit_loop_mn

	xor %ebx, %ebx #this iteration C
	movb m, %al
	imulb n(,%esi,1)
	adcb $0, %bl
	addb C, %al
	adcb $0, %bl
	addb ttab(,%esi,1), %al
	adcb $0, %bl
	movb %bl, C
	movb %al, ttab(,%esi,1)
	inc %esi

exit_loop_mn:
	movl size, %esi
	movb C, %al
	addb %al, ttab(,%esi,1)
	adcb $0, %bl
		
	addb %bl, 1+ttab(,%esi,1)
	xor %esi, %esi
	
loop_shift_right
	cmp size, %esi
	movb ttab(,%esi,1), %al
	inc %esi
	movb %al, ttab(,%esi,1)
	jmp loop_shift_right

end_outter_loop:

	#last part

#==========================
	movl %ebp, %esp
	popl %ebp
ret
