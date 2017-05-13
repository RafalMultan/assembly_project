.data
	size: .space 4
	C: .space 1
	atab: .space 12
	btab: .space 12
	ttab: .space 24
	S: .space 1
	
.text
.globl main
main:

	pushl %ebp
	movl %esp, %ebp
#==========================	
	
	
	xor %edi, %edi	#i = 0
	xor %esi, %esi	#j = 0

	
outtr_loop:
	cmp size, %edi
	je end_outer_loop
	
	xor %eax, %eax
	movl %eax, C #C = 0
	xor %esi, %esi
inner_loop:
	cmp size, %esi
	je outter_loop
	
	xor %eax, %eax
	xor %ebx, %ebx

	movb atab(,%esi,1), %bl
	movb btab(,%edi,1), %al
	
	imulb %bl
	addb C, %al
	abcd $0, %dl
	addb ttab(,%esi,1), #zrobić wynik do c, wszystko ponad do C



#==========================
	movl %ebp, %esp
	popl %ebp
ret
