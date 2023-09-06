; [bits 64]
; hello_world:
;     ; Set the destination index to 0xB8000 for video memory 2 bytes
;     ; per character: [attribute, color, etc] [char]
;     mov edi, 0xb8000

;     mov rax, 0x1F6C1F6C1F651F48   ; Blue BG, White FG, "Hell"
;     mov [edi],rax                 ; Printing is moving directly into the register

;     mov rax, 0x1F6F1F571F201F6F ; "o Wo"
;     mov [edi + 8], rax

;     mov rax, 0x1F211F641F6C1F72 ; "rld!"
;     mov [edi + 16], rax

;     jmp $

;     times 62- ($-$$) db 0
;     dw 0xdead
;     dw 0xbeef
[bits 32]
[extern _start]
     call _start
     jmp $
