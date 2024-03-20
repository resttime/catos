#include "idt.h"
#include "low_level.h"
#include "pic8259.h"
#include "screen.h"

extern int strlen(char *);

void _start() {
  clear_screen();
  print_at("> Booted OS Kernel", 0, 0);
  idt_init();
  print_at("> IDT Initialized", 0, 1);
  pic_remap();
  print_at("> PIC Remapped", 0, 2);
  set_cursor(get_screen_offset(0, 3));

  int l = strlen("123");
  print_char('0' + l, 0, 15, 0);

  __asm__ volatile("int $0x00");
  __asm__ volatile("int $0x03");

  for (;;)
    ;

  __asm__ volatile("cli; hlt");
}
