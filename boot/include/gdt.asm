[bits 16]
gdt_start:

gdt_null:
    ; 8 byte null descriptor required
    dd 0x0 ; 4 bytes
    dd 0x0 ; 4 bytes

;; Code segment descriptor
gdt_code:
    dw 0xffff    ; Segment Limit (0-15)
    dw 0x0       ; Base Address (0-15)

    ; Base Address (16-23)
    db 0x0

    ; Present? - indicates if it's in memory: 1
    ; Segment Privilege: Ring 0 for highest privilege : 00
    ; Descriptor Type - Code/Data (1) or Traps (0) : 1
    ; Code?: 1
    ; Conforming? - Set memory protection, lower privileges: 0
    ; Readable? - Allows reading of constants: 1
    ; Accessed? - Debugging bit set by CPU on access: 0
    ;
    ; This is a code segment running with the highest privilege
    ; Lower privilege code can run this too because not conforming
    ; Any constants are readable defined in the code
    ; It has never been accessed before
    db 10011010b

    ; Granularity - multiplies limit by 4K: 1
    ; 32bit default: 1
    ; 64bit code: 0
    ; AVL - set for debugging purposes: 0
    ; Limit - address of last accessible data: 0xf or 1111b
    db 11001111b

    ; Base (24-32)
    db 0x0

;; Data segment descriptor
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b ; Same as above but the code? bit set for data
    db 11001111b
    db 0x0

;; Label for size end
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Size of GDT
    dq gdt_start               ; Address of GDT

;; Define offsets from GDT to seek from the start
CODE_SEG: equ gdt_code - gdt_start
DATA_SEG: equ gdt_data - gdt_start

[bits 32]
edit_gdt:
    mov [gdt_code+6], byte 10101111b
    mov [gdt_data+6], byte 10101111b
    ret
[bits 16]
