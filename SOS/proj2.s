.code32
.align 32
.data

t: .space 12 #tablica na wynik 2*size(a)+1
C: .space 1 #przeniesienie
S: .space 1 #suma czesciowa
n:.space 4
m:.space 1 #changed to 1 byte from 4
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
a: .int 100 #liczba a
b: .int 100 #liczba b

.text
.global _start
_start:
	movl $256,W
	movl $127, n
	movl $128, r
	pushl n
	pushl r
	call mulinv
	movl %eax, r_inv
	
	pushl n
	pushl r

	call wild_n
	movl %eax, n_semicolon
	xor %esi, %esi
	
	movl $2, %eax #w bajtach dlugosc tabeli
	movl %eax, length

	
	
step_1:
ab_prod:
	xor %edi, %edi
	xor %esi, %esi
	movl length, %ecx
outer_loop:	#for(esi=0;esi<length;esi++)
		#{C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movb $0, C
inner_loop:
	xor %edx,%edx
	movb b(,%esi,1), %bl
	movb a(,%edi,1), %al
	mulb %bl
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
	xor %esi, %esi

step_2:
outer_loop_2:	#for(esi=0;esi<length;esi++){C=0;for(edi=0;edi<length;edi++{zrob mnozenie}}
	xor %edi, %edi
	movb $0, C
	movb t(,%esi,1), %al
	movb n_semicolon, %bl #first byte
	mulb %bl
	movl W, %ebx
	divl %ebx
	movb %dl, m
inner_loop_2:
	xor %eax, %eax
	xor %ebx, %ebx
	movb n(,%edi,1), %bl
	movb m, %al
	mulb %bl
	addb C, %al
	adcb $0, %ah
	addb t(%esi,%edi,1), %al
	adcb $0, %ah
	movb %ah, C
	#movb %al, S
	movb %al, t(%esi,%edi,1)
	clc
	incl %edi
	cmpl length, %edi
	jl inner_loop_2
	
	xor %edx,%edx


	movl %esi, tmp
#ADD
add_carry:
	cmpb $0, %ah #if carry 0 exit add_carry
	je continue_loop_outter
	
	movl length, %ecx
	movb %ah, %al
	xor %ah, %ah
	addb %al, t(%ecx,%esi,1)
	adcb $0, %ah
	incl %esi
	jmp add_carry	

continue_loop_outter:
	movl tmp, %esi
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

	adcb $0, %ah
	subb B, %al
	adcb $0, %ah
	movb %ah, B

	movb %al, t(,%esi,1)
	cmpl %esi, %ecx
	jl last_loop

	xor %eax, %eax
	xor %ebx, %ebx

	movl length, %ecx
	movb u(,%ecx,1), %al
	subb B, %al
	adcb $0, %ah
	movb %ah, B

	movb %al, t(,%ecx,1)

	movb B, %al
	xor %esi, %esi

	cmpb $0,%al
	jne return_u

	jmp return_t
	
return_t:
	movb t(,%esi,1),%al
	movb %al, final_result(,%esi,1)
	incl %esi
	cmpl length, %esi
	jle return_t
	jmp end	


return_u:
	movb u(,%esi,1),%al
	movb %al, final_result(,%esi,1)
	incl %esi
	cmpl length, %esi
	jle return_u
	jmp end

end:
	movl $1, %eax
	int $0x80
