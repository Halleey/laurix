; os numeros estao em hexadecimal
[BITS 16]
[ORG 0x7C00]

call helloworld
call jump_line
jmp $ ; para travar o programa

helloworld:
    ; isso e uma funcao na BIOS para imprimir caracteres
    mov ah, 0eh ; ah -> 8 bits
    mov al, 48h ; al -> 8 bits
    int 10h ; interrupcao de video/monitor  basicamente para printar em modo BIOS / 16 bits
    ; totalizando 16 bits
    ; int de interrupt

    ;dando print
    mov al, 65h
    int 0x10 ; mesmo que o 10h
    mov al, 6ch
    int 10h
    mov al, 6ch
    int 10h
    mov al, 20h
    int 10h
    mov al, 57h
    int 10h
    mov al, 6fh
    int 10h
    mov al, 72h
    int 10h
    mov al, 6ch
    int 10h
    mov al, 64h
    int 10h
    ret

jump_line:
    mov ah, 0eh
    mov al, 0ah ; equivalente ao \n
    int 10h
    mov al, 0dh ; voltar para primeira coluna, equivalente a 13 na ascii table
    int 10h
    ret



times 510 - ($-$$) db 0
dw 0xAA55