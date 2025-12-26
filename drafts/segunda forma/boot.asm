[BITS 16]
[ORG 0x7C00]

call pointer_string
call jump_line ; seta o ponteiro para a string
call print_string
jmp $ ; para travar o programa


print_string:
    mov ah, 0eh ; para imprimir caracteres na tela, tipo uma funcao de escrever um caractere no "teletype mode" | parte alta do registrador de 16 bits
    mov al, [si] ; pega os valors igual no x86-64 linux
    ; mas nesse caso ele imprime apenas uma letra que na ascii table e 8 bits
    print:
        int 10h ; pausa de video
        inc si ; incrementando 
        mov al, [si]
        cmp al, 0 ; vamos comparar com 0 por que o 0 que representa no NULL char na no final da str
        ; jnz print ; o cara fez com jne mas eu acho que o jnz funciona kkk
        jne print
    ret


pointer_string:
    mov si, hello ; hello e uma referencia de memoria, si eh um registrador de origem onde ele guarda um endereco de memoria que no caso eh do hello
    ret

jump_line:
    mov ah, 0eh
    mov al, 0ah ; equivalente ao \n
    int 10h
    mov al, 0dh ; voltar para primeira coluna
    int 10h
    ret

hello db "Hello world", 13, 10, 0 ; criando a string, CR, \n, NULL
times 510 - ($-$$) db 0
dw 0xAA55