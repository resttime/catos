[bits 16]
switch_pm:
    mov bx, MSG_ENABLE_A20
    call print_string
    call enable_a20             ; Enable A20 Line

    mov bx, MSG_DISABLE_INT
    call print_string
    cli                         ; Required to disable interrupts

    mov bx, MSG_LOADING_GDT
    call print_string
    lgdt [gdt_descriptor]       ; Load the GDT

    mov eax, cr0     ; Switch the CPU to protected mode
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:start_pm       ; Far Jump to 32-bit land

%include "a20.asm"
%include "gdt.asm"
%include "print32.asm"
%include "detect_cpuid.asm"
%include "detect_lm.asm"
%include "setup_paging.asm"
%include "switch_lm.asm"

[bits 32]
start_pm:
    ; Point al segment registers to GDT data selector
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Update stack to new position
    mov ebp, 0x80000            ; edge of free memory of real mode
                                ; memory layout
    mov esp, ebp

    mov ebx, MSG_PROTECTED_MODE
    call print_string32

    mov ebx, MSG_DETECTING_LM
    call detect_cpuid
    call detect_lm

    mov ebx, MSG_SETUP_LM
    call print_string32
    call setup_paging
    call edit_gdt

    mov ebx, MSG_SWITCHING_LM
    call print_string32
    jmp switch_lm

MSG_ENABLE_A20: db "Enabling A20 Line...",10,13,0
MSG_DISABLE_INT: db "Disabling Interrupts...",10,13,0
MSG_LOADING_GDT: db "Loading GDT...",10,13,0
MSG_PROTECTED_MODE: db "Started 32-bit Protected Mode!",0
MSG_DETECTING_LM: db "Detecting Long Mode...",0
MSG_SETUP_LM: db "Setting Up GDT and Paging for Long Mode...",0
MSG_SWITCHING_LM: db "Switching to Long Mode",0
