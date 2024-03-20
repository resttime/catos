#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#include "idt.h"
#include "irq.h"
#include "isr.h"
#include "screen.h"

#define GDT_CODE 0x08 // Offset for the GDT_CODE from GDT_START

typedef struct __attribute__((packed)) {
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
} idt_entry_t;

// Create an array of IDT entries; aligned for performance
__attribute__((aligned(0x10))) static idt_entry_t idt[IDT_MAX_DESCRIPTORS];

typedef struct {
  uint16_t limit;
  uint64_t base;
} __attribute__((packed)) idtr_t;

static idtr_t idtr;

void idt_set_descriptor(uint8_t vector, void *isr, uint8_t flags) {
  idt_entry_t *descriptor = &idt[vector];

  descriptor->isr_low = (uint64_t)isr & 0xFFFF;
  descriptor->kernel_cs = GDT_CODE;
  descriptor->ist = 0;
  descriptor->attributes = flags;
  descriptor->isr_mid = ((uint64_t)isr >> 16) & 0xFFFF;
  descriptor->isr_high = ((uint64_t)isr >> 32) & 0xFFFFFFFF;
  descriptor->reserved = 0;
}

void idt_init() {
  idtr.base = (uintptr_t)&idt[0];
  idtr.limit = (uint16_t)sizeof(idt_entry_t) * IDT_MAX_DESCRIPTORS - 1;

  isr_init();
  irq_init();

  __asm__ volatile("lidt %0" : : "m"(idtr)); // load the new IDT
  __asm__ volatile("sti");                   // set the interrupt flag
}
