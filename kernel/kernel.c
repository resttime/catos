#include "../drivers/screen.h"

void _start() {
  clear_screen();
  print_at("> Booted OS Kernel", 0, 0);
  set_cursor(get_screen_offset(0, 1));

  __asm__("hlt");
}
