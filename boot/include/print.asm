[bits 16]
;; Prints a NULL terminated string
;; bx(in) - Address to string
print_string:
    push ax                     ; save registers
    push bx
print_string_loop:
    mov al, [bx]                ; get char from [bx]
    cmp al, 0                   ; check if al is null
    je print_string_done        ; jump to end if char is null
    call print_char             ; print char that is not null
    inc bx                      ; point at next char
    jmp print_string_loop       ; loop
print_string_done:
    pop bx                      ; restore registers
    pop ax
    ret

;; Prints a newline and returnline
print_newline:
    push ax
    mov al, 10                  ; 0xA '\n'
    call print_char
    mov al, 13                  ; 0xC '\r'
    call print_char
    pop ax
    ret

;; Prints the character in al
;; al(in) - Character to Print
;; ah(out) - Overwritten with 0x0e
print_char:
    mov ah, 0x0e                ; teletype
    int 0x10                    ; interrupt
    ret
