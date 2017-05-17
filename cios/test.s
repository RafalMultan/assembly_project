.text
.globl main
main:
	
	xor %eax, %eax
	xor %edx, %edx
	
	movb $255, %al
	movb $255, %dl
	addb %dl, %al
	adcb $0, %al	

ret
