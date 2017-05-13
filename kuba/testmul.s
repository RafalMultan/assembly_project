
.data
	number1: .space 12
	number2: .space 12
	result: .space 24
	size: .space 4
.text
.globl main
main:

	pushl %ebp
	movl %esp, %ebp

	movl $1, %eax
	movl %eax, size
	pushl $result
	pushl $number2
	pushl $number1
	pushl $size
	call multiply

	movl %ebp, %esp
	popl %ebp	
ret
