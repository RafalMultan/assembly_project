.code32
.align 32
.data

t: .space  #tablica na wynik 2*size(a)+1
C: .space 1 #przeniesienie
S: .space 1 #suma czesciowa
n:.space 4
m:.space 4
u:.space 8
final_result:.space 8
n_semicolon:.space 4
r:.space 4
r_inv:.space 4
length:.space 4
tmp: .space 4
W:.space 4
B:.space 4
save_esi:.space 4
D:.space 4
a: .long 0x00034525 #liczba a
b: .long 0x00074615 #liczba b
.text


.global _start
_start:
	movl $256,W
	movl $476701,n
	movl $524288, r
	pushl n
	pushl r
	call mulinv
	movl %eax, r_inv
	pushl n
	
	pushl r
	call wild_n
	movl %eax, n_semicolon
	xor %esi, %esi
	
	movl $3, %eax #w bajtach dlugosc tabeli
	movl %eax, length(,%esi,4)

	
	
step_1:
ab_prod:
	xor %edi, %edi
	xor %esi, %esi
	movl length, %ecx
outer_loop:	#for(esi=0;esi<length;esi++){C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movb $0, C(,%edi,1)
inner_loop:
	xor %edx,%edx
	movb b(,%esi,1), %bl
	movb a(,%edi,1), %al
	imulb %bl
	addb C, %al
	adcb $0, %ah
	addb t(%esi,%edi,1), %al
	adcb $0, %ah
	movb %ah, C
	movb %al, S
	movb S, %al
	movb %al, t(%esi,%edi,1)
	movb C, %al
	movb %al, t(%esi,%ecx,1)
	incl %edi
	cmpl length, %edi
	jl inner_loop
	incl %esi
	cmpl length, %esi 
	jl outer_loop

step_2:
outer_loop_2:	#for(esi=0;esi<length;esi++){C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movb $0, C(,%edi,1)
	movb t(,%esi,1), %al
	movb n_semicolon, %bl
	imulb %bl
	movl W, %ebx
	idivl %ebx
	movb %ah, m
inner_loop_2:
	movl %esi,tmp
	movb n(,%edi,1), %bl
	movb m, %bl
	imulb %bl
	addb C, %ah
	adcb $0, %ah
	addb t(%esi,%edi,1), %al
	adcb $0, %ah
	movb %ah, C
	movb %al, S
	movb S, %al
	movb %al, t(%esi,%edi,1)
	clc
	xor %edx,%edx
add_carry:
	cmpb $0,%ah
	jne set_carry

carry_set:
	movb t(%esi,%ecx,1),%al
	adcb C, %al
	setcb %ah
	movb %al, t(%esi,%ecx,1)
	incl %esi
	cmpb $0,%ah	
	jne add_carry

	movl tmp, %esi #przwrocenie esi do wlasciwej wartosci
	incl %edi
	cmpl length, %edi
	jl inner_loop_2
	incl %esi
	cmpl length, %esi 
	jl outer_loop_2

	movl length, %ecx
	xor %esi, %esi
shift:
	movb t(%ecx,%esi,1),%al
	movb %al, u(,%esi,1)
	incl %esi
	cmpl %ecx, %esi
	jl shift

step_3:
	xor %esi, %esi
	movl length, %ecx
	movl $0, B
last_loop:
	movb u(,%esi,1), %al
	movb n(,%esi,1), %bl
	subb %bl, %al
	movb b, %ah
	adcb $0, %ah
	movb %ah, B
	subb B, %al
	movb %al, D(,%esi,1)
	xor %ebx, %ebx
	movb %bl, B
	adcb $0,%bl
	movb u(,%ecx,1), %al
	subb B, %al
	xor %edx,%edx
	sbbb $0,%ah
	movb %ah, B
	movb %al, D
	cmpl %esi, %ecx
	jl last_loop

	movl B,%eax
	cmpl $0,%eax
	xor %esi,%esi
	jne return_u	
return_t:
	movb t(,%esi,1),%al
	movb %al, final_result(,%esi,1)
	incl %esi
	cmpl length, %esi
	jle return_t

end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
set_carry:
	stc
	jmp carry_set
return_u:
	movb u(,%esi,1),%al
	movb %al, final_result(,%esi,1)
	incl %esi
	cmpl length, %esi
	jle return_u
	jmp end
