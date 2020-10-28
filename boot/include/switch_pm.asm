[bits 16]
;; 32bit mode
switch_to_pm:
    cli                   ; Required to disable interrupts
    lgdt [gdt_descriptor] ; Load the GDT

;; Switch the CPU to protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
;; After switching to pm, point al segment registers to GDT data selector
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

;; Update stack to new position
    mov ebp, 0x90000
    mov esp, ebp

    call MAIN32
