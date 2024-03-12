ASM_SOURCES = kernel_entry.asm isr.asm
C_SOURCES = $(wildcard *.c ../drivers/*.c)
HEADERS = $(wildcard *.h ../drivers/*.h)
OBJ = ${ASM_SOURCES:.asm=.o} ${C_SOURCES:.c=.o}

CFLAGS = -m64 -ffreestanding -nostdlib -fno-builtin	\
-fno-stack-protector -nostartfiles -nodefaultlibs -mno-red-zone	\
-mno-mmx -mno-sse -mno-sse2 -Wall -Wextra -Werror -c

LDFLAGS = -m elf_x86_64 --oformat binary -Ttext 0x8200

# Links kernel entry and kernel
# kernel_entry should placed first to be executed at 0x8200
kernel.bin: ${OBJ}
	ld $(LDFLAGS) $^ -o $@

# Build kernel entry and kernel
%.o: %.asm
	nasm -f elf64 $< -o $@
%.o: %.c ${HEADERS}
	gcc $(CFLAGS) $< -o $@

clean:
	rm -rf *.bin
	rm -rf ${OBJ}
