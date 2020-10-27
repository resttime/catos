[bits 16]
;; tests
test_print:
    push bx
    push dx
    mov bx, hello
    call print_string

    mov bx, bye
    call print_string

    mov dx, 0x1fb6
    call print_hex

    pop dx
    pop bx
    ret

;; Print hex stored in dx
print_hex:
    ; save registers
    push ax
    push bx

    ; NULL Terminate
    mov ax, 0
    push ax

    ; Push the characters onto the stack
    ; 1. Grab the value of the hexchar
    ; 2. Use the value to offset hex address to pick hexchar
    ; 3. Place the hexchar into register
    ; 4. Push register into stack (16bit push so
    ;    set both al,ah before pushing ax)
    ; 5. print stack

    ; 0x---1
    mov bx, dx                  ; set bx to the hex
    shr bx, 0                   ; shift right
    and bx, 0xF                 ; zero out for offset
    add bx, hex                 ; hexchar location
    mov ah, [bx]                ; move hexchar into register
    ; 0x--1-
    mov bx, dx
    shr bx, 4
    and bx, 0xF
    add bx, hex
    mov al, [bx]
    push ax
    ; 0x-1--
    mov bx, dx
    shr bx, 8
    and bx, 0xF
    add bx, hex
    mov ah, [bx]
    ; 0x1---
    mov bx, dx
    shr bx, 12
    and bx, 0xF
    add bx, hex
    mov al, [bx]
    push ax

    ; Call print string on the stack
    mov bx, sp
    call print_string

    ; Print newline
    call print_newline

    ; Restore registers
    pop ax
    pop ax
    pop ax
    pop bx
    pop ax

    ; Done
    ret

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
hex: db '0123456789abcdef'
hello: db 'Hello world!',10,13,0
bye: db 'Bye bye!',10,13,0
