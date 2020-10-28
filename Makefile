os.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os.bin
boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin
kernel.bin: kernel_entry.o kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf64 -o kernel_entry.o
