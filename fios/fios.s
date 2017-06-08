.data
	final_result: .space 12
	t: .space 12
	u: .space 8
	B: .space 4
	C: .space 1
	S: .space 1
	m: .space 1
	a: .int 100
	b: .int 100
	length: .int 2
	W: .int 256
	n: .int 255
	r: .int 256
	n_prim: .space 4

.text
.globl main
main:

	pushl r
	pushl n
	call f_n_prim
	movl %eax, n_prim
	addl $8, %esp

	xor %edi, %edi
	xor %esi, %esi


outter_loop:
	xor %eax, %eax

	movb a, %al
	mulb b(,%esi,1)
	addb t, %al
	adcb $0, %ah
	movb %al, S
	movb %ah, C

	movl $1, %edi
ADD:
	cmpb $0, %ah
	je ADD_end
	adcb %ah, t(,%edi,1)
	xor %ah, %ah
	adcb $0, %ah
	incl %edi
	jmp ADD

ADD_end:
	
	# calculate m
	xor %eax, %eax
	xor %edx, %edx
	movb n_prim, %al
	mulb S
	divl W
	movb %dl, m

	xor %eax, %eax
	movb m, %al
	mulb n
	addb S, %al
	adcb $0, %ah
	movb %al, S
	movb %ah, C

	movl $1, %edi
	inner_loop:
		xor %eax, %eax
		movb a(,%edi,1), %al
		mulb b(,%esi,1)
		addb C, %al
		adcb $0, %ah
		addb t(,%edi,1), %al
		adcb $0, %ah
		movb %al, S
		movb %ah, C

		movl %edi, %edx
		addl $1, %edx
		in_ADD:
			cmpb $0, %ah
			je in_ADD_end
			addb %ah, t(,%edx,1)
			xor %ah, %ah
			adcb $0, %ah
			incl %edx
			jmp in_ADD

		in_ADD_end:
			xor %eax, %eax
			movb m, %al
			mulb n(,%edi,1)
			addb S, %al
			adcb $0, %ah
			movb %al, S
			movb %ah, C

			movl %edi, %edx
			subl $1, %edx
			movb %al, t(,%edx,1)

			incl %edi
			cmpl length, %edi
			jl inner_loop 

	inner_loop_end:
		movl length, %edx
		xor %eax, %eax
		movb t(,%edx,1), %al
		addb C, %al
		adcb $0, %ah
		movb %al, S
		movb %ah, C

		decl %edx
		movb %al, t(,%edx,1)
		
		incl %edx
		incl %edx
		xor %eax, %eax
		movb t(,%edx,1), %al
		addb C, %al
		decl %edx
		movb %al, t(,%edx,1)
		xor %eax, %eax
		incl %edx
		movb %al, t(,%edx,1)

		incl %esi
		cmp length, %esi
		jl outter_loop



end:
	ret
