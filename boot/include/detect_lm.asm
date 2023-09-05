[bits 32]
detect_lm:
;; Check for long mode detecting function
    mov eax, 0x80000000    ; Set the A-register to 0x80000000.
    cpuid                  ; CPU identification.
    cmp eax, 0x80000001    ; Compare the A-register with 0x80000001.
    jb no_lm        ; It is less, there is no long mode.

;; Detect long mode
    mov eax, 0x80000001    ; Set the A-register to 0x80000001.
    cpuid                  ; CPU identification.
    test edx, 1 << 29      ; Test if the LM-bit, which is bit 29, is set in the D-register.
    jz no_lm        ; They aren't, there is no long mode.

    ret

no_lm:
    mov ebx, LM_UNSUPPORTED_MSG
    call print_string32
    jmp $

LM_UNSUPPORTED_MSG: db 'Long mode not supported',0
