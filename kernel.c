#include <stdint.h>

static uint16_t cursor;  // .bss

static volatile uint16_t* const vga =
    (uint16_t*)0xB8000;  // memória VGA

void putchar(char c) {
    uint8_t color = 0x04; // vermelho no fundo preto
    vga[cursor++] = (color << 8) | c;
}

void lau_main() {
    const char msg[] = "Kernel From Scratch";

    for (int i = 0; msg[i]; i++) {
        putchar(msg[i]);
    }

    while (1);
}
