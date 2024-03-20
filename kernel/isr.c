#include "isr.h"
#include "idt.h"
#include "screen.h"

extern void *isr_stub_table[];

const char *exception_messages[] = {"[0x00] Divide by Zero Exception",
                                    "[0x01] Debug Exception",
                                    "[0x02] Unhandled Non-maskable Interrupt",
                                    "[0x03] Breakpoint Exception",
                                    "[0x04] Overflow Exception",
                                    "[0x05] Bound Range Exceeded Exception",
                                    "[0x06] Invalid Opcode/Operand Exception",
                                    "[0x07] Device Unavailable Exception",
                                    "[0x08] Double Fault",
                                    "[0x09] Coprocessor Segment Overrun",
                                    "[0x0A] Invalid TSS Exception",
                                    "[0x0B] Absent Segment Exception",
                                    "[0x0C] Stack-segment Fault",
                                    "[0x0D] General Protection Fault",
                                    "[0x0E] Page Fault",
                                    "[0x0F] Inexplicable Error",
                                    "[0x10] x87 Floating Exception",
                                    "[0x11] Alignment Check",
                                    "[0x12] Machine Check",
                                    "[0x13] SIMD Floating Exception",
                                    "[0x14] Virtualized Exception",
                                    "[0x15] Control Protection Exception",
                                    "[0x16] Inexplicable Error",
                                    "[0x17] Inexplicable Error",
                                    "[0x18] Inexplicable Error",
                                    "[0x19] Inexplicable Error",
                                    "[0x1A] Inexplicable Error",
                                    "[0x1B] Inexplicable Error",
                                    "[0x1C] Hypervisor Intrusion Exception",
                                    "[0x1D] VMM Communications Exception",
                                    "[0x1E] Security Exception",
                                    "[0x1F] Inexplicable Error"};

typedef struct __attribute__((__packed__)) {
  uint64_t vector;
  uint64_t error_code;
  uint64_t rip;
  uint64_t cs;
  uint64_t rflags;
  uint64_t rsp;
  uint64_t ss;
} frame_t;

// __attribute__((noreturn)) void exception_handler(void);
void exception_handler_0(frame_t *f) {
  print_char('0' + f->vector, 0, 12, 0);
  __asm__ volatile("hlt;");
  print_at(exception_messages[0], 0, 10);
}
void exception_handler_1() { print_at(exception_messages[1], 0, 10); }
void exception_handler_2() { print_at(exception_messages[2], 0, 10); }
void exception_handler_3() { print_at(exception_messages[3], 0, 10); }
void exception_handler_4() { print_at(exception_messages[4], 0, 10); }
void exception_handler_5() { print_at(exception_messages[5], 0, 10); }
void exception_handler_6() { print_at(exception_messages[6], 0, 10); }
void exception_handler_7() { print_at(exception_messages[7], 0, 10); }
void exception_handler_8() { print_at(exception_messages[8], 0, 10); }
void exception_handler_9() { print_at(exception_messages[9], 0, 10); }
void exception_handler_10() { print_at(exception_messages[10], 0, 10); }
void exception_handler_11() { print_at(exception_messages[11], 0, 10); }
void exception_handler_12() { print_at(exception_messages[12], 0, 10); }
void exception_handler_13() { print_at(exception_messages[13], 0, 10); }
void exception_handler_14() { print_at(exception_messages[14], 0, 10); }
void exception_handler_15() { print_at(exception_messages[15], 0, 10); }
void exception_handler_16() { print_at(exception_messages[16], 0, 10); }
void exception_handler_17() { print_at(exception_messages[17], 0, 10); }
void exception_handler_18() { print_at(exception_messages[18], 0, 10); }
void exception_handler_19() { print_at(exception_messages[19], 0, 10); }
void exception_handler_20() { print_at(exception_messages[20], 0, 10); }
void exception_handler_21() { print_at(exception_messages[21], 0, 10); }
void exception_handler_22() { print_at(exception_messages[22], 0, 10); }
void exception_handler_23() { print_at(exception_messages[23], 0, 10); }
void exception_handler_24() { print_at(exception_messages[24], 0, 10); }
void exception_handler_25() { print_at(exception_messages[25], 0, 10); }
void exception_handler_26() { print_at(exception_messages[26], 0, 10); }
void exception_handler_27() { print_at(exception_messages[27], 0, 10); }
void exception_handler_28() { print_at(exception_messages[28], 0, 10); }
void exception_handler_29() { print_at(exception_messages[29], 0, 10); }
void exception_handler_30() { print_at(exception_messages[30], 0, 10); }
void exception_handler_31() { print_at(exception_messages[31], 0, 10); }

void isr_init() {
  for (uint8_t vector = 0; vector < 32; vector++) {
    idt_set_descriptor(vector, isr_stub_table[vector], 0x8E);
  }
}
