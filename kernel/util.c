#include "util.h"

void memcpy(const char *src, char *dest, int size) {
  for (int i = 0; i < size; i++) {
    dest[i] = src[i];
  }
}
