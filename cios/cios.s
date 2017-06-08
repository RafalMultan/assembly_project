.data
	size: .space 4
	C: .space 1
	S: .space 1
	m: .space 1
	r: .space 4 
	n_prim: .space 4
	r_inv: .space 4
	length: .int 2
	final_result: .space 8
	W: .int 256
	n: .int 255
	a: .int 10
	b: .int 10
	


.text
.globl main
main:

	pushl %ebp
	movl %esp, %ebp
#==========================		
	
	# calculate n'

	pushl r
	pushl n
	call f_n_prim
	movl %eax, n_prim
	addl $8, %esp	#remove nrrn from stack
	
	xor %edi, %edi	#i = 0
	xor %esi, %esi	#j = 0

	
outter_loop:
	cmp size, %edi
	je end_outter_loop
	
	xor %eax, %eax
	movb %al, C #C = 0
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
	
	movb %ah, %bl	#add carry from imul
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
	# m = t[0]*n'[0] mod W
	
	xor %ebx, %ebx
	xor %eax, %eax
	movb n_prim, %al
	movb ttab(,%ebx,1), %bl
	imulb %bl
	idivl W
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
	movb %ah, %bl
	addb C, %al
	adcb $0, %bl
	addb ttab(,%esi,1), %al
	adcb $0, %bl
	movb %bl, C
	movb %al, ttab(,%esi,1)
	inc %esi
	jmp loop_mn

exit_loop_mn:
	movl size, %esi
	movb C, %al
	addb %al, ttab(,%esi,1)
	adcb $0, %bl
		
	addb %bl, 1+ttab(,%esi,1)
	xor %esi, %esi
	xor %eax, %eax
loop_shift_right:
	cmp size, %esi
	jg exit_shift_right ###### is it working
	movb 1+ttab(,%esi,1), %al
	movb %al, ttab(,%esi,1)
	inc %esi
	jmp loop_shift_right

exit_shift_right:
	incl %edi
	jmp outter_loop	

end_outter_loop:

	#calculate new m
	xor %eax, %eax
	movb n_prim, %al
	xor %esi, %esi
	movb ttab(,%esi,1), %bl
	imulb %bl
	xor %edx, %edx
	idivl W
	movl %edx, m

	xor %ebx, %ebx

	movl m, %eax
	imulb n
	adcb $0, %bl
	addb ttab(,%esi,1), %al
	movb %ah, %bl
	movb %bl, C
	movb %al, S		

	movl $1, %esi
finish:
	cmp size, %esi
	je exit_finish
	xor %ebx, %ebx
	movb n(,%esi,1), %al
	imulb m
	movb %ah, %bl
	addb ttab(,%esi,1), %al
	adcb $0, %bl
	addb C, %al
	adcb $0, %bl
	movb %bl, C
	movb %al, -1+ttab(,%esi,1)
	inc %esi
	jmp finish

exit_finish:
	xor %ebx, %ebx	
	movb C, %al
	addb %al, ttab(,%esi,1)
	adcb $0, %bl
	movb ttab(,%esi,1), %al
	movb %al, -1+ttab(,%esi,1)
	movb 1+ttab(,%esi,1), %al
	addb C, %al
	movb %al, ttab(,%esi,1) 
	

#==========================
	movl %ebp, %esp
	popl %ebp
ret