C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}

all: os.bin

run: all
	qemu-system-x86_64 -s -drive format=raw,file=os.bin

# Builds our os
os.bin: boot/boot.bin boot/extended_boot.bin kernel.bin
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
%.bin: %.asm $(wildcard boot/include/*.asm)
	nasm $< -f bin -I 'boot/include' -o $@

# Test
test:
	make -C test/

# Cleanup!
clean:
	rm -rf *.bin
	rm -rf kernel/*.o drivers/*.o boot/*.bin
