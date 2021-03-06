C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os.bin

run: all
	qemu-system-x86_64 -drive format=raw,file=os.bin,if=floppy

# Builds our os
os.bin: boot/boot.bin kernel.bin
	cat $^ > os.bin

# Links kernel entry and kernel
kernel.bin: kernel/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Build kernel
%.o: %.c ${HEADERS}
	gcc -m32 -ffreestanding -c $< -o $@

# Builds bootloader
%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -I boot/ -o $@

# Cleanup!
clean:
	rm -rf *.bin
	rm -rf kernel/*.o drivers/*.o boot/*.bin
