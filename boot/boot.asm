;; Start memory address offset at bootloader
[org 0x7c00]
KERNEL_OFFSET: equ 0x1000       ; Offset of code in kernel

    mov [BOOT_DRIVE], dl ; Store boot drive

    mov bp, 0x9000 ; Place the stack where it won't ovewrite things
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print_string

    call load_kernel

    call switch_to_pm

;; Infinite loop, $ means the current line
    jmp $

%include "./include/print.asm"     ; Include printing functions
%include "./include/disk_load.asm" ; Include disk load functions
%include "./include/gdt.asm"       ; Inclue GDT
%include "./include/switch_pm.asm" ; Include code for switching to PM

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string

;; Load kernel from disk by reading 15 sectors after the bootloader
    mov bx, KERNEL_OFFSET
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret

[bits 32]

MAIN32:
    mov ebx, MSG_PROT_MODE
    call print_string32
    call KERNEL_OFFSET
    jmp $

BOOT_DRIVE: db 0
MSG_REAL_MODE: db "Started in 16-bit Real Mode",10,13,0
MSG_PROT_MODE: db "Successfully in 32-bit Protected Mode",0
MSG_LOAD_KERNEL: db "Loading kernel!",10,13,0

;;; End!
;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
