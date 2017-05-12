all:runme clean

runme: proj2.o mul_inv.o wild_n.o
	ld -m elf_i386 proj2.o mul_inv.o wild_n.o -o runme

proj2.o: proj2.s
	as -g -ggdb --32 proj2.s -o proj2.o

mul_inv.o:
	as -g -ggdb --32 mul_inv.s -o mul_inv.o

wild_n.o:	generate_wild_n.s
	as -g -ggdb --32 generate_wild_n.s -o wild_n.o

clean: 
	rm -rf *.o