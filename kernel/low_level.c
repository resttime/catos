#include "low_level.h"

unsigned char inb(unsigned short port) {
  unsigned char result;
  // "=a" : put AL register in result
  // "d" : load EDX with port
  __asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
  return result;
}

void outb(unsigned short port, unsigned char data) {
  // "a" : load eax with data
  // "d" : load edx with port
  __asm__("out %%al, %%dx" : : "a"(data), "d"(port));
}

unsigned short inw(unsigned short port) {
  unsigned short result;
  __asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
  return result;
}

void outw(unsigned short port, unsigned short data) {
  __asm__("out %%ax, %%dx" : : "a"(data), "d"(port));
}
