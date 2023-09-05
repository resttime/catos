[bits 16]
;; load DH sectors to ES:BX from drive DL
;; dh(in) - # of Sectors to read
;; cl(in) - sector to start reading at
;; [BOOT_DRIVE](in) - Drive
;; [bx](out) - write to this location

disk_load:
    ; store dx
    push dx

    mov ah, 0x02 ; Bios read function
    mov al, dh ; Read dh sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0


    int 0x13 ; BIOS interrupt

    ; Jump if error
    jc disk_error

    ; restore dx
    pop dx

    ; jump to error if sectors read != expected
    cmp dh, al
    jne disk_read_expected_error

    ret

disk_read_expected_error:
    mov bx, DISK_READ_EXPECTED_ERROR_MSG
    call print_string
disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_READ_EXPECTED_ERROR_MSG: db "Read != Expected",10,13,0
DISK_ERROR_MSG: db "Disk read error!",10,13,0
