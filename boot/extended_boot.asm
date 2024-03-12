[org 0x7e00]
    mov [BOOT_DRIVE], dl        ; Get BOOT_DRIVE initial boot

    mov bx, MSG_EXTENDED_BOOT
    call print_string

    mov bx, MSG_LOAD_KERNEL
    call print_string
    call load_kernel

    jmp switch_pm

%include "print.asm"
%include "disk_load.asm"
%include "switch_pm.asm"

[bits 16]
load_kernel:
    mov dl, [BOOT_DRIVE]
    mov bx, 0x8200             ; Memory location to read kernel into
    mov dh, 32                 ; # of sectors to read, 512 bytes per sector
    mov cl, 0x4                ; read kernel on sector
    call disk_load

    ret

BOOT_DRIVE: db 0
MSG_EXTENDED_BOOT: db "Successfully entered extended boot!",10,13,0
MSG_LOAD_KERNEL: db "Reading the kernel...",10,13,0

;; End
    times 1024-($-$$) db 0
