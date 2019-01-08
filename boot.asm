;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

    mov bx, hello
    call print_string

    mov bx, bye
    call print_string

;; Infinite loop, $ means the current line
    jmp $

;; Print using 'teletype output' and stack
print_string:
    mov al, [bx]
    cmp al, 0
    je ($+4)                    ; Return if NULL
    call print_char
    inc bx
    jmp print_string
    ret
print_char:
    mov ah, 0x0e
    int 0x10
    ret

hello:
    db 'Hello World!',10,13,0
bye:
    db 'Bye Bye!',10,13,0

;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
