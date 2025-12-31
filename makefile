CC      = gcc
LD      = ld
AS      = nasm
OBJCOPY = objcopy

CFLAGS  = -m32 -ffreestanding -fno-pic -fno-pie \
          -fno-stack-protector -nostdlib -nostartfiles -c

LDFLAGS = -m elf_i386 -T linker.ld

BUILD   = build

#  alvo padrão
all: compile

compile: $(BUILD)/kernel.img

# Bootloader (512 bytes)
$(BUILD)/bootloader.bin: bootloader.asm
	mkdir -p $(BUILD)
	$(AS) -f bin $< -o $@

# Entry do kernel
$(BUILD)/kernel_entry.o: kernel_entry.asm
	$(AS) -f elf32 $< -o $@

# Kernel C
$(BUILD)/kernel.o: kernel.c
	$(CC) $(CFLAGS) $< -o $@

# Linkagem ELF
$(BUILD)/kernel.elf: $(BUILD)/kernel_entry.o $(BUILD)/kernel.o linker.ld
	$(LD) $(LDFLAGS) \
	    $(BUILD)/kernel_entry.o $(BUILD)/kernel.o \
	    -o $@

# converte de ELF p/ BIN
$(BUILD)/kernel.bin: $(BUILD)/kernel.elf
	$(OBJCOPY) -O binary $< $@

# Imagem final
$(BUILD)/kernel.img: $(BUILD)/bootloader.bin $(BUILD)/kernel.bin
	cat $^ > $@

# execução 
run: $(BUILD)/kernel.img
	qemu-system-i386 $<

#limpeza no final  
clean:
	rm -rf $(BUILD)
