[bits 32]
switch_lm:
    ; Set LM-bit
    mov bx, MSG_SETTING_LM_BIT
    call print_string32

    mov ecx, 0xC0000080          ; Set the C-register to 0xC0000080, which is the EFER MSR.
    rdmsr                        ; Read from the model-specific register.
    or eax, 1 << 8               ; Set the LM-bit which is the 9th bit (bit 8).
    wrmsr                        ; Write to the model-specific register.

    ; Enable paging
    mov bx, MSG_ENABLING_PAGING
    call print_string32

    mov eax, cr0                 ; Set the A-register to control register 0.
    or eax, 1 << 31              ; Set the PG-bit, which is the 32nd bit (bit 31).
    mov cr0, eax                 ; Set control register 0 to the A-register.

load_gdt64:
    lgdt [gdt_pointer]         ; Load the 64-bit global descriptor table.
    jmp code_descriptor:start_lm       ; Set the code segment and enter 64-bit long mode.

%include "gdt64.asm"

MSG_SETTING_LM_BIT: db "Setting Long Mode Bit...",10,13,0
MSG_ENABLING_PAGING: db "Enabling Paging...",10,13,0

[bits 64]
start_lm:
    cli                           ; Clear the interrupt flag.
    mov ax, data_descriptor       ; Set the A-register to the data descriptor.
    mov ds, ax                    ; Set the data segment to the A-register.
    mov es, ax                    ; Set the extra segment to the A-register.
    mov fs, ax                    ; Set the F-segment to the A-register.
    mov gs, ax                    ; Set the G-segment to the A-register.
    mov ss, ax                    ; Set the stack segment to the A-register.

    call clear_screen
    call hello_world
    call 0x1000
    hlt

    ret

clear_screen:
    mov edi, 0xB8000              ; Set the destination index to 0xB8000 for video

    mov rax, 0x1F201F201F201F20   ; Set the A-register to 0x1F201F201F201F20
    mov ecx, 500                  ; Set the C-register to 500

    rep stosq                     ; Clear the screen to blue
                                  ; Store RAX at address RDI or EDI and Repeat ECX times
                                  ; Screen overwritten with characters
    ret
hello_world:
    ; Set the destination index to 0xB8000 for video memory 2 bytes
    ; per character: [attribute, color, etc] [char]
    mov edi, 0xb8000

    mov rax, 0x1F6C1F6C1F651F48   ; Blue BG, White FG, "Hell"
    mov [edi],rax                 ; Printing is moving directly into the register

    mov rax, 0x1F6F1F571F201F6F ; "o Wo"
    mov [edi + 8], rax

    mov rax, 0x1F211F641F6C1F72 ; "rld!"
    mov [edi + 16], rax
    ret
