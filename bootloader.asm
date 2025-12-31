[BITS 16]
[ORG 0x7C00]

KERNEL_LOCATION equ 0x1000
DATA_SEG equ 0x10
CODE_SEG equ 0x08

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

; HABILITA A20
    in al, 0x92
    or al, 00000010b
    out 0x92, al

; leitura do kernel via LBA, modelo antigo não estava interoperando corretamente com o linker
load_kernel:
    mov si, dap
    mov ah, 0x42          ; LBA read
    int 0x13
    jc fail

; SETUP GDT
    cli
    lgdt [gdt_descriptor]

; ENTRA EM PROTECTED MODE
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp CODE_SEG:protected_mode_entry

; GDT
gdt_start:
    dq 0

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; DISK ADDRESS PACKET (DAP)
dap:
    db 0x10        ; size
    db 0
    dw 1           ; setores a ler (kernel.bin = 1 setor)
    dw KERNEL_LOCATION
    dw 0x0000
    dq 1           ; LBA = setor 1 (logo após o bootloader)

; PROTECTED MODE
[BITS 32]
protected_mode_entry:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000
    jmp KERNEL_LOCATION

; caso de erro vai imprimir 1 na tela
[BITS 16]
fail:
    mov ah, 0x0E
    mov al, '1'
    int 0x10
    jmp $

; BOOT SIGNATURE
times 510 - ($ - $$) db 0
dw 0xAA55
