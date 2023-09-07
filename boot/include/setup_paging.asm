[bits 32]

PAGE_TABLE_ENTRY: equ 0x1000
setup_paging:
    pusha
;; Disable any previous paging, skip if already disabled
    ; mov eax, cr0                                   ; Set the A-register to control register 0.
    ; and ebx, ~(1 << 31)     ; Clear the PG-bit, which is bit 31.
    ; mov cr0, eax                                   ; Set control register 0 to the A-register.

;; Clear Tables
    mov edi, PAGE_TABLE_ENTRY    ; Set the destination index
    mov cr3, edi       ; Set control register 3 to the destination
                       ; index. This is used to store where the base
                       ; address of the paging

    xor eax, eax       ; Nullify the A-register.
    mov ecx, 4096      ; Set the C-register to 4096
    rep stosd          ; Clears the memory for the whole paging table
                       ; 4096*4 = 16384. Stores EAX in EDI. Increment
                       ; EDI. Decrement ECX. Loop until ECX is 0

    mov edi, cr3       ; Since the EDI was modified by loop, put back
                       ; the base address of the page tableq

;; Setup PML4T, PDPT, PDT, and PT
    mov DWORD [edi], 0x2003      ; Set the uint32_t at the destination index to 0x2003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x3003      ; Set the uint32_t at the destination index to 0x3003.
    add edi, 0x1000              ; Add 0x1000 to the destination index.
    mov DWORD [edi], 0x4003      ; Set the uint32_t at the destination index to 0x4003.
    add edi, 0x1000              ; Add 0x1000 to the destination index

;; Identity Map the first two megabytes in a loop
    mov ebx, 0x00000003          ; Set the B-register to 0x00000003.
    mov ecx, 512                 ; Set the C-register to 512 for map_loop count
map_loop:
    mov DWORD [edi], ebx         ; Set the uint32_t at the destination index to the B-register.
    add ebx, 0x1000              ; Add 0x1000 to the B-register.
    add edi, 8                   ; Add eight to the destination index.
    loop map_loop                ; Set the next entry, loop and decrement ecx until 0

;; Setup PAE option bit
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    popa
    ret
