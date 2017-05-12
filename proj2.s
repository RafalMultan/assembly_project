.code32
.align 32
.data
a: .space 4 #liczba a
b: .space 4 #liczba b
t: .space 12 #tablica na wynik
C: .space 4 #przeniesienie
S: .space 4 #suma czesciowa
n:.space 4
m:.space 4
u:.space 8
final_result:.space 4
n_semicolon:.space 4
r:.space 4
r_inv:.space 4
length:.space 4
tmp: .space 4
W:.space 4
B:.space 4
save_esi:.space 4
D:.space 4
.text


.global _start
_start:
	movl $2,W
	movl $31,n
	movl $8, r
	pushl n
	pushl r
	call mulinv
	movl %eax, r_inv
	pushl n
	pushl r
	call wild_n
	movl %eax, n_semicolon
	xor %esi, %esi
	movl $0x3, %eax
	movl %eax, a(,%esi,1)
	movl $0x4, %eax
	movl %eax, b(,%esi,1)
	movl $1, %eax #o jeden mniej niz jest dlugosc tabeli
	movl %eax, length(,%esi,4)

	
	
step_1:
ab_prod:
	xor %edi, %edi
	xor %esi, %esi
	movl length, %ecx
outer_loop:	#for(esi=0;esi<length;esi++){C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movl $0, C(,%edi,4)
inner_loop:
	movl b(,%esi,4), %ebx
	movl %esi,tmp
	imull $4,%esi #mnozenie esi zeby sie adres zgadzal do offsetu w adresowaniu pozniej
	movl a(,%edi,4), %eax
	imull %ebx
	addl C, %eax
	adcl $0, %edx
	addl t(%esi,%edi,4), %eax
	adcl $0, %edx
	movl %edx, C
	movl %eax, S
	movl S, %eax
	movl %eax, t(%esi,%edi,4)
	movl C, %eax
	movl %eax, t(%esi,%ecx,4)
	movl tmp, %esi #przwrocenie esi do wlasciwej wartosci
	incl %edi
	cmpl length, %edi
	jl inner_loop
	incl %esi
	cmpl length, %esi 
	jl outer_loop

step_2:
outer_loop_2:	#for(esi=0;esi<length;esi++){C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movl $0, C(,%edi,4)
	movl t(%esi), %eax
	movl n_semicolon, %ebx
	imull %ebx
	movl W, %ebx
	idivl %ebx
	movl %edx, m
inner_loop_2:
	movl n(%edi), %ebx
	movl %esi,tmp
	imull $4,%esi #mnozenie esi zeby sie adres zgadzal do offsetu w adresowaniu pozniej
	movl m, %eax
	imull %ebx
	addl C, %eax
	adcl $0, %edx
	addl t(%esi,%edi,4), %eax
	adcl $0, %edx
	movl %edx, C
	movl %eax, S
	movl S, %eax
	movl %eax, t(%esi,%edi,4)
	clc
	xor %edx,%edx
add_carry:
	cmpb $0,%dl
	jne set_carry
carry_set:
	movl t(%esi,%ecx,4),%eax
	adcl C, %eax
	setcb %dl
	movl %eax, t(%esi,%ecx,4)
	addl $4, %esi
	cmpb $0,%dl	
	jne add_carry

	movl tmp, %esi #przwrocenie esi do wlasciwej wartosci
	incl %edi
	cmpl length, %edi
	jl inner_loop_2
	incl %esi
	cmpl length, %esi 
	jl outer_loop_2

	movl length, %eax
	imull $4,%eax
	movl %eax, %ecx
	xor %esi, %esi
shift:
	movl t(%ecx,%esi,4),%eax
	movl %eax, u(%esi)
	incl %esi
	cmpl %ecx, %esi
	jl shift

step_3:
	xor %esi, %esi
	movl length, %ecx
	movl $0, B
last_loop:
	movl u(%esi), %eax
	movl n(%esi), %ebx
	subl %ebx, %eax
	movl b, %edx
	adcl $0, %edx
	movl %edx, B
	subl B, %eax
	movl %eax, D(%esi)
	xor %ebx, %ebx
	movl %ebx, B
	adcl $0,%ebx
	movl u(%ecx), %eax
	subl B, %eax
	movl %eax,D(%esi)
	xor %edx,%edx
	sbbl $0,%edx
	movl %edx, B
	movl %eax, D
	cmpl %esi, %ecx
	jl last_loop

	movl B,%eax
	cmpl $0,%eax
	xor %esi,%esi
	jne return_u	
return_t:
	movl t(%esi),%eax
	movl %eax, final_result(%esi)
	incl %esi
	cmpl length, %esi
	jl return_t

end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
set_carry:
	stc
	jmp carry_set
return_u:
	movl u(%esi),%eax
	movl %eax, final_result(%esi)
	incl %esi
	cmpl length, %esi
	jl return_u
	jmp end
