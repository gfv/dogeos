ENTRY(_start)
SECTIONS
{
	. = 1M;
	.text : ALIGN(4K)
	{
		boot.o(.multiboot)
		*(.text)
	}

	. = 0x110000;
	.idt : ALIGN(4K) { boot.o(.idt) }

	.data : ALIGN(4K) { *(.data) }
	.bss : ALIGN(4K)
	{
		*(.bss)
		*(.bootstack)
	}
}

/* ld -m elf_i386 -Ttext=0x100000 --section-start=boot=0x120000 --section-start=stack=0x80000 -o kernel boot.o */
