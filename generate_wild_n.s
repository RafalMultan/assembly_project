.data
r:.space 4
r_inv:.space 4
n:.space 4
n_semicolon:.space 4
return:.space 4
.text
.global wild_n
.type wild_n, @function
wild_n:
	popl %eax
	movl %eax,return
	popl %eax
	movl %eax, r
	popl %eax
	movl %eax, n
	pushl r
	movl n, %ebx
	xor %eax,%eax
	subl %ebx, %eax
	pushl %eax
	call mulinv
end_wild_n:
	pushl return
	ret

