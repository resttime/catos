#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f

// I/O Ports
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

void print_char(char ch, int col, int row, char attr);
int get_screen_offset(int col, int row);
int get_cursor();
void set_cursor(int offset);
void print_at(char *msg, int col, int row);
void print_msg(char *msg);
void clear_screen();
int handle_scrolling(int cursor_offset);
