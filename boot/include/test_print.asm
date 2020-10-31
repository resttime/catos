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
