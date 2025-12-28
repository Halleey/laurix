[BITS 16]                 ; Diz ao assembler que este código roda em 16 bits (real mode)
[ORG 0x7C00]              ; Endereço onde o BIOS carrega o bootloader

start:
    cli                   ; Desliga interrupções para evitar interferência do BIOS

    xor ax, ax             ; Zera o registrador AX
    mov ds, ax             ; Segmento de dados = 0
    mov es, ax             ; Segmento extra = 0
    mov ss, ax             ; Segmento da pilha = 0
    mov sp, 0x7A00         ; Define a pilha um pouco abaixo do bootloader

; HABILITAR A20
; Permite acessar memória acima de 1MB (necessário no protected mode)

    in al, 0x92            ; Lê o controlador rápido do A20
    or al, 00000010b       ; Liga o bit do A20
    out 0x92, al           ; Envia de volta → A20 habilitado

; CARREGAR GDT
; Informa à CPU onde está a tabela de segmentos

    lgdt [gdt_descriptor] ; Carrega o endereço e tamanho da GDT

; ENTRAR EM PROTECTED MODE

    mov eax, cr0           ; Lê o registrador de controle CR0
    or eax, 1              ; Liga o bit PE (Protected Enable)
    mov cr0, eax           ; Protected mode ativado

; FAR JUMP 
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

; DESCRITOR DA GDT
; Estrutura que o lgdt usa
;(lgdt) Load Global Descriptor Table
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Tamanho da GDT
    dd gdt_start               ; Endereço da GDT

; SELETORES DE SEGMENTO
; Offset dos descritores dentro da GDT

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
    mov esp, 0x90000       ; Pilha 32-bit limpa

; escrever na vga(memoria de vídeo)
; Memória de vídeo em modo texto começa em 0xB8000

    xor edi, edi           ; Limpa EDI
    mov edi, 0xB8000       ; Aponta para a VGA
    mov ax, 0x2F5A
    stosw
    mov ax, 0x2F41         ; 'A' branco com fundo verde, 0X2f atributo para cor, enquanto F41 é A na tabela ASCII
    stosw                  ; Escreve 2 bytes na tela
    mov ax, 0x2F52
    stosw
    mov ax, 0x2F44
    stosw
    ;isso acima vai escrever Zard basicamente.


; loop final 
; Mantém o kernel rodando sem cair em memória inválida

hang:
    jmp hang

; assinatura do boot

times 510 - ($ - $$) db 0  ; Preenche até 512 bytes
dw 0xAA55                  ; Assinatura obrigatória do bootloader
