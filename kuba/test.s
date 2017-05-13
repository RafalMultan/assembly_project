.text
.globl main
main:
	pushl %ebp
	movl %esp, %ebp

	pushl $7
	pushl $13
	call f_n_prim	

	movl %ebp, %esp
	popl %ebp
ret
