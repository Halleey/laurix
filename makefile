CFLAGS = -m32 -ffreestanding -fno-pic -fno-pie -fno-stack-protector -nostdlib -nostartfiles -c

compile:
	nasm -f bin bootloader.asm -o build/bootloader.bin
	nasm -f elf32 kernel_entry.asm -o build/kernel_entry.o
	gcc $(CFLAGS) kernel.c -o build/kernel.o
	ld -m elf_i386 -Ttext 0x1000 --oformat binary build/kernel_entry.o build/kernel.o -o build/kernel.bin

	cat build/bootloader.bin build/kernel.bin > build/kernel.img
	
run:
	qemu-system-i386 build/kernel.img



