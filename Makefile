.PHONY: kernel/kernel.bin test clean

all: os.bin

run: all
	qemu-system-x86_64 -s -drive format=raw,file=os.bin

# Builds our os
os.bin: boot/boot.bin boot/extended_boot.bin kernel/kernel.bin
	cat $^ > os.bin

# Builds bootloader
%.bin: %.asm $(wildcard boot/include/*.asm)
	nasm -f bin -I 'boot/include' $< -o $@

# Builds kernel
kernel/kernel.bin:
	make -C kernel/

# Test
test:
	make -C test/

# Cleanup!
clean:
	rm -rf *.bin boot/*.bin
	make -C kernel/ clean
	make -C test/ clean
