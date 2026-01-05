void putchar(char c){
    char* vga = (char*)0xB8000;
    vga[0] = c;
    vga[1] = 0x0f;
}

void lau_main(){
    putchar('C');
    putchar('A');
    while (1);
}