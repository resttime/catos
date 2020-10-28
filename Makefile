all: os.bin

run: all
	qemu-system-x86_64 -drive format=raw,file=os.bin,if=floppy

# Builds our os
os.bin: boot.bin kernel.bin
	cat $^ > os.bin

# Builds bootloader
boot.bin: boot.asm
	nasm -f bin $< -o $@

# Links kernel entry and kernel
kernel.bin: kernel_entry.o kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Build kernel
kernel.o: kernel.c
	gcc -m32 -ffreestanding -c $< -o $@

# Build kernel entry
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

# Cleanup!
clean:
	rm *.bin *.o
