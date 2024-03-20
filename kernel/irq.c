#include "irq.h"
#include "idt.h"
#include "low_level.h"
#include "screen.h"

extern void *irq_stub_table[];

// __attribute__((noreturn)) void irq_handler(void);
void irq_handler_0() {
  print_at("irq_handler_0", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_1() {
  print_at("irq_handler_1", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_2() {
  print_at("irq_handler_2", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_3() {
  print_at("irq_handler_3", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_4() {
  print_at("irq_handler_4", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_5() {
  print_at("irq_handler_5", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_6() {
  print_at("irq_handler_6", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_7() {
  print_at("irq_handler_7", 0, 11);
  outb(0x20, 0x20);
}
void irq_handler_8() {
  print_at("irq_handler_8", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_9() {
  print_at("irq_handler_9", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_10() {
  print_at("irq_handler_10", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_11() {
  print_at("irq_handler_11", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_12() {
  print_at("irq_handler_12", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_13() {
  print_at("irq_handler_13", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_14() {
  print_at("irq_handler_14", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}
void irq_handler_15() {
  print_at("irq_handler_15", 0, 11);
  outb(0xA0, 0x20);
  outb(0x20, 0x20);
}

// PIC remap 16 IRQ to IDT 32-47
void irq_init() {
  for (uint8_t vector = 32; vector < 48; vector++) {
    idt_set_descriptor(vector, irq_stub_table[vector - 32], 0x8E);
  }
}
