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

hex: db '0123456789abcdef'
hello: db 'Hello world!',10,13,0
bye: db 'Bye bye!',10,13,0
