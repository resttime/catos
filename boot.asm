;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Place the stack where it won't ovewrite things
    mov bp, 0x8000
    mov sp, bp

;; Store boot drive
    mov [BOOT_DRIVE], dl

main:
    call test_print
;; Load 2 sectors
    mov bx, 0x9000
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov dx, [0x9000]
    call print_hex

    mov dx, [0x9000 + 512]
    call print_hex

    call switch_to_pm

;; Infinite loop, $ means the current line
    jmp $

%include "./include/print.asm"     ; Include printing functions
%include "./include/disk_load.asm" ; Include disk load functions
%include "./include/gdt.asm"       ; Inclue GDT
%include "./include/switch_pm.asm" ; Include code for switching to PM

[bits 32]

MAIN32:
    mov ebx, MSG_PROT_MODE
    call print_string32
    jmp $
BOOT_DRIVE: db 0
MSG_PROT_MODE: db "Successfully in 32-bit Protected Mode",0

;;; End!
;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55

;; BIOS first only loads previous 512-byte sector
;; Let's place 2 more sectors in our disk to read from
    times 256 dw 0xdada
    times 256 dw 0xface
