;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Place the stack where it won't ovewrite things
;; 0x8000 is EBDA (Extended BIOS Data Area)
    mov bp, 0x8000
    mov sp, bp
;; Print
    mov bx, hello
    call print_string
;; Print
    mov bx, bye
    call print_string
;; Print
    mov dx, 0x1fb6
    call print_hex

;; Infinite loop, $ means the current line
    jmp $

;; load DH sectors to ES:BX from drive DL
disk_load:
    push dx

    ; Bios read function
    mov ah, 0x02
    ; Read dh sectors
    mov al, dh
    ; cylinder 0
    mov ch, 0x00
    ; head 0
    mov dh, 0x00
    ; read second sector (after boot sector)
    mov cl, 0x02
    ; BIOS interrupt
    int 0x13

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

;; Print hex stored in dx
print_hex:
    ; Save stack
    push ax
    push bx

    ; NULL Terminate
    mov ax, 0
    push ax

    ; Push the characters onto the stack
    ; 1. Grab the value of the hexchar
    ; 2. Use the value to offset hex address to pick hexchar
    ; 3. Place the hexchar into register
    ; 4. Push register into stack (16bit push so
    ;    set both al,ah before pushing ax)
    ; 5. print stack
    mov bx, dx                  ; set bx to the hex
    shr bx, 0                   ; shift right
    and bx, 0xF                 ; zero out for offset
    add bx, hex                 ; hexchar location
    mov ah, [bx]                ; move hexchar into register

    mov bx, dx
    shr bx, 4
    and bx, 0xF
    add bx, hex
    mov al, [bx]
    push ax

    mov bx, dx
    shr bx, 8
    and bx, 0xF
    add bx, hex
    mov ah, [bx]

    mov bx, dx
    shr bx, 12
    and bx, 0xF
    add bx, hex
    mov al, [bx]
    push ax

    ; Call print string on the stack
    mov bx, sp
    call print_string

    ; Print newline
    call print_newline

    ; Restore the registers and return
    pop ax
    pop ax
    pop ax
    pop bx
    pop ax
    ret

;; Prints the NULL terminated string pointed by bx
print_string:
    mov al, [bx]
    cmp al, 0
    je ($+4)                    ; Return if NULL
    call print_char
    inc bx
    jmp print_string
    ret

;; Prints a newline and returnline
print_newline:
    push ax
    mov al, 10
    call print_char
    mov al, 13
    call print_char
    pop ax
    ret

;; Prints the character in al
print_char:
    mov ah, 0x0e
    int 0x10
    ret

;;; Strings
;; 10: '\n' and 13: '\r'
hello:
    db 'Hello World!',10,13,0
bye:
    db 'Bye Bye!',10,13,0
hex:
    db '0123456789abcdef'
secret:
    db 'X'

DISK_ERROR_MSG db "Disk read error!",0

;;; End!
;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
