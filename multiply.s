# multiply(1byteSize, number1address, number2address, resultAddress)
# addresses are 8 bytes long
.data
	size: .space 1
	n1: .space 8
	n2: .space 8
	r: .space 8

.text
.globl multiply
.type multiply @function
multiply:
	
	pushl %ebp
	movl %esp, %ebp


	subl $4, %esp

	movl 8(%ebp), %esp
	movl $4, %eax
	movl %eax, 4(%esp)

	movl %ebp, %esp
	popl %ebp
ret
