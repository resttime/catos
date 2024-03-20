#include <stdint.h>

#include "low_level.h"
#include "pic8259.h"

void pic_sendEOI(uint8_t irq) {
  if (irq >= 8)
    outb(PIC2_COMMAND, PIC_EOI);

  outb(PIC1_COMMAND, PIC_EOI);
}

/*
Normally, IRQs 0 to 7 are mapped to entries 8 to 15. This is a problem
in protected mode, because IDT entry 8 is a Double Fault!  Without
remapping, every time IRQ0 fires, you get a Double Fault Exception,
which is NOT actually what's happening. We send commands to the
Programmable Interrupt Controller (PICs - also called the 8259's) in
order to make IRQ0 to 15 be remapped to IDT entries 32 to 47
*/
void pic_remap() {
  uint8_t a1, a2;

  // save masks
  a1 = inb(PIC1_DATA);
  a2 = inb(PIC2_DATA);

  // starts the initialization sequence (in cascade mode)
  outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
  outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);

  // ICW2: Master PIC IRQs 0-7 mapped to use interrupts 32-39, 0x20-0x27
  outb(PIC1_DATA, 0x20);
  // ICW2: Slave PIC IRQs 8-15 mapped to use interrupts 40-47, 0x28-0x36
  outb(PIC2_DATA, 0x28);

  // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
  outb(PIC1_DATA, 4);
  // ICW3: tell Slave PIC its cascade identity (0000 0010)
  outb(PIC2_DATA, 2);

  // ICW4: have the PICs use 8086 mode (and not 8080 mode)
  outb(PIC1_DATA, ICW4_8086);
  outb(PIC2_DATA, ICW4_8086);

  // restore saved masks
  outb(PIC1_DATA, a1);
  outb(PIC2_DATA, a2);
}

void pic_disable(void) {
  outb(PIC1_DATA, 0xff);
  outb(PIC2_DATA, 0xff);
}

void irq_set_mask(uint8_t IRQline) {
  uint16_t port;
  uint8_t value;

  if (IRQline < 8) {
    port = PIC1_DATA;
  } else {
    port = PIC2_DATA;
    IRQline -= 8;
  }
  value = inb(port) | (1 << IRQline);
  outb(port, value);
}

void irq_clear_mask(uint8_t IRQline) {
  uint16_t port;
  uint8_t value;

  if (IRQline < 8) {
    port = PIC1_DATA;
  } else {
    port = PIC2_DATA;
    IRQline -= 8;
  }
  value = inb(port) & ~(1 << IRQline);
  outb(port, value);
}

/* Helper func */
static uint16_t __pic_get_irq_reg(int ocw3) {
  /* OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
   * represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain */
  outb(PIC1_COMMAND, ocw3);
  outb(PIC2_COMMAND, ocw3);
  return (inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND);
}

/* Returns the combined value of the cascaded PICs irq request register */
uint16_t pic_get_irr(void) { return __pic_get_irq_reg(PIC_READ_IRR); }

/* Returns the combined value of the cascaded PICs in-service register */
uint16_t pic_get_isr(void) { return __pic_get_irq_reg(PIC_READ_ISR); }
