;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Put stack someplace that won't overwrite things
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

;; Print hex stored in dx
print_hex:
    ; Save stack
    push ax
    push bx

    ; NULL Terminate
    mov ax, 0
    push ax

    ; Push the characters onto the stack
    mov bx, dx
    and bx, 0xF
    add bx, hex
    mov ah, [bx]

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

;;; End!
;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
