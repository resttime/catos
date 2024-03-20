[bits 64]

[extern _start]
    jmp _start

[global myfunc]                ; Can call with _myfunc() in C
myfunc:
    mov edi, 0xB8000              ; Set the destination index to 0xB8000.
    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20.
    mov ecx, 500                  ; Set the C-register to 500.
    rep stosq                     ; Clear the screen.
    ret

[global strlen]

strlen:
    push  rbx                   ; save registers
    push  rcx

    mov   rbx, rdi            ; rbx = rdi, C ABI puts first arg in rdi

    xor   al, al              ; byte the scan will compare to is null/zero
    mov   rcx, 0xffffffff     ; max bytes any string will have is assumed 4gb
    repne scasb               ; while [rdi] != al, keep scanning

    sub   rdi, rbx            ; rdi = rdi-rbx
    dec rdi                   ; don't count the null character '\0'
    mov   rax, rdi            ; rax now holds our length

    pop   rcx                 ; restore the saved registers
    pop   rbx

    ret
