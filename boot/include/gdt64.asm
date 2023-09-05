[bits 32]
GDT64:                           ; Global Descriptor Table (64-bit).

null_descriptor: equ $ - GDT64   ; The null descriptor.
    dq 0

code_descriptor: equ $ - GDT64   ; The code descriptor.
    dd 0xFFFF                                   ; Limit & Base (low, bits 0-15)
    db 0                                        ; Base (mid, bits 16-23)
    db PRESENT | NOT_SYS | EXEC | RW            ; Access
    db GRAN_4K | LONG_MODE | 0xF                ; Flags & Limit (high, bits 16-19)
    db 0                                        ; Base (high, bits 24-31)

data_descriptor: equ $ - GDT64   ; The data descriptor.
    dd 0xFFFF                                   ; Limit & Base (low, bits 0-15)
    db 0                                        ; Base (mid, bits 16-23)
    db PRESENT | NOT_SYS | RW                   ; Access
    db GRAN_4K | SZ_32 | 0xF                    ; Flags & Limit (high, bits 16-19)
    db 0                                        ; Base (high, bits 24-31)

tss_descriptor: equ $ - GDT64
    dd 0x00000068
    dd 0x00CF8900

gdt_pointer:                     ; The GDT-pointer.
    dw $ - GDT64 - 1             ; Limit.
    dq GDT64                     ; Base.

;; Access bits
PRESENT:        equ 1 << 7
NOT_SYS:        equ 1 << 4
EXEC:           equ 1 << 3
DC:             equ 1 << 2
RW:             equ 1 << 1
ACCESSED:       equ 1 << 0

;; Flags bits
GRAN_4K:       equ 1 << 7
SZ_32:         equ 1 << 6
LONG_MODE:     equ 1 << 5
