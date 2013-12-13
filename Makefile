all: kernel

kernel: boot.o work.o
	ld -m elf_i386 -T linker.ld -o kernel boot.o work.o

boot.o: boot.asm idt.inc
	fasm boot.asm

work.o: work.c
	gcc work.c -c -m32 -o work.o -std=c99 -ffreestanding

clean:
	rm *.o; rm kernel

test: all
	qemu-system-i386 -kernel kernel
