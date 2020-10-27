;; load DH sectors to ES:BX from drive DL
disk_load:
    push dx

    mov ah, 0x02 ; Bios read function
    mov al, dh ; Read dh sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; read second sector (after boot sector)

    int 0x13 ; BIOS interrupt

    ; Jump if error
    jc disk_error

    ; restore dx
    pop dx

    ; jump to error if sectors read != expected
    cmp dh, al
    jne disk_error
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG: db "Disk read error!",0
