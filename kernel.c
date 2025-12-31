#include "include/vga.h"

void lau_main() {
    vga_set_color(VGA_LIGHT_GREEN, VGA_BLACK);
    vga_print("[OK] Kernel From Scratch\n");

    vga_set_color(VGA_LIGHT_RED, VGA_BLACK);
    vga_print("  [ERROR] Debug de cores funcionando\n");

    while (1);
}
