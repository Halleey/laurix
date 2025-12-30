BITS 32

global entry

entry:
    extern lau_main
    call lau_main
    jmp $