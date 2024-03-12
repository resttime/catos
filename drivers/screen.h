#ifndef SCREEN_H
#define SCREEN_H
#include <stdint.h>

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f // ((FG & 0x0F) << 4) | ((BG & 0x0F))

// I/O Ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

void print_char(char ch, int col, int row, char attr);
uintptr_t get_screen_offset(int col, int row);
int get_cursor();
void set_cursor(int offset);
void print_at(const char *msg, int col, int row);
void print_msg(const char *msg);
void clear_screen();
int handle_scrolling(int cursor_offset);

#endif
