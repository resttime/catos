; Infinite loop
loop:
    jmp loop

; Fill with 510
times 510-($-$$) db 0
; Magic number
dw 0xaa55
