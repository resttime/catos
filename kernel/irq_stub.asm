[bits 64]
%macro irq_entry_stub 1
    irq_stub_%+%1:
    cli                         ; clear interrupt flag
    push byte 0                 ; no error code, for alignment
    push byte %1                ; isr enum
    call irq_handler_%1
    add esp, 8                  ; pop the isr enum
    add esp, 8                  ; pop the alignment
    iretq                       ; restores CPU pushes and interrupt flag
%endmacro

%assign i 0
%rep    16
extern irq_handler_%+i
%assign i i+1
%endrep

    irq_entry_stub 0
    irq_entry_stub 1
    irq_entry_stub 2
    irq_entry_stub 3
    irq_entry_stub 4
    irq_entry_stub 5
    irq_entry_stub 6
    irq_entry_stub 7
    irq_entry_stub 8
    irq_entry_stub 9
    irq_entry_stub 10
    irq_entry_stub 11
    irq_entry_stub 12
    irq_entry_stub 13
    irq_entry_stub 14
    irq_entry_stub 15

global irq_stub_table
irq_stub_table:
%assign i 0
%rep    16
    dq irq_stub_%+i ; use DQ instead if targeting 64-bit
%assign i i+1
%endrep
