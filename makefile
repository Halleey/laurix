CC      = gcc
LD      = ld
AS      = nasm
OBJCOPY = objcopy

# Flags
CFLAGS  = -m32 -ffreestanding -fno-pic -fno-pie \
          -fno-stack-protector -nostdlib -nostartfiles -c

LDFLAGS = -m elf_i386 -T linker.ld

BUILD   = build

# Fonte
BOOTLOADER = core/bootloader.asm
KENTRY     = core/kernel_entry.asm
KERNEL_C   = kernel.c
VGA_C      = include/vga.c

# alvo padrão
all: compile

compile: $(BUILD)/kernel.img

# Bootloader (512 bytes)
$(BUILD)/bootloader.bin: $(BOOTLOADER)
	mkdir -p $(BUILD)
	$(AS) -f bin $< -o $@

# Entry do kernel
$(BUILD)/kernel_entry.o: $(KENTRY)
	mkdir -p $(BUILD)
	$(AS) -f elf32 $< -o $@

# Kernel C
$(BUILD)/kernel.o: $(KERNEL_C)
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

# VGA driver
$(BUILD)/vga.o: $(VGA_C)
	mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $< -o $@

# Linkagem ELF
$(BUILD)/kernel.elf: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o $(BUILD)/vga.o linker.ld
	$(LD) $(LDFLAGS) \
	    $(BUILD)/kernel_entry.o $(BUILD)/kernel.o $(BUILD)/vga.o \
	    -o $@

# Converte ELF -> BIN
$(BUILD)/kernel.bin: $(BUILD)/kernel.elf
	$(OBJCOPY) -O binary $< $@

# Imagem final (bootloader + kernel)
$(BUILD)/kernel.img: $(BUILD)/bootloader.bin $(BUILD)/kernel.bin
	cat $^ > $@

# Execução
run: $(BUILD)/kernel.img
	qemu-system-i386 $<

# Limpeza
clean:
	rm -rf $(BUILD)
