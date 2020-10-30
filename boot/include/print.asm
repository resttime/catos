[bits 16]
;; Prints the NULL terminated string
;; bx(in)
print_string:
    ; save registers
    push ax
    push bx

    ; (print_string+2)
    mov al, [bx]                ; get char from [bx]
    cmp al, 0                   ; check if al is null
    je ($+4)                    ; jump to end if char is null
    call print_char             ; print char that is not null
    inc bx                      ; point at next char
    jmp (print_string+2)        ; go back to beginning

    ; restore registers
    pop bx
    pop ax

    ; done
    ret

;; Prints a newline and returnline
print_newline:
    push ax
    mov al, 10                  ; '\n'
    call print_char
    mov al, 13                  ; '\r'
    call print_char
    pop ax
    ret

;; Prints the character in al
;; ah(rw): print interrupt parameter
print_char:
    mov ah, 0x0e
    int 0x10
    ret

;; Print for 32bit protected mode
[bits 32]

VIDEO_MEMORY: equ 0xb8000
WHITE_ON_BLACK: equ 0x0f

;; prints the string at edx
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
