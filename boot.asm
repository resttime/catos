;; Start memory address offset at bootloader
[org 0x7c00]

;; https://en.wikipedia.org/wiki/INT_10H
;; Using the 0x10h BIOS interrupt

    mov bx, string
    call print_string
;; Infinite loop, $ means the current line
    jmp $

;; Print using 'teletype output' and stack
print_string:
    pusha                       ; Push all regs
    mov ah, 0x0e
    mov al, [bx]
    or al, al
    jz print_end
    int 0x10                    ; Print interrupt
    inc bx
    jmp print_string
print_end:
    popa                        ; Pop all regs and return
    ret

string:
    db 'Hello World!',0
    
;; Pad up with zeros and magic number to 512
    times 510-($-$$) db 0
    dw 0xaa55
