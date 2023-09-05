;; This bootloader is only used to load the extended bootdrive

;; Start memory address offset at bootloader
[org 0x7c00]
    mov [BOOT_DRIVE], dl        ; Save boot drive put in dl by BIOS

    mov bp, 0x9000 ; Place the stack where it won't overwrite things
    mov sp, bp

    call load_extended_boot

    mov dl, [BOOT_DRIVE]        ; Pass boot drive to extended boot
    jmp EXTENDED_BOOT_SPACE

%include "print.asm"
%include "disk_load.asm"

load_extended_boot:
    mov bx, MSG_LOAD_EXTENDED_BOOT
    call print_string

    mov bx, EXTENDED_BOOT_SPACE ; Memory location to read kernel into
    mov dl, [BOOT_DRIVE]
    mov dh, 4                   ; # of sectors to read, 512 bytes per sector
    mov cl, 0x02                ; extended bootloader on sector 2
    call disk_load
    ret

BOOT_DRIVE: db 0
EXTENDED_BOOT_SPACE: equ 0x7e00 ; Extended bootloader 512 bytes after 0x7c00 at 0x7e00
MSG_LOAD_EXTENDED_BOOT: db "Loading extended boot from disk...",10,13,0

    ; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
