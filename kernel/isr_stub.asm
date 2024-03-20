[bits 64]

%macro isr_err_stub 1
    isr_stub_%+%1:
    cli                         ; Clear Interrupt Flag

    ; CPU pushes rip, cs, rflags, rsp, dss onto stack
    ; CPU also pushes corresponding error code
    push byte %1                ; isr enum
    mov rdi, rsp ; C arg points to the processor state
    call exception_handler_%1
    add esp, 8                  ; pops isr enum
    add esp, 8                  ; pops hidden CPU error code push
    iretq ; pops rip, cs, rflags, rsp, ss. restores interrupt flag
%endmacro

;; if writing for 64-bit, use iretq instead
%macro isr_no_err_stub 1
    isr_stub_%+%1:
    cli                         ; Clear Interrupt Flag

    push byte 0                 ; no errcode, for alignment
    push byte %1                ; isr enum
    mov rdi, rsp
    call exception_handler_%1
    add esp, 8                  ; pops isr enum
    add esp, 8                  ; pops alignment padding
    iretq
%endmacro

%assign i 0
%rep    32
extern exception_handler_%+i
%assign i i+1
%endrep

    isr_no_err_stub 0
    isr_no_err_stub 1
    isr_no_err_stub 2
    isr_no_err_stub 3
    isr_no_err_stub 4
    isr_no_err_stub 5
    isr_no_err_stub 6
    isr_no_err_stub 7
    isr_err_stub    8
    isr_no_err_stub 9
    isr_err_stub    10
    isr_err_stub    11
    isr_err_stub    12
    isr_err_stub    13
    isr_err_stub    14
    isr_no_err_stub 15
    isr_no_err_stub 16
    isr_err_stub    17
    isr_no_err_stub 18
    isr_no_err_stub 19
    isr_no_err_stub 20
    isr_no_err_stub 21
    isr_no_err_stub 22
    isr_no_err_stub 23
    isr_no_err_stub 24
    isr_no_err_stub 25
    isr_no_err_stub 26
    isr_no_err_stub 27
    isr_no_err_stub 28
    isr_no_err_stub 29
    isr_err_stub    30
    isr_no_err_stub 31

global isr_stub_table
isr_stub_table:
%assign i 0
%rep    32
    dq isr_stub_%+i ; use DQ instead if targeting 64-bit
%assign i i+1
%endrep
