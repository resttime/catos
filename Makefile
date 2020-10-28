all: os.bin

os.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os.bin
boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin
kernel.bin: kernel_entry.o kernel.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o
kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

clean:
	rm *.bin *.o
