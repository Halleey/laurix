[BITS 16] 

[ORG 0x7C00]

times 510 - ($-$$) db 0 

; exibir um hello world atraves da entrada de dados pelo teclado
call pointer_buffer

call read_string

call pointer_string_buffer

call print_string

call jump_line

jmp $ ; para travar o programa


pointer_string_buffer:
    mov si, buffer ; buffer e uma referencia de memoria, si eh um registrador de origem onde ele guarda um endereco de memoria que no caso eh do hello
    ret


print_string:
    mov ah, 0eh 
    mov al, [si] 
    
    print:
        int 10h
        inc si 
        mov al, [si]
        cmp al, 0 
        jne print
    ret



; guarda todos os caracteres digitados
read_string:
    mov ah, 00h ; funcao para pausar o video
    int 16h ; interrupcao para ler o teclado, ele espera digitar um caractere e guarda ele no al
    mov ah, 0eh ;  14 em decimal
    int 10h
    mov [al], di
    inc di
    cmp al, 0dh ; ir para a primeira coluna
    ; aqui ele compara ate o user der um enter
    ; que quando vc da um enter o caractere vai para 0dh
    jne read_string
    ; imprimindo oq vc digitou
    mov ah, 0eh ; pra imprimir
    mov al, 0eh
    int 10h
    ret

pointer_buffer:
    mov di buffer ; distiny index
    ret

jump_line:
    mov ah, 0eh
    mov al, 0ah ; equivalente ao \n
    int 10h
    mov al, 0dh ; voltar para primeira coluna
    int 10h
    ret


buffer times 20 db 0 ; ele vai escrever 0 NULL char 20 vezes
; em x86-64:
; section .bss
; buffer resb 20


dw 0xAA55

