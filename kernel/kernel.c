#include "../drivers/screen.h"
#include "interrupt.h"

void _start() {
  clear_screen();
  print_at("> Booted OS Kernel", 0, 0);
  set_cursor(get_screen_offset(0, 1));
  idt_init();
  print_at("> IDT Initialized", 0, 1);
  set_cursor(get_screen_offset(0, 2));

  __asm__("hlt");
}
