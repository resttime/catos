C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
ASM_SOURCES = kernel/kernel_entry.asm kernel/isr.asm
OBJ = ${ASM_SOURCES:.asm=.o} ${C_SOURCES:.c=.o}

CFLAGS = -m64 -ffreestanding -nostdlib -fno-builtin	\
-fno-stack-protector -nostartfiles -nodefaultlibs -mno-red-zone	\
-mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -Werror -c

LDFLAGS = -m elf_x86_64 --oformat binary -Ttext 0x8200

all: os.bin

run: all
	qemu-system-x86_64 -s -drive format=raw,file=os.bin

# Builds our os
os.bin: boot/boot.bin boot/extended_boot.bin kernel.bin
	cat $^ > os.bin

# Builds bootloader
%.bin: %.asm $(wildcard boot/include/*.asm)
	nasm -f bin -I 'boot/include' $< -o $@

# Links kernel entry and kernel
kernel.bin: ${OBJ}
	ld $(LDFLAGS) $^ -o $@

# Build kernel entry and kernel
%.o: %.asm
	nasm -f elf64 $< -o $@
%.o: %.c ${HEADERS}
	gcc $(CFLAGS) $< -o $@

# Test
test:
	make -C test/

# Cleanup!
clean:
	rm -rf *.bin boot/*.bin
	rm -rf ${OBJ}
	make -C test/ clean
