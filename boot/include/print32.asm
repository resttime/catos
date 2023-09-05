;; Print for 32bit protected mode
[bits 32]
; ebx(in) - prints string at location
print_string32:
    pusha                       ; push all registers
    mov edx, VIDEO_MEMORY
print_string32_loop:
    mov al, [ebx]               ; put char in memory
    mov ah, WHITE_ON_BLACK      ; set color
    cmp al, 0                   ; check for null char
    je print_string32_done      ; nullchar means we're done
    mov [edx], ax               ; move the char,attr pair into memory
    add ebx, 1                  ; increment ebx to the next char
    add edx, 2                  ; move to next char
    jmp print_string32_loop     ; repeat
print_string32_done:
    popa                        ; pop all registers
    ret

VIDEO_MEMORY: equ 0xb8000
WHITE_ON_BLACK: equ 0x0f
