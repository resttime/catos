#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "string.h"

void test_strlen() {
  char *s = "hi";
  assert(strlen(s) == 2);
}

void test_strcmp() {
  char *s1 = "hi";
  char *s2 = "hi";
  char *s3 = "h";
  assert(strcmp(s1, s2) == 0);
  assert(strcmp(s2, s3) > 0);
  assert(strcmp(s3, s2) < 0);
}

void test_strcpy() {
  char *dst = (char *)malloc(3);
  char *src = "hi";
  strcpy(dst, src);
  assert(strcmp(dst, src) == 0);
}

int main() {
  test_strlen();
  test_strcmp();
  test_strcpy();
  return 0;
}
