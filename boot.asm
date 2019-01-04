;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt
    mov ah, 0x0e
    mov al, 'A'
    int 0x10
    mov al, 'y'
    int 0x10
    mov al, 'y'
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 'l'
    int 0x10
    mov al, 'm'
    int 0x10
    mov al, 'a'
    int 0x10
    mov al, 'o'
    int 0x10

;; Infinite loop, $ means the current line
    jmp $

;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
