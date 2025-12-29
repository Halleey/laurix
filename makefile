compile:
	nasm -f bin bootloader.asm -o build/bootloader.bin
	nasm -f bin kernel.asm -o build/kernel.bin
	cat build/bootloader.bin build/kernel.bin > build/kernel.img
	
run:
	qemu-system-i386 build/kernel.img
