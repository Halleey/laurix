[BITS 16]
[ORG 0x7C00]

KERNEL_LOCATION equ 0x1000
DATA_SEG equ 0x10
CODE_SEG equ 0x08

mov [BOOT_DISK], dl

xor ax, ax
mov ds, ax
mov es, ax

mov bp, 0x8000
mov sp, bp

in al, 0x92
or al, 00000010b
out 0x92, al

load_kernel:
    mov ah, 0x02
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    xor bx, bx
    mov es, bx
    mov bx, KERNEL_LOCATION
    int 0x13

    jc fail

    mov ah, 0x0
    mov al, 0x3
    int 0x10    

cli
lgdt [gdt_descriptor]

; ENTRAR EM PROTECTED MODE

mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:protected_mode_entry

gdt_start:

    gdt_null:
        dq 0

    ; SEGMENTO DE CÓDIGO
    ; Código executável, 32-bit, base 0, limite 4GB

    gdt_code:
        dw 0xFFFF              ; Limite baixo
        dw 0x0000              ; Base baixa
        db 0x00                ; Base média
        db 10011010b           ; Código executável, presente
        db 11001111b           ; 32-bit, granularidade 4KB
        db 0x00                ; Base alta

    ; Segmento para os dados
    ; Dados e pilha, leitura/escrita

    gdt_data:
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 10010010b           ; Dados RW
        db 11001111b
        db 0x00

gdt_end:


gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Tamanho da GDT
    dd gdt_start               ; Endereço da GDT

; Protected mode (32 bits)

[BITS 32]

protected_mode_entry:

    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_LOCATION

fail:
    mov ah, 0x0e
    mov al, '1'
    int 0x10
    jmp $

times 510 - ($-$$) db 0
db 0x55, 0xaa