;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Print using 'teletype output' and stack
    mov ah, 0x0e

    mov bp, 0x8000              ; Free memory location
    mov sp, bp

string:
    push '!'
    push 'd'
    push 'l'
    push 'r'
    push 'o'
    push 'W'
    push ' '
    push 'o'
    push 'l'
    push 'l'
    push 'e'
    push 'H'

len: equ 12
    mov cx, len
    
print:
    pop bx
    mov al, bl
    int 0x10
    dec cx
    cmp cx, 0
    jne print

;; Infinite loop, $ means the current line
    jmp $

;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
