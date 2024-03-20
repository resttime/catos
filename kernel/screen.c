#include "low_level.h"
#include "util.h"

#include "screen.h"

void print_char(char ch, int col, int row, char attr) {
  unsigned char *video = (unsigned char *)VIDEO_ADDRESS;

  if (!attr) {
    attr = WHITE_ON_BLACK;
  }

  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_screen_offset(col, row);
  } else {
    offset = get_cursor();
  }

  if (ch == '\n') {
    int rows = offset / (2 * MAX_COLS);
    offset = get_screen_offset(79, rows);
  } else {
    video[offset] = ch;
    video[offset + 1] = attr;
  }
  offset += 2;
  offset = handle_scrolling(offset);
  set_cursor(offset);
}

uintptr_t get_screen_offset(int col, int row) {
  return (row * MAX_COLS + col) * 2;
}

int get_cursor() {
  outb(REG_SCREEN_CTRL, 14);
  int offset = inb(REG_SCREEN_DATA) << 8;
  outb(REG_SCREEN_CTRL, 15);
  offset += inb(REG_SCREEN_DATA);
  return offset * 2;
}

void set_cursor(int offset) {
  offset /= 2;
  outb(REG_SCREEN_CTRL, 15);
  outb(REG_SCREEN_DATA, offset);
  outb(REG_SCREEN_CTRL, 14);
  outb(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
}

void print_at(const char *msg, int col, int row) {
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row));
  }
  for (int i = 0; msg[i] != 0; i++) {
    print_char(msg[i], col++, row, WHITE_ON_BLACK);
  }
}

void print_msg(const char *msg) { print_at(msg, -1, -1); }

void clear_screen() {
  for (int row = 0; row < MAX_ROWS; row++) {
    for (int col = 0; col < MAX_COLS; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }
  set_cursor(get_screen_offset(0, 0));
}

int handle_scrolling(int cursor_offset) {
  if (cursor_offset < MAX_ROWS * MAX_COLS * 2) {
    return cursor_offset;
  }

  for (int i = 1; i < MAX_ROWS; i++) {
    memcpy((char *)(get_screen_offset(0, i) + VIDEO_ADDRESS),
           (char *)(get_screen_offset(0, i - 1) + VIDEO_ADDRESS), MAX_COLS * 2);
  }

  char *last_line =
      (char *)(get_screen_offset(1, MAX_ROWS - 1) + VIDEO_ADDRESS);
  for (int i = 0; i < MAX_COLS * 2; i++) {
    last_line[i] = 0;
  }

  cursor_offset -= 2 * MAX_COLS;

  return cursor_offset;
}
