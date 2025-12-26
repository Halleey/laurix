; isso e uma instrucao para o assembler
[BITS 16] ; sistema de arquitetura 16 bits
[ORG 0x7C00]; ORG de organization, endereco onde a BIOS vai procurar o codigo

; o MBR precisa de 512MB

; aqui vamos preencher o que falta ate chegar em 500MB
times 510 - ($-$$) db 0 ; -lowwryzen "seria preencher 510 vezes com o número zero "

; a assinatura vale 2MB completando os 512MB
; assinatura que eh necessaria para a BIOS entender que aqui tem um OS e dar boot nele
dw 0xAA55

; pra compilar para o "binario cru"
; nasm -f bin boot.asm -o boot.bin