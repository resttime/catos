[bits 16]
;; The A20 Line is an odd legacy way to enable access to all memory

;; al(out)
enable_a20:
    push ax
    in al, 0x92
    or al, 2
    out 0x92, al
    pop ax
    ret
