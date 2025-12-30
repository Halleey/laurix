[BITS 16]
[ORG 0x7C00]

start:
    in al, 0x92            ; Lê o controlador rápido do A20
    or al, 00000010b       ; Liga o bit do A20
    out 0x92, al           ; Envia de volta → A20 habilitado

; CARREGAR GDT
; Informa à CPU onde está a tabela de segmentos

    cli                   ; Desliga interrupções para evitar interferência do BIOS
    lgdt [gdt_descriptor] ; Carrega o endereço e tamanho da GDT

; ENTRAR EM PROTECTED MODE

    mov eax, cr0           ; Lê o registrador de controle CR0
    or eax, 1              ; Liga o bit PE (Protected Enable)
    mov cr0, eax           ; Protected mode ativado

; Atualiza o CS e limpa o pipeline da CPU

    jmp CODE_SEG:protected_mode_entry


; GDT (Global Descriptor Table)

gdt_start:

    gdt_null:
        dq 0                   ; Segmento nulo obrigatório

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


CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


; Protected mode (32 bits)

[BITS 32]

protected_mode_entry:

    mov ax, DATA_SEG       ; Carrega o seletor de dados
    mov ds, ax             ; Segmento de dados
    mov es, ax             ; Segmento extra
    mov fs, ax             ; Segmento FS
    mov gs, ax             ; Segmento GS
    mov ss, ax             ; Segmento da pilha

    mov esp, 0x90000
    mov esp, ebp

times 510 - ($ - $$) db 0
dw 0xAA55