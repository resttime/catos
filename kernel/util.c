#include "util.h"

void memcpy(char *src, char *dest, int size) {
  for (int i = 0; i < size; i++) {
    dest[i] = src[i];
  }
}
