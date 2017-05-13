
#f_n_prim(r, n)

.data
r:.space 4
r_inv:.space 4
n:.space 4
n_prim:.space 4
.text
.global f_n_prim
.type f_n_prim, @function
f_n_prim:

	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax #grab r from stack
	movl %eax, r
	
	movl 12(%ebp), %eax #grab n from stack
	movl %eax, n

	movl n, %ebx
	xor %eax, %eax
	subl %ebx, %eax

	pushl %eax
	pushl r
	call f_mul_inv

	movl %ebp, %esp
	popl %ebp

ret


