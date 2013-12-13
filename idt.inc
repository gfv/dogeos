idt_handlers:
rept 0xff ctr:0 {
.i#ctr:
  cli
  mov ax, ctr
  cmp al, 0x0a
  sbb al, 0x69
  das
  mov [0xb8002], al
  mov [0xb8003], byte 0x0c
  
  mov ax, ctr
  shr al, 4
  cmp al, 0x0a
  sbb al, 0x69
  das
  
  mov [0xb8000], al
  mov [0xb8001], byte 0x0c
  sti
  iret
}


align 16
idt:
rept 0xff ctr:0 {
  dw (idt_handlers.i#ctr and 0xffff)
  dw 0x8
  db 0
  db 0x8e
  dw (idt_handlers.i#ctr shr 0x10)
}
idt_length = $ - idt
