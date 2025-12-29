[BITS 16]
[ORG 0x7C00]

mov [BOOT_DISK], dl

xor ax, ax
mov ds, ax
mov es, ax

mov bp, 0x8000
mov sp, bp

jmp load_kernel

fail:
    mov ah, 0x0e
    mov al, '1'
    int 0x10
    ret

load_kernel:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DISK]
    xor bx, bx
    mov es, bx
    mov bx, 0x7e00
    int 0x13

    jc fail

    jmp 0x7e00

halt:
    jmp halt

BOOT_DISK db 0

times 510 - ($-$$) db 0
db 0x55, 0xaa