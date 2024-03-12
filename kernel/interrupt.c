#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define IDT_MAX_DESCRIPTORS 256

typedef struct {
  // The lower 16 bits of the ISR's address
  uint16_t isr_low;

  // The GDT segment selector that the CPU will load into CS before calling the
  // ISR
  uint16_t kernel_cs;

  // The IST in the TSS that the CPU will load into RSP; set to // zero for now
  uint8_t ist;

  // Type and attributes; see the IDT page
  uint8_t attributes;

  // The higher 16 bits of the lower 32 bits of the ISR's address
  uint16_t isr_mid;

  // The higher 32 bits of the ISR's address
  uint32_t isr_high;

  // Set to zero
  uint32_t reserved;
} __attribute__((packed)) idt_entry_t;

// Create an array of IDT entries; aligned for performance
__attribute__((aligned(0x10))) static idt_entry_t idt[IDT_MAX_DESCRIPTORS];

typedef struct {
  uint16_t limit;
  uint64_t base;
} __attribute__((packed)) idtr_t;

static idtr_t idtr;
static bool vectors[IDT_MAX_DESCRIPTORS];

// __attribute__((noreturn)) void exception_handler(void);
void exception_handler() {
  __asm__ volatile("cli; hlt"); // Completely hangs the computer
}

void idt_set_descriptor(uint8_t vector, void *isr, uint8_t flags);
void idt_set_descriptor(uint8_t vector, void *isr, uint8_t flags) {
  idt_entry_t *descriptor = &idt[vector];

  descriptor->isr_low = (uint64_t)isr & 0xFFFF;
  descriptor->kernel_cs = 0x08; // Offset for the GDT_CODE from GDT_START
  descriptor->ist = 0;
  descriptor->attributes = flags;
  descriptor->isr_mid = ((uint64_t)isr >> 16) & 0xFFFF;
  descriptor->isr_high = ((uint64_t)isr >> 32) & 0xFFFFFFFF;
  descriptor->reserved = 0;
}

extern void *isr_stub_table[];

void idt_init() {
  idtr.base = (uintptr_t)&idt[0];
  idtr.limit = (uint16_t)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

  for (uint8_t vector = 0; vector < 32; vector++) {
    idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
    vectors[vector] = true;
  }

  __asm__ volatile("lidt %0" : : "m"(idtr)); // load the new IDT
  __asm__ volatile("sti");                   // set the interrupt flag
}
