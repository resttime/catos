#include "../drivers/screen.h"

void main() {
    clear_screen();
    print_at("> Welcome to your new operating system!", 0, 0);
    set_cursor(get_screen_offset(0, 1));
}
