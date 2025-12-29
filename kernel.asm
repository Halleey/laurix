BITS 16
org 0x7e00

lau_main:
    mov ah, 0x0e
    mov al, 'V'
    int 0x10

halt:
    jmp halt