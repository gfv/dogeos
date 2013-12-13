format ELF
use32

MB_MAGIC equ 0x1badb002
MB_FLAGS equ 0x03
videomem equ 0xb8000

public _start
extrn 'memcpy' as memcpy
extrn 'memmove' as memmove
extrn 'write_string' as write_string
extrn 'write_char' as write_char
extrn 'clear_screen' as clear_screen
extrn 'set_cursor' as set_cursor

macro log msg {
  local J
  call J
  db msg, 0x00
J:
  call write_string
  add esp, 4
}

section '.multiboot' executable align 4
	align 4
	dd MB_MAGIC
	dd MB_FLAGS
	dd -MB_MAGIC - MB_FLAGS

section '.text' executable align 4
_start:
        mov esp, stack_ptr + 16384
        lgdt [gdt_descriptor]
        mov ax, 0x10
        mov ds, ax
        jmp 0x08:.set_idt
.set_idt:
        lidt [idt_descriptor]
        sti
        call clear_screen        
; this is real now!
        log <"flight operating normally", 0x0a>

        mov ecx, doge_size
        mov esi, doge
        mov edi, 0xb8000
        mov ebx, 80
.doge_loop:
        ;         wow
        ; such loop
        ;                much doge
        lodsb
        cmp al, 0x0a
        je .next_line
        stosb
        mov al, 0x0f
        stosb
        dec ebx
        loop .doge_loop
        jmp hang
.next_line:
        shl ebx, 1
        add edi, ebx
        mov ebx, 80
        loop .doge_loop
        
        push 24
        push 0
        call set_cursor
        add esp, 8
; and now for something completely different
        mov eax, cr4
        or eax, (1b shl 5) ; enabling PAE
        mov cr4, eax

hang:
        log "nothing left to do, halting :("
        call write_string
        add esp, 4
	cli
        hlt
        jmp $

section '.trampoline64' executable align 4

        
section '.bootstack' writeable align 4
stack_ptr:  rb 16384


section '.idt' align 16
org 0x110000
include 'idt.inc'

gdt:
  dq 0x00
.code_seg:
  dw 0xffff
  dw 0x0000
  db 0x00
  db 10011010b ; +pr priv=0 +ex -dc +rw -ac
  db 11001111b ; +gr +sz lim[16:19]=0xf
  db 0x00
.data_seg:
  dw 0xffff
  dw 0x0000
  db 0x00
  db 10010010b ; +pr priv=0 -ex +dc +rw -ac
  db 11001111b ; +gr +sz lim[16:19]=0xf
  db 0x00
gdt_length = $ - gdt
  


section '.data' writeable align 16
section '.rodata' align 16
        error_msg db "exception: "
        nothing_left db "nothing to do, halting", 0x00

idt_descriptor:        
        .limit:   dw idt_length
        .base:    dd idt

gdt_descriptor:
        .limit:   dw gdt_length
        .base:    dd gdt

doge:
file 'doge.bin'
doge_size = $ - doge       
