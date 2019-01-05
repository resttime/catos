;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Print using 'teletype output'
    mov ah, 0x0e
    mov al, 'W'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, 'r'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'd'
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'H'
    int 0x10
    mov al, 'e'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'o'
    int 0x10
    mov al, '!'
    int 0x10

;; Print using 'write string'
    mov ah, 0x13
    mov bl, 0xa                 ; Color (10: Light Green)
    mov al, 0                   ; Write mode (1: don't move cursor)
    mov dh, 9                   ; Row
    mov dl, 0                   ; Col
    mov cx, len                 ; String length
    mov ebp, msg                ; Location string
    int 0x10

;; Infinite loop, $ means the current line
    jmp $

msg: db "Hello World!"
len: equ ($-msg)

;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
