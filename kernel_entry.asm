;; Ensures jumping to the kernel main entry
[bits 32]
[extern main]                   ; Declare 'main' symbol
    call main                   ; Call main() in C
    jmp $
