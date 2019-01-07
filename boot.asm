;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

;; Print using 'teletype output' and stack
    mov ah, 0x0e

    mov bp, 0x8000              ; Free memory location
    mov sp, bp

string:
    db 'Hello World!',0
    mov bx, string
    
print:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp print

end:
;; Infinite loop, $ means the current line
    jmp $

;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
