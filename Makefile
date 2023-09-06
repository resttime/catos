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
	ld -m elf_x86_64 -o $@ -Ttext 0x8200 $^ --oformat binary

# Build kernel
%.o: %.c ${HEADERS}
	gcc -m64 -ffreestanding -nostdlib -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -c $< -o $@

# Builds bootloader
%.o: %.asm
	nasm $< -f elf64 -o $@
%.bin: %.asm $(wildcard boot/include/*.asm)
	nasm $< -f bin -I 'boot/include' -o $@

# Test
test:
	make -C test/

# Cleanup!
clean:
	rm -rf *.bin
	rm -rf kernel/*.o drivers/*.o boot/*.bin
